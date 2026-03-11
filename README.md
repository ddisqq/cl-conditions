# cl-conditions

Extended condition/restart framework for Common Lisp.

## Features

- `define-condition-hierarchy` - Define related conditions together
- `with-condition-handlers` - Cleaner handler syntax
- `with-restarts` - Simplified restart establishment
- Standard restarts: retry, skip, use-value
- Condition chaining and nesting
- Condition logging and reporting

## Installation

```lisp
(asdf:load-system :cl-conditions)
```

## Usage

```lisp
(use-package :cl-conditions)

;; Define a condition hierarchy
(define-condition-hierarchy validation-error (error)
  ((field :initarg :field :reader error-field))
  (:children
   (missing-field-error ()
     ((name :initarg :name :reader missing-field-name)))
   (invalid-value-error ()
     ((value :initarg :value :reader invalid-value)
      (expected :initarg :expected :reader expected-type)))))

;; Use with-condition-handlers for cleaner syntax
(with-condition-handlers
    ((missing-field-error (c)
       (format t "Missing: ~A~%" (missing-field-name c))
       (invoke-restart 'use-value nil))
     (invalid-value-error (c)
       (invoke-restart 'skip)))
  (validate-data input))

;; Establish restarts easily
(with-restarts ((retry () :report "Try again" (process-item item))
                (skip () :report "Skip this item" nil)
                (use-value (v) :report "Use different value" v))
  (process-item item))

;; Condition chaining
(handler-bind ((error (lambda (c)
                        (signal-chain 'wrapper-error c))))
  (risky-operation))

;; Logging conditions
(with-condition-logging (:stream *error-output* :level :warn)
  (operation-that-might-warn))
```

## API

### Defining Conditions

- `define-condition-hierarchy name (parents) slots &rest options`

### Handling Conditions

- `with-condition-handlers handlers &body body`
- `with-restarts restarts &body body`
- `invoke-restart-if-bound name &rest args`

### Chaining

- `signal-chain condition cause` - Signal with cause chain
- `condition-cause condition` - Get cause of chained condition

### Logging

- `with-condition-logging options &body body`
- `condition-report condition stream` - Format condition

### Standard Restarts

- `retry` - Retry the operation
- `skip` - Skip current item, continue
- `use-value value` - Use alternative value
- `abort` - Abort operation entirely

## License

BSD-3-Clause. Copyright (c) 2024-2026 Parkian Company LLC.
