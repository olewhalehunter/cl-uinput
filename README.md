# Linux Virtual Input Devices in CL

* userspace virtual input devices
* multiplex, filter, and process input devices with Common Lisp
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
* see dependencies in uinput_listener.c

# Install
* (load "cl-uinput.asd")
* (ql:quickload :cl-uinput)
* gcc uinput_listener.c -o uinput_listener

# Todo
* sbcl evdev keys global REPL then
* record -> uinput pipe
* register /dev/input/event4 virtual device events (send-key)
* key macro uint_listener, from record (hotkey begin)
* define and send macros from keyboard -> SBCL -> uinput virtual device
