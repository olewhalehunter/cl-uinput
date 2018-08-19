# Linux Virtual Device Interfaces with Common Lisp
* userspace virtual input devices
* uinput documentation:
* https://www.kernel.org/doc/html/v4.12/input/uinput.html
* see github.com/jtgans/cl-evdev for linux device event docuemtnation

.
# Install
- (load "cl-uinput.asd")
- (ql:quickload :cl-uinput)
- see dependencies in vm.c
- Compile it with "make". Install any missing libraries if the compilation fails.


# Todo
* gcc vm.c
* register vm.c in lisp
