;;;; hierarchy.lisp - Condition hierarchy definition
;;;; Copyright (c) 2024-2026 Parkian Company LLC
;;;; License: BSD-3-Clause

(in-package #:cl-conditions)

(defmacro define-condition-hierarchy (name parents slots &rest options)
  "Define a condition hierarchy with optional child conditions.

Example:
  (define-condition-hierarchy validation-error (error)
    ((field :initarg :field :reader error-field))
    (:children
     (missing-field-error ()
       ((name :initarg :name :reader missing-name)))
     (invalid-value-error ()
       ((value :initarg :value :reader invalid-value)))))
"
  (let ((children (cdr (assoc :children options)))
        (other-options (remove :children options :key #'car)))
    `(progn
       ;; Define the parent condition
       (define-condition ,name ,parents
         ,slots
         ,@other-options)
       ;; Define child conditions
       ,@(loop for (child-name child-slots child-slot-defs . child-options) in children
               collect `(define-condition ,child-name (,name ,@child-slots)
                         ,child-slot-defs
                         ,@child-options))
       ',name)))

(defun condition-properties (condition)
  "Return alist of condition slot names and values."
  (let ((class (class-of condition)))
    (loop for slot in (sb-mop:class-slots class)
          for name = (sb-mop:slot-definition-name slot)
          when (slot-boundp condition name)
          collect (cons name (slot-value condition name)))))

(defun condition-type-p (condition type)
  "Return T if CONDITION is of type TYPE."
  (typep condition type))
