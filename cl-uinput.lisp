;; CL-UINPUT.LISP
;; uinput virtual device drivers in Common Lisp
;; By writing to /dev/uinput device, a process can create a virtual input device with specific capabilities. Once this virtual device is created, the process can send events through it, that will be delivered to userspace and in-kernel consumers.
;; see README.md

(defun load-dependencies ()
  (load "cl-evdev/cl-evdev.asd")
  (load "cl-event-handler/cl-event-handler.asd")
  (mapcar #'ql:quickload '(:cl-event-handler
			   :cl-evdev))
  )



(defun read-device (device-file)
  "read virtual or real device"
  (cl-evdev::with-evdev-device 
      (in device-file)
    (cond ((typep in 'RELATIVE-EVENT)
	   (handle-scroll in))
	  ((typep in 'ABSOLUTE-EVENT)
	   (handle-pen in))
	  ((typep in 'KEYBOARD-EVENT)
	   (handle-button in))
	  (t nil))))

'(
  (read-device"/dev/input/wacom")
  )


(defun compile-c-driver ()
  "virtual device driver emitter"
  (setq
   "headers"
   '("#include <stdio.h>"
     "#include <errno.h>"
     "#include <ncurses.h>"
     "#include <linux/input.h>"
     "#include <linux/uinput.h>"
     "#include <unistd.h>"
     "#include <string.h>"
     "#include <fcntl.h>"
     "#include <termkey.h>"))

  ;; emit(fd,  .. ) write(fd, ) input_event to device file fd
  ;; main(void) ; fd = open("/dev/uinput")
  ;; allocate uinput_setup struct usetup
  ;; UI_DEV_CREATE kernel creates device node
  ;; sleep(1), pause to wait for load + new input
  ;; emit(fd, EV_KEY, KEY_SPACE, 1)
  ;;
  ;; ioctl(fd, UI_DEV_DESTROY)
  ;; close(fd)
  ;; return(0);
  )
