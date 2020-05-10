#include <stdlib.h>

int main(int argc, char **argv)
{
  /* Just spawn a shell.
   * If this process runs as root,
   * then, <i>Evil Laugh</i>, we're now root!
   */
  system("id -u");
  exit(EXIT_SUCCESS);
}