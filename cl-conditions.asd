;;;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;;;; SPDX-License-Identifier: BSD-3-Clause

(asdf:defsystem #:cl-conditions
  :description "Canonical condition and exception hierarchy for Common Lisp"
  :author "Parkian Company LLC"
  :license "BSD-3-Clause"
  :version "0.1.0"
  :serial t
  :components ((:file "src/conditions"))
  :in-order-to ((asdf:test-op (test-op "cl-conditions/test"))))

(asdf:defsystem #:cl-conditions/test
  :description "Tests for cl-conditions"
  :depends-on (#:cl-conditions)
  :serial t
  :components ((:module "test"
                :components ((:file "test-conditions"))))
  :perform (asdf:test-op (o c)
             (let ((result (uiop:symbol-call :cl-conditions.test :run-tests)))
               (unless result
                 (error "Tests failed")))))
