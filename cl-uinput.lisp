;; CL-UINPUT.LISP
;; uinput virtual device drivers in Common Lisp
;; By writing to /dev/uinput device, a process can create a virtual input device with specific capabilities. Once this virtual device is created, the process can send events through it, that will be delivered to userspace and in-kernel consumers.
;; see README.md

(in-package :cl-uinput)

(defun load-dependencies () ;; (load-dependencies)
  (load "cl-evdev/cl-evdev.asd")
  (load "cl-event-handler/cl-event-handler.asd")
  (load "fd-gray/fd-gray.asd")
  (mapcar #'ql:quickload '(:cl-event-handler
			   :cl-evdev
			   :iolib
			   :iolib/os
			   :bordeaux-threads
			   :cffi
			   ;;:fd-gray
			   ))
  (load "cl-uinput.asd")
  (ql:quickload :cl-uinput)
  (use-package :cl-evdev)
  )

(defun list-devices ()
  (iolib/os:list-directory "/dev/"))

(defun list-input-devices ()
  (iolib/os:list-directory "/dev/input/by-id")
  )

(defun virtual-directory ()
  (let ((cd (iolib/os:current-directory)))
    '()
    ))

(defun unistd-write (filename)
  (let ((seq (make-array 128 '(unsigned-byte 8))))
    (fd-gray:with-output-stream
	;; fcntl write-only
	(out (fcntl:open file-name fcntl:+o-wronly+))
      (write-sequence seq out))))

(defun receive-key-event (event)
  (with-slots (cl-evdev::name) event
    (progn
      (case cl-evdev::name
	('cl-evdev::l (print "L pressed"))
	('cl-evdev::g (print "G pressed"))
	('cl-evdev::t (print "T pressed"))
	('cl-evdev::space (print "Space pressed"))
	)
      )))

(defun read-device (device-file)
  "read virtual or real device"
  (cl-evdev:with-evdev-device (in device-file)
    (cond
      ;;((typep in 'cl-evdev::RELATIVE-EVENT)
      ;; (receive-key-event in))
      ;;((typep in 'cl-evdev::ABSOLUTE-EVENT)
      ;; (receive-key-event in))
      ((typep in 'KEYBOARD-EVENT)
       (receive-key-event in))
      (t nil))))


(defun thread-fn ()
  ;;  (read-device "/dev/input/event18")
  (read-device "/dev/input/event4") ;; keyboard
  )

(setq event-thread
  (bordeaux-threads:make-thread 'thread-fn :name "evdev read thread"))

(defun destroy-event-loop-thread ()
  (bordeaux-threads:destroy-thread event-thread))

;; "/dev/input/event18" created for uinput

'(
  (read-device "/dev/input/wacom")
  (read-device "/dev/uinput")
  )

(defun run-virtual-driver-manage ()
  (asdf::run-program "./a.out" :output t)
  )

(defun test-virtual-device ()
  (run-virtual-driver-manage)
  (read-device "/dev/uinput")
  )

(defun compile-c-driver ()
  "virtual device driver emitter"
  (setq
   headers
   '("#include <stdio.h>"
     "#include <errno.h>"
     "#include <ncurses.h>"
     "#include <linux/input.h>"
     "#include <linux/uinput.h>"
     "#include <unistd.h>"
     "#include <string.h>"
     "#include <fcntl.h>"
     "#include <termkey.h>"))
  '(
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

  ;; (DEFSYSCALL .. in IOLIB
  )

(define-constant +cl-evdev-input-codes+
    '(
      ;; Keyboard      
      (0 .   (:name reserved         :glyph nil))
      (1 .   (:name esc              :glyph nil))
      (2 .   (:name 1                :glyph #\1))
      (3 .   (:name 2                :glyph #\2))
      (4 .   (:name 3                :glyph #\3))
      (5 .   (:name 4                :glyph #\4))
      (6 .   (:name 5                :glyph #\5))
      (7 .   (:name 6                :glyph #\6))
      (8 .   (:name 7                :glyph #\7))
      (9 .   (:name 8                :glyph #\8))
      (10 .  (:name 9                :glyph #\9))
      (11 .  (:name 0                :glyph #\0))
      (12 .  (:name minus            :glyph #\-))
      (13 .  (:name equal            :glyph #\=))
      (14 .  (:name backspace        :glyph #\Backspace))
      (15 .  (:name tab              :glyph #\Tab))
      (16 .  (:name q                :glyph #\q))
      (17 .  (:name w                :glyph #\w))
      (18 .  (:name e                :glyph #\e))
      (19 .  (:name r                :glyph #\r))
      (20 .  (:name t                :glyph #\t))
      (21 .  (:name y                :glyph #\y))
      (22 .  (:name u                :glyph #\u))
      (23 .  (:name i                :glyph #\i))
      (24 .  (:name o                :glyph #\o))
      (25 .  (:name p                :glyph #\p))
      (26 .  (:name leftbrace        :glyph #\[))
      (27 .  (:name rightbrace       :glyph #\]))
      (28 .  (:name enter            :glyph #\Newline))
      (29 .  (:name leftctrl         :glyph nil))
      (30 .  (:name a                :glyph #\a))
      (31 .  (:name s                :glyph #\s))
      (32 .  (:name d                :glyph #\d))
      (33 .  (:name f                :glyph #\f))
      (34 .  (:name g                :glyph #\g))
      (35 .  (:name h                :glyph #\h))
      (36 .  (:name j                :glyph #\j))
      (37 .  (:name k                :glyph #\k))
      (38 .  (:name l                :glyph #\l))
      (39 .  (:name semicolon        :glyph #\;))
      (40 .  (:name apostrophe       :glyph #\'))
      (41 .  (:name grave            :glyph #\`))
      (42 .  (:name leftshift        :glyph nil))
      (43 .  (:name backslash        :glyph #\\))
      (44 .  (:name z                :glyph #\z))
      (45 .  (:name x                :glyph #\x))
      (46 .  (:name c                :glyph #\c))
      (47 .  (:name v                :glyph #\v))
      (48 .  (:name b                :glyph #\b))
      (49 .  (:name n                :glyph #\n))
      (50 .  (:name m                :glyph #\m))
      (51 .  (:name comma            :glyph #\,))
      (52 .  (:name dot              :glyph #\.))
      (53 .  (:name slash            :glyph #\/))
      (54 .  (:name rightshift       :glyph nil))
      (55 .  (:name kpasterisk       :glyph #\*))
      (56 .  (:name leftalt          :glyph nil))
      (57 .  (:name space            :glyph #\Space))
      (58 .  (:name capslock         :glyph nil))
      (59 .  (:name f1               :glyph nil))
      (60 .  (:name f2               :glyph nil))
      (61 .  (:name f3               :glyph nil))
      (62 .  (:name f4               :glyph nil))
      (63 .  (:name f5               :glyph nil))
      (64 .  (:name f6               :glyph nil))
      (65 .  (:name f7               :glyph nil))
      (66 .  (:name f8               :glyph nil))
      (67 .  (:name f9               :glyph nil))
      (68 .  (:name f10              :glyph nil))
      (69 .  (:name numlock          :glyph nil))
      (70 .  (:name scrolllock       :glyph nil))
      (71 .  (:name kp7              :glyph nil))
      (72 .  (:name kp8              :glyph nil))
      (73 .  (:name kp9              :glyph nil))
      (74 .  (:name kpminus          :glyph nil))
      (75 .  (:name kp4              :glyph nil))
      (76 .  (:name kp5              :glyph nil))
      (77 .  (:name kp6              :glyph nil))
      (78 .  (:name kpplus           :glyph nil))
      (79 .  (:name kp1              :glyph nil))
      (80 .  (:name kp2              :glyph nil))
      (81 .  (:name kp3              :glyph nil))
      (82 .  (:name kp0              :glyph nil))
      (83 .  (:name kpdot            :glyph #\.))
      (85 .  (:name zenkakuhankaku   :glyph nil))
      (86 .  (:name 102nd            :glyph nil))
      (87 .  (:name f11              :glyph nil))
      (88 .  (:name f12              :glyph nil))
      (96 .  (:name kpenter          :glyph #\Newline))
      (97 .  (:name rightctrl        :glyph nil))
      (98 .  (:name kpslash          :glyph nil))
      (99 .  (:name sysrq            :glyph nil))
      (100 . (:name rightalt         :glyph nil))
      (101 . (:name linefeed         :glyph nil))
      (102 . (:name home             :glyph nil))
      (103 . (:name up               :glyph nil))
      (104 . (:name pageup           :glyph nil))
      (105 . (:name left             :glyph nil))
      (106 . (:name right            :glyph nil))
      (107 . (:name end              :glyph nil))
      (108 . (:name down             :glyph nil))
      (109 . (:name pagedown         :glyph nil))
      (110 . (:name insert           :glyph nil))
      (111 . (:name delete           :glyph #\Delete))
      (112 . (:name macro            :glyph nil))
      (113 . (:name mute             :glyph nil))
      (114 . (:name volumedown       :glyph nil))
      (115 . (:name volumeup         :glyph nil))
      (116 . (:name power            :glyph nil))
      (117 . (:name kpequal          :glyph #\=))
      (118 . (:name kpplusminus      :glyph nil))
      (119 . (:name pause            :glyph nil))
      (277 . (:name btnforward      :glyph nil))
      (278 . (:name btnback         :glyph nil)))
   :test #'equal
  :documentation "List of key code to key symbol name and printable character.
Used to decode the code field of the Linux input_event struct defined in
linux/include/uapi/linux/input.h.")
