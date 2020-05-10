#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/capability.h>
#include <sys/prctl.h>
#include <signal.h>
#include "../common.h"

uid_t saved_ruid;

static void boing(int sig)
{
  printf("*(boing!)*\n");
}

static void usage(char **argv, int stat)
{
  fprintf(stderr, "Usage: %s 1|2\n"
                  " 1 : add just one capability - CAP_SETUID\n"
                  " 2 : add two capabilities - CAP_SETUID and CAP_SYS_ADMIN\n"
                  "Tip: run it in the background so that capsets can be looked up\n",
          argv[0]);
  exit(stat);
}

static void test_setuid(void)
{
  printf("%s:\nRUID = %d EUID = %d\n", __FUNCTION__, getuid(), geteuid());
  if (setreuid(0, 0) == -1)
    WARN("setreuid(0, 0) failed...\n");
  printf("RUID = %d EUID = %d\n", getuid(), geteuid());
  system("apt-get check");
}

static void revert_uid(void)
{
  /* Become your normal true self again! */
  if (setreuid(saved_ruid, saved_ruid) < 0)
    FATAL("setreuid to lower privileges failed, aborting..\n");
}

static void drop_caps_be_normal(void)
{
  cap_t none;

  /* Become your normal true self again! */
  if (setreuid(saved_ruid, saved_ruid) < 0)
    FATAL("setreuid to lower privileges failed, aborting..\n");

  /* cap_init() guarantees all caps are cleared */
  if ((none = cap_init()) == NULL)
    FATAL("cap_init() failed, aborting...\n");
  if (cap_set_proc(none) == -1)
  {
    cap_free(none);
    FATAL("cap_set_proc('none') failed, aborting...\n");
  }
  cap_free(none);
}

static void add_caps(void)
{
  int ncap;
  cap_t mycaps;
  cap_value_t caps2set[2];

  printf("Add cap!!!\n");

  //--- Set the required capabilities in the Thread Eff capset
  mycaps = cap_get_proc();
  if (!mycaps)
  {
    FATAL("cap_get_proc() for CAP_SETUID failed, aborting...\n");
  }

  ncap = 2;
  caps2set[0] = CAP_SETUID;
  caps2set[1] = CAP_SYS_ADMIN;

  if (cap_set_flag(mycaps, CAP_EFFECTIVE, ncap, caps2set, CAP_SET) == -1)
  {
    cap_free(mycaps);
    FATAL("cap_set_flag() failed, aborting...\n");
  }

  if (cap_set_proc(mycaps) == -1)
  {
    cap_free(mycaps);
    FATAL("cap_set_proc() failed, aborting...\n");
  }

  cap_free(mycaps);
}

int main(int argc, char *argv[])
{

  saved_ruid = getuid();

  // keeping the capabilities after UID transition
  if (prctl(PR_SET_KEEPCAPS, 1, 0, 0, 0))
    FATAL("prctl(PR_SET_KEEPCAPS, 1L) failed, aborting...\n");

  /* Simple signal handling for the pause... */
  if (signal(SIGINT, boing) == SIG_ERR)
    FATAL("signal() SIGINT failed, aborting...\n");
  if (signal(SIGTERM, boing) == SIG_ERR)
    FATAL("signal() SIGTERM failed, aborting...\n");

  for (int i = 0; i < 3; i++)
  {
    printf("\nStart Testing: %d\n\n", i);
    add_caps();
    printf("Pausing #1 ...\n");
    pause();
    test_setuid();

    if (i == 2)
    {
      printf("Now dropping all capabilities and reverting to original self...\n");
      drop_caps_be_normal();
      test_setuid();
    }
    else
    {
      revert_uid();
    }

    printf("Pasuing #2 ...\n");
    // pause();
    printf("...done, exiting.\n");
  }
  exit(EXIT_SUCCESS);
}