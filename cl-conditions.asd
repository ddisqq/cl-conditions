;;;; cl-conditions.asd - Extended condition/restart framework
;;;; Copyright (c) 2024-2026 Parkian Company LLC
;;;; License: BSD-3-Clause

(asdf:defsystem #:cl-conditions
  :description "Extended condition/restart framework for Common Lisp"
  :author "Parkian Company LLC"
  :license "BSD-3-Clause"
  :version "1.0.0"
  :serial t
  :components ((:file "package")
               (:module "src"
                :serial t
                :components ((:file "hierarchy")
                             (:file "handlers")
                             (:file "restarts")
                             (:file "chaining")
                             (:file "logging")))))
