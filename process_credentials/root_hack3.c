#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include "../common.h"

int main(int argc, char **argv)
{
  SHOW_CREDS();
  uid_t saved_euid = geteuid();
  uid_t saved_ruid = getuid();

  if (seteuid(getuid()) == -1)
    WARN("seteuid(getuid()) failed!\n");

  SHOW_CREDS();

  // test 1 - set euid to 0, but don't change the ruid
  // "apt-get check" failed due to permission denied
  if (seteuid(saved_euid) == -1)
    WARN("seteuid(saved_setuid) failed!\n");

  SHOW_CREDS();

  system("apt-get check");

  // test 1 - set euid to 0, but don't change the ruid
  // "apt-get check" failed due to permission denied
  if (setreuid(0, saved_euid) == -1)
    WARN("setreuid(0, saved_euid) failed!\n");

  SHOW_CREDS();

  system("apt-get check");

  // reset the ruid and euid
  if (setreuid(saved_ruid, saved_ruid) == -1)
  WARN("setreuid(saved_ruid, saved_euid) failed!\n");

  SHOW_CREDS();

  exit(EXIT_SUCCESS);
}