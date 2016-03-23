#lang racket/base

;; FFI bindings to MLt

(require ffi/unsafe
         ffi/unsafe/define)

(provide mlt-environment
         mlt-environment-set
         mlt-factory-close
         mlt-factory-consumer
         mlt-factory-directory
         mlt-factory-init
         mlt-factory-producer
         mlt-factory-repository
         mlt-consumer-close
         mlt-consumer-connect
         mlt-consumer-start
         mlt-consumer-stop
         mlt-consumer-is-stopped
         mlt-producer-close
         mlt-producer-service
         mlt-profile-init)

(define lib (ffi-lib "libmlt" '("6")))
(define-ffi-definer define-mlt lib)

(define-cpointer-type _mlt-repository)
(define-cpointer-type _mlt-profile)
(define-cpointer-type _mlt-producer)
(define-cpointer-type _mlt-consumer)
(define-cpointer-type _mlt-service)

;;; mlt_factory.c
(define-mlt mlt-environment (_fun _string -> _string)
            #:c-id mlt_environment)
(define-mlt mlt-environment-set (_fun _string _string -> _int)
            #:c-id mlt_environment_set)
(define-mlt mlt-factory-close (_fun -> _void)
            #:c-id mlt_factory_close)
;; TODO: third argument not always a string?
(define-mlt mlt-factory-consumer (_fun _mlt-profile/null _string _string -> _mlt-consumer)
            #:c-id mlt_factory_consumer)
; mlt_factory_create_done
; mlt_factory_create_request
(define-mlt mlt-factory-directory (_fun -> _string)
            #:c-id mlt_factory_directory)
; mlt_factory_event_object
; mlt_factory_filter
(define-mlt mlt-factory-init (_fun _string -> _mlt-repository/null)
            #:c-id mlt_factory_init)
(define-mlt mlt-factory-producer (_fun _mlt-profile _string _string -> _mlt-producer)
            #:c-id mlt_factory_producer)
; mlt_factory_register_for_clean_up
(define-mlt mlt-factory-repository (_fun _string -> _mlt-repository)
            #:c-id mlt_factory_repository)
; mlt_factory_transition
; mlt_global_properties
; set_common_properties

;; mlt_profile.h
(define-mlt mlt-profile-init (_fun _string -> _mlt-profile)
            #:c-id mlt_profile_init)

;; mlt_consumer
(define-mlt mlt-consumer-close (_fun _mlt-consumer -> _void)
            #:c-id mlt_consumer_close)
;; TODO: use symbol enum for return arg?
(define-mlt mlt-consumer-connect (_fun _mlt-consumer _mlt-service -> _int)
            #:c-id mlt_consumer_connect)
;; TODO: negate boolean? use enum?
(define-mlt mlt-consumer-start (_fun _mlt-consumer -> _bool)
            #:c-id mlt_consumer_start)
(define-mlt mlt-consumer-stop (_fun _mlt-consumer -> _bool)
            #:c-id mlt_consumer_stop)
(define-mlt mlt-consumer-is-stopped (_fun _mlt-consumer -> _bool)
            #:c-id mlt_consumer_is_stopped)

;; mlt_producer
(define-mlt mlt-producer-close (_fun _mlt-producer -> _void)
            #:c-id mlt_producer_close)
(define-mlt mlt-producer-service (_fun _mlt-producer -> _mlt-service)
            #:c-id mlt_producer_service)
