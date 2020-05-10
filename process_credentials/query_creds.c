#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include <stdio.h>

uid_t getuid(void);
uid_t geteuid(void);
gid_t getgid(void);
gid_t getegid(void);

#define SHOW_CREDS()             \
  do                             \
  {                              \
    printf("RUID=%d EUID=%d\n"   \
           "RGID=%d EGID=%d\n",  \
           getuid(), geteuid(),  \
           getgid(), getegid()); \
  } while (0)

int main(int argc, char **argv)
{
  SHOW_CREDS();
  if (geteuid() == 0)
  {
    printf("%s now effectively running as root! ...\n", argv[0]);
    sleep(1);
  }
  exit(EXIT_SUCCESS);
}