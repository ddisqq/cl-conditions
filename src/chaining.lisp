;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

;;;; chaining.lisp - Condition chaining
;;;; Copyright (c) 2024-2026 Parkian Company LLC
;;;; License: BSD-3-Clause

(in-package #:cl-conditions)

;;; Chained condition base class

(define-condition chained-condition ()
  ((cause :initarg :cause
          :initform nil
          :reader condition-cause
          :documentation "The underlying cause of this condition"))
  (:documentation "Mixin for conditions that chain to a cause."))

(defmethod print-object :after ((c chained-condition) stream)
  (when (and (condition-cause c)
             *print-escape*)
    (format stream " [caused by: ~A]" (condition-cause c))))

;;; Chaining utilities

(defun signal-chain (condition-type cause &rest initargs)
  "Signal a new condition of CONDITION-TYPE with CAUSE as the underlying cause."
  (signal (apply #'make-condition condition-type :cause cause initargs)))

(defun error-chain (condition-type cause &rest initargs)
  "Signal an error of CONDITION-TYPE with CAUSE as the underlying cause."
  (error (apply #'make-condition condition-type :cause cause initargs)))

(defmacro with-cause (cause &body body)
  "Execute BODY, wrapping any error in a chained condition with CAUSE."
  (let ((cause-var (gensym "CAUSE"))
        (c (gensym "C")))
    `(let ((,cause-var ,cause))
       (handler-bind ((error (lambda (,c)
                              (error-chain 'simple-error ,c
                                          :format-control "~A (caused by ~A)"
                                          :format-arguments (list ,cause-var ,c)))))
         ,@body))))

;;; Cause chain traversal

(defun condition-cause-chain (condition)
  "Return list of all conditions in the cause chain."
  (loop for c = condition then (and (typep c 'chained-condition)
                                    (condition-cause c))
        while c
        collect c))

(defun root-cause (condition)
  "Return the root cause of CONDITION (the deepest cause in the chain)."
  (car (last (condition-cause-chain condition))))

(defun cause-depth (condition)
  "Return the depth of the cause chain."
  (1- (length (condition-cause-chain condition))))
