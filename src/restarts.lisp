;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: Apache-2.0

;;;; restarts.lisp - Restart establishment macros
;;;; Copyright (c) 2024-2026 Parkian Company LLC
;;;; License: Apache-2.0

(in-package #:cl-conditions)

(defmacro with-restarts (restarts &body body)
  "Execute BODY with restarts established.

Each restart is (name (&rest args) &key report interactive test &body body).

Example:
  (with-restarts ((retry ()
                    :report \"Retry the operation\"
                    (process-item))
                  (skip ()
                    :report \"Skip this item\"
                    nil)
                  (use-value (v)
                    :report \"Use a different value\"
                    :interactive (lambda () (list (read)))
                    v))
    (risky-operation))
"
  (let ((restart-cases
          (loop for restart in restarts
                for name = (first restart)
                for args = (second restart)
                for rest = (cddr restart)
                for report = (getf rest :report)
                for interactive = (getf rest :interactive)
                for test = (getf rest :test)
                for body-forms = (loop for (key val) on rest by #'cddr
                                       unless (member key '(:report :interactive :test))
                                       append (list key val)
                                       else if (not (member key '(:report :interactive :test)))
                                       collect key)
                ;; Extract actual body (skip keyword arguments)
                for real-body = (let ((pos rest))
                                 (loop while (and pos (keywordp (car pos)))
                                       do (setf pos (cddr pos)))
                                 pos)
                collect `(,name ,args
                          ,@(when report `(:report ,report))
                          ,@(when interactive `(:interactive ,interactive))
                          ,@(when test `(:test ,test))
                          ,@real-body))))
    `(restart-case (progn ,@body)
       ,@restart-cases)))

(defmacro establish-retry (report-string &body body)
  "Establish a RETRY restart around BODY."
  `(restart-case (progn ,@body)
     (retry ()
       :report ,report-string
       ,@body)))

(defmacro establish-skip (report-string &body body)
  "Establish a SKIP restart around BODY."
  `(restart-case (progn ,@body)
     (skip ()
       :report ,report-string
       nil)))

(defmacro establish-use-value (report-string &body body)
  "Establish a USE-VALUE restart around BODY."
  `(restart-case (progn ,@body)
     (use-value (value)
       :report ,report-string
       :interactive (lambda ()
                      (format *query-io* "Enter value: ")
                      (list (read *query-io*)))
       value)))

(defmacro establish-abort (report-string &body body)
  "Establish an ABORT restart around BODY."
  `(restart-case (progn ,@body)
     (abort ()
       :report ,report-string
       nil)))
