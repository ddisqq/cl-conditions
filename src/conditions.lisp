;;;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;;;; SPDX-License-Identifier: Apache-2.0
;;;;
;;;; Canonical condition definitions for Common Lisp applications.
;;;; This module provides a hierarchy of error and warning conditions
;;;; suitable for use across multiple packages and domains.
;;;;
;;;; USAGE:
;;;;   (error 'cl-conditions:validation-error
;;;;          :message "Invalid block height"
;;;;          :context '(:height -1))
;;;;
;;;;   (handler-case (validate-something something)
;;;;     (cl-conditions:crypto-error (e)
;;;;       (log-error e)))

(defpackage #:cl-conditions
  (:use #:cl)
  (:export
   ;; ============================================================================
   ;; Base Conditions
   ;; ============================================================================
   #:cl-conditions-error
   #:cl-conditions-warning
   ;; Accessors
   #:error-message
   #:error-code
   #:error-context
   #:warning-message
   #:warning-context
   #:error-signature
   #:error-public-key
   #:error-key-type
   #:error-reason
   #:error-verification-type
   #:error-address
   #:error-port
   #:error-operation
   #:error-timeout-ms
   #:error-peer-id
   #:error-peer
   #:misbehavior-type
   #:ban-score
   #:error-command
   #:error-block-hash
   #:error-height
   #:validation-step
   #:error-attestation
   #:error-validator
   #:error-evidence
   #:slash-amount
   #:checkpoint-height
   #:expected-hash
   #:actual-hash
   #:pow-target
   #:pow-actual-hash
   #:adjustment-height
   #:expected-bits
   #:actual-bits
   #:error-key
   #:error-store
   #:error-location
   #:error-expected
   #:error-actual
   #:error-field
   #:error-value
   #:format-expected
   #:error-min-value
   #:error-max-value
   #:required-amount
   #:available-amount
   #:corruption-height
   #:corruption-reason
   #:fork-height
   #:competing-chains
   #:reorg-from-height
   #:reorg-to-height
   #:blocks-affected
   #:error-outpoint
   #:error-method
   #:error-resource
   #:error-txid
   #:required-permission

   ;; ============================================================================
   ;; Crypto Conditions (for signature, key, hash operations)
   ;; ============================================================================
   #:crypto-error
   #:invalid-signature
   #:invalid-signature-error      ; alias
   #:invalid-key
   #:invalid-key-error            ; alias
   #:verification-failed
   #:verification-error           ; alias
   #:key-generation-error
   #:signature-verification-error
   #:hash-verification-error
   #:random-generation-error
   #:decryption-error
   #:encryption-error

   ;; ============================================================================
   ;; Network Conditions (for P2P, connections, protocols)
   ;; ============================================================================
   #:network-error
   #:connection-failed
   #:connection-error             ; alias
   #:timeout-error
   #:peer-disconnected
   #:peer-error
   #:peer-misbehavior
   #:protocol-error
   #:message-decode-error

   ;; ============================================================================
   ;; Consensus Conditions (for block validation, attestation)
   ;; ============================================================================
   #:consensus-error
   #:invalid-block
   #:invalid-block-error          ; alias
   #:block-validation-error       ; alias
   #:invalid-attestation
   #:slashing-detected
   #:checkpoint-violation-error
   #:pow-verification-error
   #:difficulty-adjustment-error

   ;; ============================================================================
   ;; Storage Conditions (for database, persistence)
   ;; ============================================================================
   #:storage-error
   #:not-found
   #:not-found-error              ; alias
   #:corruption-detected
   #:database-error
   #:database-connection-error
   #:database-corruption-error
   #:persistence-error
   #:disk-space-error

   ;; ============================================================================
   ;; Validation Conditions (for data validation, type checking)
   ;; ============================================================================
   #:validation-error
   #:invalid-format
   #:invalid-format-error         ; alias
   #:out-of-range
   #:out-of-range-error           ; alias
   #:type-validation-error
   #:range-validation-error
   #:transaction-validation-error

   ;; ============================================================================
   ;; Wallet Conditions (for key management, transactions)
   ;; ============================================================================
   #:wallet-error
   #:insufficient-funds
   #:insufficient-funds-error     ; alias
   #:wallet-locked
   #:wallet-locked-error          ; alias
   #:key-derivation-error
   #:wallet-encryption-error

   ;; ============================================================================
   ;; Blockchain Conditions (for chain operations)
   ;; ============================================================================
   #:blockchain-error
   #:blockchain-warning
   #:chain-corruption-error
   #:fork-resolution-error
   #:reorg-error
   #:double-spend
   #:utxo-error
   #:utxo-not-found

   ;; ============================================================================
   ;; RPC Conditions (for API operations)
   ;; ============================================================================
   #:rpc-error
   #:rpc-authentication-error
   #:rpc-authorization-error
   #:rpc-rate-limit-error
   #:rpc-method-not-found-error
   #:rpc-invalid-params-error

   ;; ============================================================================
   ;; Resource Conditions (for system resources)
   ;; ============================================================================
   #:resource-error
   #:resource-exhausted-error
   #:resource-leak-error
   #:resource-cleanup-error

   ;; ============================================================================
   ;; Configuration Conditions
   ;; ============================================================================
   #:configuration-error
   #:missing-configuration-error
   #:invalid-configuration

   ;; ============================================================================
   ;; Security Conditions
   ;; ============================================================================
   #:security-error
   #:unauthorized-error
   #:unauthorized-access
   #:permission-denied-error

   ;; ============================================================================
   ;; Contract/Execution Conditions
   ;; ============================================================================
   #:execution-error
   #:execution-failed-error
   #:gas-estimation-error

   ;; ============================================================================
   ;; Helper Functions
   ;; ============================================================================
   #:signal-error
   #:warn-condition))

(in-package #:cl-conditions)

;;; ============================================================================
;;; BASE CONDITIONS
;;; ============================================================================

(define-condition cl-conditions-error (error)
  ((message :initarg :message
            :reader error-message
            :initform "An error occurred")
   (code :initarg :code
         :reader error-code
         :initform nil)
   (context :initarg :context
            :reader error-context
            :initform nil))
  (:report (lambda (c s)
             (format s "CLPIC Error~@[ (~A)~]: ~A~@[~%Context: ~A~]"
                     (error-code c)
                     (error-message c)
                     (error-context c))))
  (:documentation "Base error condition for all CLPIC errors.
Never signal directly - use specific subtypes."))

(define-condition cl-conditions-warning (warning)
  ((message :initarg :message
            :reader warning-message
            :initform "Warning")
   (context :initarg :context
            :reader warning-context
            :initform nil))
  (:report (lambda (c s)
             (format s "CLPIC Warning: ~A~@[~%Context: ~A~]"
                     (warning-message c)
                     (warning-context c))))
  (:documentation "Base warning condition for all CLPIC warnings."))

;;; ============================================================================
;;; CRYPTO CONDITIONS
;;; ============================================================================

(define-condition crypto-error (cl-conditions-error)
  ()
  (:documentation "Base error for cryptographic operations."))

(define-condition invalid-signature (crypto-error)
  ((signature :initarg :signature :reader error-signature :initform nil)
   (public-key :initarg :public-key :reader error-public-key :initform nil))
  (:report (lambda (c s)
             (format s "Invalid signature~@[~%Signature: ~A~]~@[~%Public key: ~A~]~@[~%~A~]"
                     (error-signature c)
                     (error-public-key c)
                     (error-message c))))
  (:documentation "Signature verification failed."))

;; Alias for compatibility
(setf (find-class 'invalid-signature-error) (find-class 'invalid-signature))

(define-condition invalid-key (crypto-error)
  ((key-type :initarg :key-type :reader error-key-type :initform nil)
   (reason :initarg :reason :reader error-reason :initform nil))
  (:report (lambda (c s)
             (format s "Invalid ~@[~A ~]key~@[: ~A~]~@[~%~A~]"
                     (error-key-type c)
                     (error-reason c)
                     (error-message c))))
  (:documentation "Invalid cryptographic key."))

(setf (find-class 'invalid-key-error) (find-class 'invalid-key))

(define-condition verification-failed (crypto-error)
  ((verification-type :initarg :verification-type :reader error-verification-type :initform nil))
  (:report (lambda (c s)
             (format s "Verification failed~@[ (~A)~]~@[: ~A~]"
                     (error-verification-type c)
                     (error-message c))))
  (:documentation "Generic verification failure."))

(setf (find-class 'verification-error) (find-class 'verification-failed))

(define-condition key-generation-error (crypto-error)
  ()
  (:documentation "Error generating cryptographic keys."))

(define-condition signature-verification-error (crypto-error)
  ()
  (:documentation "Signature verification failed."))

(define-condition hash-verification-error (crypto-error)
  ()
  (:documentation "Hash verification failed."))

(define-condition random-generation-error (crypto-error)
  ()
  (:documentation "Random number generation failed."))

(define-condition decryption-error (crypto-error)
  ()
  (:documentation "Decryption operation failed."))

(define-condition encryption-error (crypto-error)
  ()
  (:documentation "Encryption operation failed."))

;;; ============================================================================
;;; NETWORK CONDITIONS
;;; ============================================================================

(define-condition network-error (cl-conditions-error)
  ()
  (:documentation "Base error for network operations."))

(define-condition connection-failed (network-error)
  ((address :initarg :address :reader error-address :initform nil)
   (port :initarg :port :reader error-port :initform nil))
  (:report (lambda (c s)
             (format s "Connection failed~@[ to ~A~]~@[:~D~]~@[: ~A~]"
                     (error-address c)
                     (error-port c)
                     (error-message c))))
  (:documentation "Failed to establish network connection."))

(setf (find-class 'connection-error) (find-class 'connection-failed))

(define-condition timeout-error (network-error)
  ((operation :initarg :operation :reader error-operation :initform nil)
   (timeout-ms :initarg :timeout-ms :reader error-timeout-ms :initform nil))
  (:report (lambda (c s)
             (format s "Timeout~@[ in ~A~]~@[ after ~Dms~]~@[: ~A~]"
                     (error-operation c)
                     (error-timeout-ms c)
                     (error-message c))))
  (:documentation "Operation timed out."))

(define-condition peer-disconnected (network-error)
  ((peer-id :initarg :peer-id :reader error-peer-id :initform nil)
   (reason :initarg :reason :reader error-reason :initform nil))
  (:report (lambda (c s)
             (format s "Peer disconnected~@[: ~A~]~@[~%Reason: ~A~]"
                     (error-peer-id c)
                     (error-reason c))))
  (:documentation "Network peer disconnected."))

(define-condition peer-error (network-error)
  ((peer :initarg :peer :reader error-peer :initform nil))
  (:documentation "Error related to specific peer."))

(define-condition peer-misbehavior (peer-error)
  ((behavior :initarg :behavior :reader misbehavior-type :initform nil)
   (ban-score :initarg :ban-score :reader ban-score :initform 10))
  (:report (lambda (c s)
             (format s "Peer misbehavior~@[ (~A)~]: ~A (score: ~D)"
                     (misbehavior-type c)
                     (error-message c)
                     (ban-score c))))
  (:documentation "Peer exhibited malicious or incorrect behavior."))

(define-condition protocol-error (network-error)
  ((command :initarg :command :reader error-command :initform nil))
  (:report (lambda (c s)
             (format s "Protocol error~@[ in ~A~]: ~A"
                     (error-command c)
                     (error-message c))))
  (:documentation "Network protocol violation."))

(define-condition message-decode-error (network-error)
  ()
  (:documentation "Failed to decode network message."))

;;; ============================================================================
;;; CONSENSUS CONDITIONS
;;; ============================================================================

(define-condition consensus-error (cl-conditions-error)
  ()
  (:documentation "Base error for consensus operations."))

(define-condition invalid-block (consensus-error)
  ((block-hash :initarg :block-hash :reader error-block-hash :initform nil)
   (height :initarg :height :reader error-height :initform nil)
   (validation-step :initarg :validation-step :reader validation-step :initform nil))
  (:report (lambda (c s)
             (format s "Invalid block~@[ at ~A~]~@[ (height ~D)~]~@[: ~A~]"
                     (validation-step c)
                     (error-height c)
                     (error-message c))))
  (:documentation "Block failed validation."))

(setf (find-class 'invalid-block-error) (find-class 'invalid-block))
(setf (find-class 'block-validation-error) (find-class 'invalid-block))

(define-condition invalid-attestation (consensus-error)
  ((attestation :initarg :attestation :reader error-attestation :initform nil)
   (validator :initarg :validator :reader error-validator :initform nil))
  (:report (lambda (c s)
             (format s "Invalid attestation~@[ from validator ~A~]~@[: ~A~]"
                     (error-validator c)
                     (error-message c))))
  (:documentation "Attestation failed validation."))

(define-condition slashing-detected (consensus-error)
  ((validator :initarg :validator :reader error-validator :initform nil)
   (evidence :initarg :evidence :reader error-evidence :initform nil)
   (slash-amount :initarg :slash-amount :reader slash-amount :initform nil))
  (:report (lambda (c s)
             (format s "Slashing detected for validator ~A~@[ (amount: ~A)~]~@[: ~A~]"
                     (error-validator c)
                     (slash-amount c)
                     (error-message c))))
  (:documentation "Validator slashing condition detected."))

(define-condition checkpoint-violation-error (consensus-error)
  ((height :initarg :height :reader checkpoint-height :initform nil)
   (expected-hash :initarg :expected-hash :reader expected-hash :initform nil)
   (actual-hash :initarg :actual-hash :reader actual-hash :initform nil))
  (:documentation "Block does not match checkpoint."))

(define-condition pow-verification-error (consensus-error)
  ((block-hash :initarg :block-hash :reader error-block-hash :initform nil)
   (target :initarg :target :reader pow-target :initform nil)
   (actual-hash :initarg :actual-hash :reader pow-actual-hash :initform nil))
  (:documentation "Proof of work verification failed."))

(define-condition difficulty-adjustment-error (consensus-error)
  ((height :initarg :height :reader adjustment-height :initform nil)
   (expected-bits :initarg :expected-bits :reader expected-bits :initform nil)
   (actual-bits :initarg :actual-bits :reader actual-bits :initform nil))
  (:documentation "Difficulty adjustment validation failed."))

;;; ============================================================================
;;; STORAGE CONDITIONS
;;; ============================================================================

(define-condition storage-error (cl-conditions-error)
  ()
  (:documentation "Base error for storage operations."))

(define-condition not-found (storage-error)
  ((key :initarg :key :reader error-key :initform nil)
   (store :initarg :store :reader error-store :initform nil))
  (:report (lambda (c s)
             (format s "Not found~@[: ~A~]~@[ in ~A~]"
                     (error-key c)
                     (error-store c))))
  (:documentation "Requested item not found in storage."))

(setf (find-class 'not-found-error) (find-class 'not-found))

(define-condition corruption-detected (storage-error)
  ((location :initarg :location :reader error-location :initform nil)
   (expected :initarg :expected :reader error-expected :initform nil)
   (actual :initarg :actual :reader error-actual :initform nil))
  (:report (lambda (c s)
             (format s "Corruption detected~@[ at ~A~]~@[: ~A~]"
                     (error-location c)
                     (error-message c))))
  (:documentation "Data corruption detected in storage."))

(define-condition database-error (storage-error)
  ()
  (:documentation "Database operation failed."))

(define-condition database-connection-error (database-error)
  ()
  (:documentation "Failed to connect to database."))

(define-condition database-corruption-error (database-error)
  ()
  (:documentation "Database corruption detected."))

(define-condition persistence-error (storage-error)
  ()
  (:documentation "Failed to persist data."))

(define-condition disk-space-error (storage-error)
  ()
  (:documentation "Insufficient disk space."))

;;; ============================================================================
;;; VALIDATION CONDITIONS
;;; ============================================================================

(define-condition validation-error (cl-conditions-error)
  ((field :initarg :field :reader error-field :initform nil)
   (value :initarg :value :reader error-value :initform nil)
   (expected :initarg :expected :reader error-expected :initform nil))
  (:report (lambda (c s)
             (format s "Validation error~@[ for ~A~]~@[: ~A~]"
                     (error-field c)
                     (error-message c))))
  (:documentation "Data validation failed."))

(define-condition invalid-format (validation-error)
  ((format-expected :initarg :format-expected :reader format-expected :initform nil))
  (:report (lambda (c s)
             (format s "Invalid format~@[ for ~A~]~@[, expected ~A~]~@[: ~A~]"
                     (error-field c)
                     (format-expected c)
                     (error-message c))))
  (:documentation "Data format is invalid."))

(setf (find-class 'invalid-format-error) (find-class 'invalid-format))

(define-condition out-of-range (validation-error)
  ((min-value :initarg :min-value :reader error-min-value :initform nil)
   (max-value :initarg :max-value :reader error-max-value :initform nil))
  (:report (lambda (c s)
             (format s "Out of range~@[ for ~A~]~@[ (min: ~A, max: ~A)~]~@[: ~A~]"
                     (error-field c)
                     (error-min-value c)
                     (error-max-value c)
                     (error-message c))))
  (:documentation "Value is outside acceptable range."))

(setf (find-class 'out-of-range-error) (find-class 'out-of-range))

(define-condition type-validation-error (validation-error)
  ()
  (:documentation "Type validation failed."))

(define-condition range-validation-error (validation-error)
  ()
  (:documentation "Range validation failed."))

(define-condition transaction-validation-error (validation-error)
  ((txid :initarg :txid :reader error-txid :initform nil)
   (validation-step :initarg :validation-step :reader validation-step :initform nil))
  (:documentation "Transaction validation failed."))

;;; ============================================================================
;;; WALLET CONDITIONS
;;; ============================================================================

(define-condition wallet-error (cl-conditions-error)
  ()
  (:documentation "Base error for wallet operations."))

(define-condition insufficient-funds (wallet-error)
  ((required :initarg :required :reader required-amount :initform nil)
   (available :initarg :available :reader available-amount :initform nil))
  (:report (lambda (c s)
             (format s "Insufficient funds~@[: need ~A, have ~A~]"
                     (required-amount c)
                     (available-amount c))))
  (:documentation "Wallet has insufficient funds for operation."))

(setf (find-class 'insufficient-funds-error) (find-class 'insufficient-funds))

(define-condition wallet-locked (wallet-error)
  ()
  (:report (lambda (c s)
             (declare (ignore c))
             (format s "Wallet is locked")))
  (:documentation "Operation requires unlocked wallet."))

(setf (find-class 'wallet-locked-error) (find-class 'wallet-locked))

(define-condition key-derivation-error (wallet-error)
  ()
  (:documentation "Key derivation failed."))

(define-condition wallet-encryption-error (wallet-error)
  ()
  (:documentation "Wallet encryption/decryption failed."))

;;; ============================================================================
;;; BLOCKCHAIN CONDITIONS
;;; ============================================================================

(define-condition blockchain-error (cl-conditions-error)
  ()
  (:documentation "Base error for blockchain operations."))

(define-condition blockchain-warning (cl-conditions-warning)
  ()
  (:documentation "Warning for blockchain operations."))

(define-condition chain-corruption-error (blockchain-error)
  ((height :initarg :height :reader corruption-height :initform nil)
   (reason :initarg :reason :reader corruption-reason :initform nil))
  (:report (lambda (c s)
             (format s "Chain corruption~@[ at height ~D~]: ~A"
                     (corruption-height c)
                     (corruption-reason c))))
  (:documentation "Chain data corruption detected."))

(define-condition fork-resolution-error (blockchain-error)
  ((fork-height :initarg :fork-height :reader fork-height :initform nil)
   (competing-chains :initarg :competing-chains :reader competing-chains :initform 2))
  (:report (lambda (c s)
             (format s "Fork resolution failed at height ~D (~D competing chains)"
                     (fork-height c)
                     (competing-chains c))))
  (:documentation "Unable to resolve blockchain fork."))

(define-condition reorg-error (blockchain-error)
  ((from-height :initarg :from-height :reader reorg-from-height :initform nil)
   (to-height :initarg :to-height :reader reorg-to-height :initform nil)
   (blocks-affected :initarg :blocks-affected :reader blocks-affected :initform nil))
  (:report (lambda (c s)
             (format s "Chain reorganization failed (height ~D -> ~D, ~D blocks)"
                     (reorg-from-height c)
                     (reorg-to-height c)
                     (blocks-affected c))))
  (:documentation "Error during chain reorganization."))

(define-condition double-spend (blockchain-error)
  ((outpoint :initarg :outpoint :reader error-outpoint :initform nil))
  (:report (lambda (c s)
             (format s "Double spend detected~@[: ~A~]"
                     (error-outpoint c))))
  (:documentation "Attempt to spend already-spent output."))

(define-condition utxo-error (storage-error)
  ((outpoint :initarg :outpoint :reader error-outpoint :initform nil))
  (:documentation "UTXO-related error."))

(define-condition utxo-not-found (utxo-error)
  ()
  (:report (lambda (c s)
             (format s "UTXO not found~@[: ~A~]"
                     (error-outpoint c))))
  (:documentation "Referenced UTXO does not exist."))

;;; ============================================================================
;;; RPC CONDITIONS
;;; ============================================================================

(define-condition rpc-error (cl-conditions-error)
  ()
  (:documentation "Base error for RPC operations."))

(define-condition rpc-authentication-error (rpc-error)
  ()
  (:documentation "RPC authentication failed."))

(define-condition rpc-authorization-error (rpc-error)
  ()
  (:documentation "RPC authorization failed."))

(define-condition rpc-rate-limit-error (rpc-error)
  ()
  (:documentation "RPC rate limit exceeded."))

(define-condition rpc-method-not-found-error (rpc-error)
  ((method :initarg :method :reader error-method :initform nil))
  (:documentation "RPC method not found."))

(define-condition rpc-invalid-params-error (rpc-error)
  ()
  (:documentation "RPC parameters invalid."))

;;; ============================================================================
;;; RESOURCE CONDITIONS
;;; ============================================================================

(define-condition resource-error (cl-conditions-error)
  ()
  (:documentation "Base error for resource management."))

(define-condition resource-exhausted-error (resource-error)
  ((resource :initarg :resource :reader error-resource :initform nil))
  (:documentation "Resource has been exhausted."))

(define-condition resource-leak-error (resource-error)
  ()
  (:documentation "Resource leak detected."))

(define-condition resource-cleanup-error (resource-error)
  ()
  (:documentation "Resource cleanup failed."))

;;; ============================================================================
;;; CONFIGURATION CONDITIONS
;;; ============================================================================

(define-condition configuration-error (cl-conditions-error)
  ((key :initarg :key :reader error-key :initform nil))
  (:documentation "Configuration error."))

(define-condition missing-configuration-error (configuration-error)
  ()
  (:report (lambda (c s)
             (format s "Missing configuration~@[: ~A~]"
                     (error-key c))))
  (:documentation "Required configuration is missing."))

(define-condition invalid-configuration (configuration-error)
  ((reason :initarg :reason :reader error-reason :initform nil))
  (:documentation "Configuration is invalid."))

;;; ============================================================================
;;; SECURITY CONDITIONS
;;; ============================================================================

(define-condition security-error (cl-conditions-error)
  ()
  (:documentation "Base error for security violations."))

(define-condition unauthorized-error (security-error)
  ()
  (:documentation "Unauthorized access attempt."))

(setf (find-class 'unauthorized-access) (find-class 'unauthorized-error))

(define-condition permission-denied-error (security-error)
  ((required-permission :initarg :required-permission :reader required-permission :initform nil))
  (:documentation "Permission denied for operation."))

;;; ============================================================================
;;; CONTRACT/EXECUTION CONDITIONS
;;; ============================================================================

(define-condition execution-error (cl-conditions-error)
  ()
  (:documentation "Base error for execution/contract operations."))

(define-condition execution-failed-error (execution-error)
  ((reason :initarg :reason :reader error-reason :initform nil))
  (:documentation "Execution failed."))

(define-condition gas-estimation-error (execution-error)
  ()
  (:documentation "Gas estimation failed."))

;;; ============================================================================
;;; HELPER FUNCTIONS
;;; ============================================================================

(defun signal-error (condition-type message &rest args)
  "Signal a CLPIC error with formatted message.

CONDITION-TYPE - Symbol naming the condition type
MESSAGE - Format string for the error message
ARGS - Arguments for format string plus condition initargs

Initargs are extracted from ARGS as keyword-value pairs after the format arguments.

Example:
  (signal-error 'validation-error \"Invalid height: ~D\" height :field \"height\")"
  (let ((formatted-message (apply #'format nil message
                                  (loop for arg in args
                                        until (keywordp arg)
                                        collect arg)))
        (initargs (loop for tail on args
                        when (keywordp (car tail))
                          nconc (list (car tail) (cadr tail)))))
    (apply #'error condition-type
           :message formatted-message
           initargs)))

(defun warn-condition (condition-type message &rest args)
  "Signal a CLPIC warning with formatted message.

Similar to SIGNAL-ERROR but for warnings."
  (let ((formatted-message (apply #'format nil message
                                  (loop for arg in args
                                        until (keywordp arg)
                                        collect arg)))
        (initargs (loop for tail on args
                        when (keywordp (car tail))
                          nconc (list (car tail) (cadr tail)))))
    (apply #'warn condition-type
           :message formatted-message
           initargs)))
