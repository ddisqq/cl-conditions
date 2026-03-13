# cl-conditions

Canonical condition and exception hierarchy for Common Lisp applications.

## Features

- **Comprehensive error hierarchy** - 70+ condition types covering crypto, network, consensus, storage, validation, wallet, blockchain, RPC, and more
- **Structured error information** - All conditions include message, code, and context slots for rich error handling
- **Domain-specific conditions** - Specialized error types for cryptography, blockchain, consensus, and networking
- **Pure Common Lisp** - Zero external dependencies, SBCL-compatible
- **Well-documented** - Full docstrings on all exported conditions

## Usage

```lisp
(asdf:load-system :cl-conditions)
(use-package :cl-conditions)

;; Signal a validation error with context
(error 'validation-error
       :message "Invalid transaction height"
       :field "height"
       :value -1
       :expected ">= 0")

;; Catch and handle cryptographic errors
(handler-case (verify-signature sig pubkey)
  (crypto-error (e)
    (format t "Crypto failed: ~A~%" (error-message e)))
  (invalid-signature (e)
    (format t "Bad signature: ~A~%" (error-signature e))))

;; Catch errors by hierarchy
(handler-case (process-block block)
  (blockchain-error (e)
    (log-blockchain-error e))
  (network-error (e)
    (retry-with-backoff e))
  (cl-conditions-error (e)
    (handle-generic-error e)))
```

## Condition Hierarchy

### Base Conditions
- `cl-conditions-error` - Base error condition
- `cl-conditions-warning` - Base warning condition

### Domain-Specific Categories
- **Crypto**: `crypto-error`, `invalid-signature`, `invalid-key`, `verification-failed`, etc.
- **Network**: `network-error`, `connection-failed`, `timeout-error`, `peer-error`, `protocol-error`
- **Consensus**: `consensus-error`, `invalid-block`, `invalid-attestation`, `slashing-detected`
- **Storage**: `storage-error`, `not-found`, `corruption-detected`, `database-error`
- **Validation**: `validation-error`, `invalid-format`, `out-of-range`, `type-validation-error`
- **Wallet**: `wallet-error`, `insufficient-funds`, `wallet-locked`, `key-derivation-error`
- **Blockchain**: `blockchain-error`, `fork-resolution-error`, `double-spend`, `utxo-error`
- **RPC**: `rpc-error`, `rpc-authentication-error`, `rpc-rate-limit-error`

## API Reference

### Error Accessors

- `error-message` - Human-readable error description
- `error-code` - Numeric or symbolic error code
- `error-context` - Additional context data (alist or plist)
- `warning-message` - Warning message
- `warning-context` - Warning context

### Helper Functions

- `(signal-error condition-type format-string &rest args)` - Signal an error with formatted message
- `(warn-condition condition-type format-string &rest args)` - Issue a warning with formatted message

## License

BSD-3-Clause. Copyright (c) 2024-2026 Parkian Company LLC.
