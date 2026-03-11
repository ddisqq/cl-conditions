;;;; handlers.lisp - Condition handler macros
;;;; Copyright (c) 2024-2026 Parkian Company LLC
;;;; License: BSD-3-Clause

(in-package #:cl-conditions)

(defmacro with-condition-handlers (handlers &body body)
  "Execute BODY with condition handlers established.

Each handler is (condition-type (var) &body handler-body) or
(condition-type handler-function).

Example:
  (with-condition-handlers
      ((file-error (c)
         (format t \"File error: ~A~%\" c)
         (invoke-restart 'skip))
       (type-error #'handle-type-error))
    (process-files))
"
  (let ((handler-bindings
          (loop for handler in handlers
                collect (if (and (listp handler)
                                (listp (second handler)))
                           ;; (type (var) body...) form
                           `(,(first handler)
                             (lambda (,(first (second handler)))
                               ,@(cddr handler)))
                           ;; (type function) form
                           handler))))
    `(handler-bind ,handler-bindings
       ,@body)))

(defmacro invoke-restart-if-bound (name &rest args)
  "Invoke restart NAME with ARGS if it's bound, otherwise return NIL."
  (let ((restart (gensym "RESTART")))
    `(let ((,restart (find-restart ',name)))
       (when ,restart
         (invoke-restart ,restart ,@args)))))

(defun collect-conditions (thunk &optional (types '(condition)))
  "Call THUNK and collect all signaled conditions of TYPES.
Returns (values result conditions-list)."
  (let ((conditions nil))
    (values
     (handler-bind ((condition
                     (lambda (c)
                       (when (some (lambda (type) (typep c type)) types)
                         (push c conditions)))))
       (funcall thunk))
     (nreverse conditions))))
