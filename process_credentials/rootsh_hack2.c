#include <stdlib.h>
#include <unistd.h>
#include "../common.h"


int main(int argc, char **argv)
{
  SHOW_CREDS();
  /* Become root */
  /* setuid to root will fail if
   *   the file's owner is not root or
   *   the file's setuid bit is not 's'
   */
  if (setuid(0) == -1)
    WARN("setuid(0) failed!\n");

  /* Now just spawn a shell;
   * <i>Evil Laugh</i>, we're now root!
   */
  system("/bin/bash");
  exit(EXIT_SUCCESS);
}