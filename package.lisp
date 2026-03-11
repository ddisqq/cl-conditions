;;;; package.lisp - cl-conditions package definition
;;;; Copyright (c) 2024-2026 Parkian Company LLC
;;;; License: BSD-3-Clause

(defpackage #:cl-conditions
  (:use #:cl)
  (:export
   ;; Hierarchy definition
   #:define-condition-hierarchy

   ;; Handler macros
   #:with-condition-handlers
   #:with-restarts
   #:invoke-restart-if-bound

   ;; Chaining
   #:chained-condition
   #:condition-cause
   #:signal-chain
   #:with-cause

   ;; Logging
   #:with-condition-logging
   #:condition-report
   #:*condition-log-stream*
   #:*condition-log-level*

   ;; Standard restart helpers
   #:establish-retry
   #:establish-skip
   #:establish-use-value
   #:establish-abort

   ;; Condition utilities
   #:condition-properties
   #:condition-type-p
   #:collect-conditions))
