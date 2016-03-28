#lang racket/base

(require "mlt.rkt")

(unless (mlt-factory-init #f)
  (error "Unable to locate factory modules"))

(define profile (mlt-profile-init #f))

;; -> _mlt_playlist
(define (create-playlist)
  (define playlist (mlt-playlist-init))
  (define properties (mlt-playlist-properties playlist))

  (for ([arg (in-vector (current-command-line-arguments))])
    (define producer (mlt-factory-producer profile #f arg))

    (mlt-playlist-append playlist producer)
    (mlt-producer-close producer))

  (mlt-playlist-producer playlist))

(define hello (mlt-factory-consumer profile #f #f))
(define world (create-playlist))

(mlt-consumer-connect hello (mlt-producer-service world))

(mlt-consumer-start hello)

(let loop ()
  (cond [(mlt-consumer-is-stopped hello)
         (sleep 1)]
        [else
         (loop)]))

(mlt-consumer-close hello)
(mlt-producer-close world)
(mlt-factory-close)
