/***************************************************************************
 *
 * Functions for Linux platform (terminal I/O, etc.)
 *
 ***************************************************************************/

#include <termios.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>

static struct termios ti_old[1];

void forth_cio_init(void)
{
  struct termios ti[1];

  tcgetattr(0, ti);
  memcpy(ti_old, ti, sizeof(*ti_old));

  ti->c_lflag &= ~(ICANON | ECHO);
  ti->c_cc[VMIN]  = 1;
  ti->c_cc[VTIME] = 0;

  tcsetattr(0, TCSANOW, ti);
}

void forth_cio_restore(void)
{
  tcsetattr(0, TCSANOW, ti_old);
}

void forth_cio_emit(char c)
{
  write(1, &c, 1);
}

unsigned forth_cio_qkey(void)
{
  int n;

  ioctl(0, FIONREAD, &n);

  return (n != 0);
}

unsigned forth_cio_key(void)
{
  char c;
  
  read(0, &c, 1);

  return (c);
}
