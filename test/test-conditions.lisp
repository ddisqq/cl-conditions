;;;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;;;; SPDX-License-Identifier: Apache-2.0

(defpackage #:cl-conditions.test
  (:use #:cl #:cl-conditions)
  (:export #:run-tests))

(in-package #:cl-conditions.test)

(defun run-tests ()
  "Run basic smoke tests for cl-conditions."
  (format t "~&Testing cl-conditions...~%")
  
  ;; Test basic error condition
  (handler-case
    (error 'validation-error :message "Test validation error" :field "test-field")
    (validation-error (e)
      (assert (equal (error-message e) "Test validation error"))
      (assert (equal (error-field e) "test-field"))
      (format t "  ✓ validation-error works~%")))
  
  ;; Test crypto error
  (handler-case
    (error 'invalid-signature :message "Bad sig" :signature "fake")
    (invalid-signature (e)
      (assert (equal (error-message e) "Bad sig"))
      (format t "  ✓ invalid-signature works~%")))
  
  ;; Test network error
  (handler-case
    (error 'timeout-error :message "Connection timed out" :timeout-ms 5000)
    (timeout-error (e)
      (assert (equal (error-timeout-ms e) 5000))
      (format t "  ✓ timeout-error works~%")))
  
  ;; Test hierarchy
  (handler-case
    (error 'crypto-error :message "Generic crypto error")
    (cl-conditions-error (e)
      (format t "  ✓ hierarchy works (crypto-error caught as cl-conditions-error)~%")))
  
  (format t "~&All tests passed!~%")
  t)
