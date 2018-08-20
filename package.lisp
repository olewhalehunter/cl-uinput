
(defpackage #:cl-uinput
  (:use #:cl
	#:cl-event-handler
	#:cl-evdev
	#:iolib
	#:iolib/os)
  (:documentation "Linux virtual devices in Common Lisp.")
  (:export
   #:load-dependencies
   #:list-devices
   #:compile-uint-listener
   #:start-uint-pipe-listener
   #:close-uinput-listener

   #:read-device
   #:receive-key-event	   
   #:test-virtual-device
   )
  )
	   
