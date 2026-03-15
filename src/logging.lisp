;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: Apache-2.0

;;;; logging.lisp - Condition logging
;;;; Copyright (c) 2024-2026 Parkian Company LLC
;;;; License: Apache-2.0

(in-package #:cl-conditions)

;;; Configuration

(defvar *condition-log-stream* *error-output*
  "Default stream for condition logging.")

(defvar *condition-log-level* :warn
  "Minimum level for logging conditions. One of :debug, :info, :warn, :error.")

(defparameter *log-levels*
  '(:debug 0 :info 1 :warn 2 :error 3)
  "Log level ordering.")

(defun log-level-value (level)
  (getf *log-levels* level 0))

(defun level>= (level1 level2)
  (>= (log-level-value level1)
      (log-level-value level2)))

;;; Condition formatting

(defun condition-report (condition &optional (stream *standard-output*))
  "Format CONDITION to STREAM in a readable way."
  (format stream "~A: ~A~%"
          (type-of condition)
          condition)
  (when (typep condition 'chained-condition)
    (when (condition-cause condition)
      (format stream "  Caused by: ")
      (condition-report (condition-cause condition) stream)))
  ;; Print slots if available
  (let ((props (ignore-errors (condition-properties condition))))
    (when props
      (format stream "  Properties:~%")
      (loop for (name . value) in props
            do (format stream "    ~A: ~S~%" name value)))))

(defun log-condition (condition &key (level :warn) (stream *condition-log-stream*))
  "Log CONDITION at LEVEL to STREAM."
  (when (level>= level *condition-log-level*)
    (format stream "~&[~A] ~A: ~A~%"
            (string-upcase level)
            (type-of condition)
            condition)
    (finish-output stream)))

;;; Logging wrapper

(defmacro with-condition-logging ((&key (stream '*condition-log-stream*)
                                        (level :warn)
                                        (types '(warning)))
                                  &body body)
  "Execute BODY, logging any conditions of TYPES at LEVEL.

Example:
  (with-condition-logging (:stream *error-output* :level :info)
    (process-data))
"
  (let ((c (gensym "C")))
    `(handler-bind
         ,(loop for type in (if (listp types) types (list types))
                collect `(,type (lambda (,c)
                                 (log-condition ,c :level ,level :stream ,stream))))
       ,@body)))

;;; Condition collection with logging

(defmacro with-condition-collection ((var &key (types '(warning))) &body body)
  "Execute BODY, collecting all conditions of TYPES into VAR.

Example:
  (with-condition-collection (warnings :types (warning))
    (compile-file \"test.lisp\")
    (format t \"Got ~D warnings~%\" (length warnings)))
"
  (let ((c (gensym "C")))
    `(let ((,var nil))
       (handler-bind
           ,(loop for type in (if (listp types) types (list types))
                  collect `(,type (lambda (,c)
                                   (push ,c ,var))))
         (prog1 (progn ,@body)
           (setf ,var (nreverse ,var)))))))
