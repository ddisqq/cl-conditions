;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: Apache-2.0

(in-package #:cl-conditions)

;;; Core types for cl-conditions
(deftype cl-conditions-id () '(unsigned-byte 64))
(deftype cl-conditions-status () '(member :ready :active :error :shutdown))
