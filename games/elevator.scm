; AisleRiot - elevator.scm
; Copyright (C) 1999, 2003 Rosanna Yuen <rwsy@mit.edu>
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(use-modules (aisleriot interface) (aisleriot api))

(define (new-game)
  (initialize-playing-area)
  (set-ace-low)
  (make-standard-deck)
  (shuffle-deck)

  (add-normal-slot DECK)
  (add-normal-slot '())

  (add-blank-slot)
  (add-normal-slot '())

  (add-carriage-return-slot)
  (set! VERTPOS (- VERTPOS 0.5))
  (set! HORIZPOS (+ HORIZPOS 0.5))
  (add-blank-slot)
  (add-blank-slot)
  (add-normal-slot '())
  (add-normal-slot '())

  (add-carriage-return-slot)
  (set! VERTPOS (- VERTPOS 0.5))
  (add-blank-slot)
  (add-blank-slot)
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())

  (add-carriage-return-slot)
  (set! VERTPOS (- VERTPOS 0.5))
  (set! HORIZPOS (+ HORIZPOS 0.5))
  (add-blank-slot)
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())

  (add-carriage-return-slot)
  (set! VERTPOS (- VERTPOS 0.5))
  (add-blank-slot)
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())

  (add-carriage-return-slot)
  (set! VERTPOS (- VERTPOS 0.5))
  (set! HORIZPOS (+ HORIZPOS 0.5))
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())

  (add-carriage-return-slot)
  (set! VERTPOS (- VERTPOS 0.5))
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())
  (add-normal-slot '())

  (deal-cards 0 '(2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22))
  (deal-cards-face-up 0 '(23 24 25 26 27 28 29))

  (give-status-message)

  (list 7 4)
)


(define (give-status-message)
  (set-statusbar-message (get-stock-no-string)))

(define (get-stock-no-string)
  (string-append (G_"Stock left:") " "
		 (number->string (length (get-cards 0)))))

(define (button-pressed slot-id card-list)
  (and (is-visible? (car card-list))
       (not (= slot-id 1))))

(define (check-for-flips slot-id)
  (cond ((= slot-id 29)
	 (if (empty-slot? 28)
	     (flip-top-card 22)
	     ))
	((= slot-id 28)
	 (begin
	   (if (empty-slot? 29)
	       (flip-top-card 22)
	       )
	   (if (empty-slot? 27)
	       (flip-top-card 21)
	       )))
	((= slot-id 27)
	 (begin
	   (if (empty-slot? 28)
	       (flip-top-card 21)
	       )
	   (if (empty-slot? 26)
	       (flip-top-card 20)
	       )))
	((= slot-id 26)
	 (begin
	   (if (empty-slot? 27)
	       (flip-top-card 20)
	       )
	   (if (empty-slot? 25)
	       (flip-top-card 19)
	       )))
	((= slot-id 25)
	 (begin
	   (if (empty-slot? 26)
	       (flip-top-card 19)
	       )
	   (if (empty-slot? 24)
	       (flip-top-card 18)
	       )))
	((= slot-id 24)
	 (begin
	   (if (empty-slot? 25)
	       (flip-top-card 18)
	       )
	   (if (empty-slot? 23)
	       (flip-top-card 17)
	       )))
	((= slot-id 23)
	 (if (empty-slot? 24)
	     (flip-top-card 17)
	     ))
	((= slot-id 22)
	 (if (empty-slot? 21)
	     (flip-top-card 16)
	     ))
	((= slot-id 21)
	 (begin
	   (if (empty-slot? 22)
	       (flip-top-card 16)
	       )
	   (if (empty-slot? 20)
	       (flip-top-card 15)
	       )))
	((= slot-id 20)
	 (begin
	   (if (empty-slot? 21)
	       (flip-top-card 15)
	       )
	   (if (empty-slot? 19)
	       (flip-top-card 14)
	       )))
	((= slot-id 19)
	 (begin
	   (if (empty-slot? 20)
	       (flip-top-card 14)
	       )
	   (if (empty-slot? 18)
	       (flip-top-card 13)
	       )))
	((= slot-id 18)
	 (begin
	   (if (empty-slot? 19)
	       (flip-top-card 13)
	       )
	   (if (empty-slot? 17)
	       (flip-top-card 12)
	       )))
	((= slot-id 17)
	 (if (empty-slot? 18)
	     (flip-top-card 12)
	     ))
	((= slot-id 16)
	 (if (empty-slot? 15)
	     (flip-top-card 11)
	     ))
	((= slot-id 15)
	 (begin
	   (if (empty-slot? 16)
	       (flip-top-card 11)
	       )
	   (if (empty-slot? 14)
	       (flip-top-card 10)
	       )))
	((= slot-id 14)
	 (begin
	   (if (empty-slot? 15)
	       (flip-top-card 10)
	       )
	   (if (empty-slot? 13)
	       (flip-top-card 9)
	       )))
	((= slot-id 13)
	 (begin
	   (if (empty-slot? 14)
	       (flip-top-card 9)
	       )
	   (if (empty-slot? 12)
	       (flip-top-card 8)
	       )))
	((= slot-id 12)
	 (if (empty-slot? 13)
	     (flip-top-card 8)
	     ))
	((= slot-id 11)
	 (if (empty-slot? 10)
	     (flip-top-card 7)
	     ))
	((= slot-id 10)
	 (begin
	   (if (empty-slot? 11)
	       (flip-top-card 7)
	       )
	   (if (empty-slot? 9)
	       (flip-top-card 6)
	       )))
	((= slot-id 9)
	 (begin
	   (if (empty-slot? 10)
	       (flip-top-card 6)
	       )
	   (if (empty-slot? 8)
	       (flip-top-card 5)
	       )))
	((= slot-id 8)
	 (if (empty-slot? 9)
	     (flip-top-card 5)
	     ))
	((= slot-id 7)
	 (if (empty-slot? 6)
	     (flip-top-card 4)
	     ))
	((= slot-id 6)
	 (begin
	   (if (empty-slot? 7)
	       (flip-top-card 4)
	       )
	   (if (empty-slot? 5)
	       (flip-top-card 3)
	       )))
	((= slot-id 5)
	 (if (empty-slot? 6)
	     (flip-top-card 3)
	     ))
	((= slot-id 4)
	 (if (empty-slot? 3)
	     (flip-top-card 2)
	     ))
	((= slot-id 3)
	 (if (empty-slot? 4)
	     (flip-top-card 2)
	     ))))

(define (droppable? start-slot card-list end-slot)
  (and (= end-slot 1) 	   
       (not (empty-slot? 1)) 	 
       (or (= (get-value (get-top-card 1)) 	 
	      (+ 1 (get-value (car card-list)))) 	 
	   (= (+ 1 (get-value (get-top-card 1))) 	 
	      (get-value (car card-list))) 	 
	   (and (= king (get-value (get-top-card 1))) 	 
		(= ace (get-value (car card-list)))) 	 
	   (and (= ace (get-value (get-top-card 1))) 	 
		(= king (get-value (car card-list)))))))
      
(define (button-released start-slot card-list end-slot)
  (if (droppable? start-slot card-list end-slot)
      (begin
	(add-to-score! 1)
	(move-n-cards! start-slot end-slot card-list)
	(check-for-flips start-slot))
      #f))

(define (play-card slot-id)
  (cond 
	 ((= slot-id 0)
	 (if (not (empty-slot? 0))
	     (deal-cards-face-up 0 '(1))
	     #f))
	((and (not (= slot-id 1))
	      (not (empty-slot? slot-id))
	      (is-visible? (get-top-card slot-id))
	      (not (empty-slot? 1))
	      (or (= (get-value (get-top-card 1))
		     (+ 1 (get-value (get-top-card slot-id))))
		  (= (+ 1 (get-value (get-top-card 1)))
		     (get-value (get-top-card slot-id)))
		  (and (= king (get-value (get-top-card 1)))
		       (= ace (get-value (get-top-card slot-id))))
		  (and (= ace (get-value (get-top-card 1)))
		       (= king (get-value (get-top-card slot-id))))))
	 (begin
	   (add-to-score! 1)
	   (deal-cards slot-id '(1))
	   (check-for-flips slot-id)))
	(#t #f)))

(define (dealable?)
  (not (empty-slot? 0)))

(define (do-deal-next-cards)
  (play-card 0))

;; Single-clicking isn't sane in click-to-move more, so we mostly ignore it 
;; in that case.
(define (button-clicked slot-id)
  (if (and (click-to-move?) 
	   (> slot-id 1))
      #f
      (play-card slot-id)))

(define (button-double-clicked slot-id)
  (play-card slot-id))

(define (playable? check-slot)
  (if (or (> check-slot 29)
	  (empty-slot? 1))
      #f
      (if (and (not (empty-slot? check-slot))
	       (is-visible? (get-top-card check-slot))
	       (or (= (get-value (get-top-card 1))
		      (+ 1 (get-value (get-top-card check-slot))))
		   (= (+ 1 (get-value (get-top-card 1)))
		      (get-value (get-top-card check-slot)))
		   (and (= king (get-value (get-top-card 1)))
			(= ace (get-value (get-top-card check-slot))))
		   (and (= ace (get-value (get-top-card 1)))
			(= king (get-value (get-top-card check-slot)))0)))
	  (hint-move check-slot 1 1)
	  (playable? (+ 1 check-slot)))))

(define (game-continuable)
  (give-status-message)
  (and (not (game-won))
       (get-hint)))

(define (game-won)
  (empty-slot? 2))

(define (dealable?)
  (if (not (empty-slot? 0))
      (list 0 (G_"Deal a card"))
      #f))

(define (get-hint)
  (or (playable? 2)
      (dealable?)))

(define (get-options) 
  #f)

(define (apply-options options) 
  #f)

(define (timeout) 
  #f)

(set-features droppable-feature dealable-feature)

(set-lambda new-game button-pressed button-released button-clicked
button-double-clicked game-continuable game-won get-hint get-options
apply-options timeout droppable? dealable?)
