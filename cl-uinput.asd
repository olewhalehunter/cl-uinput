
(asdf:defsystem #:cl-uinput
    :description "Linux virtual devices in Common Lisp."
    :author "Anders Puckett github.com/olewhalehunter"
    :serial t
    :depends-on (#:cl-event-handler
                 #:cl-evdev
		 #:iolib
		 #:iolib/os
                 )
    :components ((:file "package")
                 (:file "cl-uinput")))
