# Linux Virtual Input Devices with Common Lisp

* userspace virtual input devices
* uinput documentation: https://www.kernel.org/doc/html/v4.12/input/uinput.html
* see github.com/jtgans/cl-evdev for linux input device events
* see https://who-t.blogspot.com/2016/05/the-difference-between-uinput-and-evdev.html for an introduction to uinput virtual devices

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
* register real input device /dev/input/event4
* read real keyboard with cl-evdev thread, signal thread close
* register /dev/input/eventN virtual device events
* read /dev/input/eventN through evdev
* compile and run vm.c from SBCL
* register input from keyboard device to virtual device
* define and send macros from keyboard -> SBCL -> uinput virtual device
