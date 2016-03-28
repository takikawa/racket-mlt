#lang racket/base

(require "mlt.rkt")

(unless (mlt-factory-init #f)
  (error "Unable to locate factory modules"))

(define p (mlt-profile-init #f))

(define hello (mlt-factory-consumer p #f #f))
(define world
  (mlt-factory-producer p #f (vector-ref (current-command-line-arguments) 0)))

(define filter (mlt-factory-filter p "greyscale" #f))
(mlt-filter-connect filter (mlt-producer-service world) 0)

(mlt-consumer-connect hello (mlt-filter-service filter))

(mlt-consumer-start hello)

(let loop ()
  (cond [(mlt-consumer-is-stopped hello)
         (sleep 1)]
        [else
         (loop)]))

(mlt-consumer-close hello)
(mlt-producer-close world)
(mlt-factory-close)
