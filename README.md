# Linux Virtual Devices with Common Lisp
* userspace virtual input devices
* uinput documentation:
* https://www.kernel.org/doc/html/v4.12/input/uinput.html
* see github.com/jtgans/cl-evdev for linux device event docuemtnation
* see https://who-t.blogspot.com/2016/05/the-difference-between-uinput-and-evdev.html for an introduction to uinput virtual devices
.
# Dependencies
* apt-get install libfixposix-dev
* http://github.com/jtgans/cl-evdev
* http://github.com/jtgans/cl-event-handler
* https://github.com/cffi-posix/fd-gray
* https://github.com/sionescu/iolib
* run (load-dependencies) in cl-uinput.lisp
* see dependencies in vm.c

# Install
* (load "cl-uinput.asd")
* (ql:quickload :cl-uinput)
* gcc vm.c

# Todo
* list common cl-evdev keycodes
* read /dev/uinput through evdev
* compile and run vm.c from SBCL
* send keys thrugh vm.c
* define and send macros from SBCL over to uinput virtual device
