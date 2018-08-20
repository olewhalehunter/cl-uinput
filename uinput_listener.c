#include <stdio.h>
#include <errno.h>
#include <ncurses.h>
#include <linux/input.h>
#include <linux/uinput.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <termkey.h>
#include <sys/stat.h>
#include <sys/types.h>

#define MAX_BUF 2048
#define PIPE_FILE "/tmp/cl-uinput-pipe"

void uinput_write(int fd, int type, int code, int val)
{
   struct input_event ie;
   ie.type = type;
   ie.code = code;
   ie.value = val;
   ie.time.tv_sec = 0;
   ie.time.tv_usec = 0;
   write(fd, &ie, sizeof(ie));
}

int main(void)
{
   struct uinput_setup usetup;
   
   int fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);   
   if (fd == 1){
     puts("Error opening /dev/uinput");
     return -1; 
   }

   int pipe_fd;
   char * fifo_file = PIPE_FILE;
   char input_pipe_buf[MAX_BUF];
   mkfifo(fifo_file, 4464);
   pipe_fd = open(fifo_file, O_RDONLY);   

   ioctl(fd, UI_SET_EVBIT, EV_KEY);
   ioctl(fd, UI_SET_KEYBIT, KEY_G);
   ioctl(fd, UI_SET_KEYBIT, KEY_X);
   memset(&usetup, 0, sizeof(usetup));
   usetup.id.bustype = BUS_USB;
   usetup.id.vendor = 0x0044;
   usetup.id.product = 0x4434;
   strcpy(usetup.name, "CL-UINPUT Lisp Virtual Device");
   ioctl(fd, UI_DEV_SETUP, &usetup);
   ioctl(fd, UI_DEV_CREATE);

   char sysfs_device_name[16];
   ioctl(fd, UI_GET_SYSNAME(sizeof(sysfs_device_name)), sysfs_device_name);
   puts("Checking virtual device...\n");
   printf("/sys/devices/virtual/input/%s\n", sysfs_device_name);

   int steps;
   steps = 300;
   while (steps > 0){
     usleep(10);
     puts("Listening...\n");
     
     read(pipe_fd, input_pipe_buf, MAX_BUF);

     if ((input_pipe_buf[0] == ':') && (input_pipe_buf[1] == 'q')){
       return -1;
     } else {
       printf("pipe listener buffer %s\n", input_pipe_buf);      
     }
     steps--;
   }
   close(pipe_fd);
        
   uinput_write(fd, EV_KEY, KEY_G, 1);
   uinput_write(fd, EV_SYN, SYN_REPORT, 0);
   usleep(100);
   uinput_write(fd, EV_KEY, KEY_G, 0);
   uinput_write(fd, EV_SYN, SYN_REPORT, 0);
    
   uinput_write(fd, EV_KEY, KEY_X, 1);
   uinput_write(fd, EV_SYN, SYN_REPORT, 0);
   usleep(100);
   uinput_write(fd, EV_KEY, KEY_X, 0);
   uinput_write(fd, EV_SYN, SYN_REPORT, 0);

   ioctl(fd, UI_DEV_DESTROY);
   close(fd);

   puts ("Closing uinput pipe!");

   return 0;
}
