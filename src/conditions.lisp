;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: Apache-2.0

(in-package #:cl-conditions)

(define-condition cl-conditions-error (error)
  ((message :initarg :message :reader cl-conditions-error-message))
  (:report (lambda (condition stream)
             (format stream "cl-conditions error: ~A" (cl-conditions-error-message condition)))))
