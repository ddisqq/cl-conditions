;;;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;;;; SPDX-License-Identifier: BSD-3-Clause

(asdf:defsystem #:cl-conditions
  :description "Canonical condition and exception hierarchy for Common Lisp"
  :author "Park Ian Co"
  :license "Apache-2.0"
  :version "0.1.0"
  :serial t
  :components ((:module "src"
                :components ((:file "package")
                             (:file "conditions" :depends-on ("package"))
                             (:file "types" :depends-on ("package"))
                             (:file "cl-conditions" :depends-on ("package" "conditions" "types"))))))

(asdf:defsystem #:cl-conditions/test
  :description "Tests for cl-conditions"
  :depends-on (#:cl-conditions)
  :serial t
  :components ((:module "src"
                :components ((:file "package")
                             (:file "conditions" :depends-on ("package"))
                             (:file "types" :depends-on ("package"))
                             (:file "cl-conditions" :depends-on ("package" "conditions" "types"))))))
  :perform (asdf:test-op (o c)
             (let ((result (uiop:symbol-call :cl-conditions.test :run-tests)))
               (unless result
                 (error "Tests failed")))))
