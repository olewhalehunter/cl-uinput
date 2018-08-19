# Linux Virtual Device Interfaces with Common Lisp
* userspace virtual input devices
* uinput documentation:
* https://www.kernel.org/doc/html/v4.12/input/uinput.html
* see github.com/jtgans/cl-evdev for linux device event docuemtnation

.
# Dependencies
* http://github.com/jtgans/cl-evdev
* (load "cl-evdev.asd")
* http://github.com/jtgans/cl-event-handler
* (load "cl-event-handler.asd")
* (ql:quickload :cl-evdev)
* see dependencies in vm.c

# Install
* (load "cl-uinput.asd")
* (ql:quickload :cl-uinput)
* Compile it with "make". Install any missing libraries if the compilation fails.


# Todo
* gcc vm.c
* register vm.c in lisp
