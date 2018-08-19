
(defpackage #:cl-uinput
  (:use #:cl
	#:cl-event-handler
	#:cl-evdev
	#:fd-gray
	#:iolib
	#:iolib/os)
  (:documentation "Linux virtual devices in Common Lisp.")
  (:export #:read-device
	   #:receive-key-event
	   
	   #:compile-c-driver)
  )
	   
