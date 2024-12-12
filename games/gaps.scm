; AisleRiot - gaps.scm
; Copyright (C) 2005 Zach Keene <zjkeene@bellsouth.net>
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

(use-modules (aisleriot interface) (aisleriot api) (ice-9 format))

(define row1 '(0 1 2 3 4 5 6 7 8 9 10 11 12))
(define row2 '(13 14 15 16 17 18 19 20 21 22 23 24 25))
(define row3 '(26 27 28 29 30 31 32 33 34 35 36 37 38))
(define row4 '(39 40 41 42 43 44 45 46 47 48 49 50 51))
(def-save-var rows (vector row1 row2 row3 row4))

(define random-gaps #f)

(define (new-game)
  (initialize-playing-area)
  (make-standard-deck)
  (shuffle-deck)

  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-carriage-return-slot)

  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-carriage-return-slot)

  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-carriage-return-slot)

  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-normal-slot '() )
  (add-carriage-return-slot)

  (deal-cards-face-up-from-deck DECK (append row1 row2 row3 row4))
  (remove-aces (append row1 row2 row3 row4))

  (set! rows (vector row1 row2 row3 row4))
  (check-sequence 0)
  (check-sequence 13)
  (check-sequence 26)
  (check-sequence 39)

  (give-status-message)
  (list 13 4)
)

(define (give-status-message)
  (set-statusbar-message (string-append (G_"Redeals left:") " "
                                        (number->string (- 2 FLIP-COUNTER))
                         )
  )
)

(define (remove-aces slot-list)
  (if (not (null? slot-list))
    (begin 
      (if (= (get-value(get-top-card (car slot-list))) ace)
          (remove-card (car slot-list))
      )
      (remove-aces (cdr slot-list))
    )
  )
)

(define (button-pressed slot-id card-list) 
  (define rowlist (vector-ref rows (quotient slot-id 13)))
  (member slot-id rowlist)
)

(define (button-released start-slot card-list end-slot)
  (and (droppable? start-slot card-list end-slot)
       (complete-transaction start-slot card-list end-slot)
  ) 
)

(define (droppable? start-slot card-list end-slot)
  (and (empty-slot? end-slot)
       (not (= start-slot end-slot))
       (if (= 0 (modulo end-slot 13))
           (= 2 (get-value(car card-list)))
           (and (not (empty-slot? (- end-slot 1)))
                (= (get-value(car card-list))
                   (+ (get-value(get-top-card (- end-slot 1))) 1)
                )
                (= (get-suit(car card-list))
                   (get-suit(get-top-card (- end-slot 1)))
                )
           )
       )
  )
)

(define (complete-transaction start-slot card-list end-slot)
  (move-n-cards! start-slot end-slot card-list)
  (check-sequence end-slot)
)

(define (check-sequence slot)
  (define rowlist (vector-ref rows (quotient slot 13)))

  (if (and (not (empty-slot? (car rowlist)))
           (= (modulo (car rowlist) 13)
              (- (get-value(get-top-card (car rowlist))) 2)
           )
           (or (= (get-value(get-top-card (car rowlist))) 2)
               (= (get-suit(get-top-card (car rowlist))) 
                  (get-suit(get-top-card (- (car rowlist) 1)))
               )
           )
      )
      (begin 
        (vector-set! rows (quotient slot 13) (cdr rowlist))
        (add-to-score! 1)
        (check-sequence slot)
      )
  )
)

(define (redeal-needed? row blocked) 
  (for-each 
    (lambda (x) 
      (if (and (empty-slot? x)
               (not (= (modulo x 13) 0))
               (or (empty-slot? (- x 1))
                   (= (get-value(get-top-card(- x 1))) king)
               )               
          )
          (set! blocked (+ blocked 1))
      )
    )
    (vector-ref rows row)
  )
  (if (< row 3)
    (redeal-needed? (+ row 1) blocked)
    (= blocked 4)
  )
)

(define (button-clicked slot-id) #f)

(define (button-double-clicked slot-id)
  (if (and (redeal-needed? 0 0) (< FLIP-COUNTER 2))
    (collect-and-deal)
    #f
  )
)
      

(define (game-continuable)
  (give-status-message)
  (and (not (and (= FLIP-COUNTER 2) (redeal-needed? 0 0)))
       (not (game-won))
  )
)

(define (collect-and-deal)
  (define collection '())
  (set! FLIP-COUNTER (+ FLIP-COUNTER 1))
  (for-each
    (lambda (x)
      (if (not (empty-slot? x))
          (begin
            (set! collection (append (list (make-card 
                                             (get-value(get-top-card x))
                                             (get-suit(get-top-card x))
                                           )
                                      )
                                      collection
                              )
            )
            (remove-card x)
          )
      )
    )
    (append (vector-ref rows 0) (vector-ref rows 1) (vector-ref rows 2)
            (vector-ref rows 3)
    )
  )
  (set! DECK collection)
  (if random-gaps
    (for-each 
      (lambda (x)
        (set! DECK (append (list (make-card ace club)) DECK))
      )
      '(1 2 3 4)
    )
  )
  (shuffle-deck)
  (if random-gaps
    (begin
      (deal-cards-face-up-from-deck DECK (append (vector-ref rows 0)
                                                 (vector-ref rows 1)
                                                 (vector-ref rows 2)
                                                 (vector-ref rows 3)
                                         )
      )
      (remove-aces (append (vector-ref rows 0) (vector-ref rows 1)
                           (vector-ref rows 2) (vector-ref rows 3)
                   )
      )
    )   
    (deal-cards-face-up-from-deck DECK (append (cdr (vector-ref rows 0))
                                               (cdr (vector-ref rows 1))
                                               (cdr (vector-ref rows 2))
                                               (cdr (vector-ref rows 3))
                                       )
    )
  )
  (check-sequence 0)
  (check-sequence 13)
  (check-sequence 26)
  (check-sequence 39)
  #t
)

(define (game-won)
  (equal? rows (vector '(12) '(25) '(38) '(51)))
)

(define (get-hint)
  (if (redeal-needed? 0 0)
      (list 0 (G_"Double click any card to redeal."))
      (or (add-to-sequence? 0)
          (playable-gap? (vector-ref rows 0))
          (playable-gap? (vector-ref rows 1))
          (playable-gap? (vector-ref rows 2))
          (playable-gap? (vector-ref rows 3))
          (list 0 (G_"No hint available."))
      )
  )
)

(define (add-to-sequence? row)
  (if (empty-slot? (car (vector-ref rows row)))
      (if (= 0 (modulo (car (vector-ref rows row)) 13))
          (list 0 (format #f
                          (G_"Place a two in the leftmost slot of row ~a.")
			  (number->string (+ row 1))))
          (if (not (= 12 (modulo (car (vector-ref rows row)) 13)))
	      (list 0 (format #f
                              (G_"Add to the sequence in row ~a.")
			      (number->string (+ row 1))))
	      (if (< row 3)
		  (add-to-sequence? (+ row 1))
		  #f)))
      (if (< row 3)
          (add-to-sequence? (+ row 1))
          #f)))

(define (hint-move-card card)
  (let ((value (get-value card)) (suit (get-suit card)))
     (cond ((eq? suit club) 
            (cond ((eq? value ace) (G_"Place the two of clubs next to the ace of clubs."))
                  ((eq? value 2) (G_"Place the three of clubs next to the two of clubs."))
                  ((eq? value 3) (G_"Place the four of clubs next to the three of clubs."))
                  ((eq? value 4) (G_"Place the five of clubs next to the four of clubs."))
                  ((eq? value 5) (G_"Place the six of clubs next to the five of clubs."))
                  ((eq? value 6) (G_"Place the seven of clubs next to the six of clubs."))
                  ((eq? value 7) (G_"Place the eight of clubs next to the seven of clubs."))
                  ((eq? value 8) (G_"Place the nine of clubs next to the eight of clubs."))
                  ((eq? value 9) (G_"Place the ten of clubs next to the nine of clubs."))
                  ((eq? value 10) (G_"Place the jack of clubs next to the ten of clubs."))
                  ((eq? value jack) (G_"Place the queen of clubs next to the jack of clubs."))
                  ((eq? value queen) (G_"Place the king of clubs next to the queen of clubs."))
                  (#t "ERROR")))
           ((eq? suit spade) 
            (cond ((eq? value ace) (G_"Place the two of spades next to the ace of spades."))
                  ((eq? value 2) (G_"Place the three of spades next to the two of spades."))
                  ((eq? value 3) (G_"Place the four of spades next to the three of spades."))
                  ((eq? value 4) (G_"Place the five of spades next to the four of spades."))
                  ((eq? value 5) (G_"Place the six of spades next to the five of spades."))
                  ((eq? value 6) (G_"Place the seven of spades next to the six of spades."))
                  ((eq? value 7) (G_"Place the eight of spades next to the seven of spades."))
                  ((eq? value 8) (G_"Place the nine of spades next to the eight of spades."))
                  ((eq? value 9) (G_"Place the ten of spades next to the nine of spades."))
                  ((eq? value 10) (G_"Place the jack of spades next to the ten of spades."))
                  ((eq? value jack) (G_"Place the queen of spades next to the jack of spades."))
                  ((eq? value queen) (G_"Place the king of spades next to the queen of spades."))
                  (#t "ERROR")))
           ((eq? suit heart) 
            (cond ((eq? value ace) (G_"Place the two of hearts next to the ace of hearts."))
                  ((eq? value 2) (G_"Place the three of hearts next to the two of hearts."))
                  ((eq? value 3) (G_"Place the four of hearts next to the three of hearts."))
                  ((eq? value 4) (G_"Place the five of hearts next to the four of hearts."))
                  ((eq? value 5) (G_"Place the six of hearts next to the five of hearts."))
                  ((eq? value 6) (G_"Place the seven of hearts next to the six of hearts."))
                  ((eq? value 7) (G_"Place the eight of hearts next to the seven of hearts."))
                  ((eq? value 8) (G_"Place the nine of hearts next to the eight of hearts."))
                  ((eq? value 9) (G_"Place the ten of hearts next to the nine of hearts."))
                  ((eq? value 10) (G_"Place the jack of hearts next to the ten of hearts."))
                  ((eq? value jack) (G_"Place the queen of hearts next to the jack of hearts."))
                  ((eq? value queen) (G_"Place the king of hearts next to the queen of hearts."))
                  (#t "ERROR")))
           ((eq? suit diamond) 
            (cond ((eq? value ace) (G_"Place the two of diamonds next to the ace of diamonds."))
                  ((eq? value 2) (G_"Place the three of diamonds next to the two of diamonds."))
                  ((eq? value 3) (G_"Place the four of diamonds next to the three of diamonds."))
                  ((eq? value 4) (G_"Place the five of diamonds next to the four of diamonds."))
                  ((eq? value 5) (G_"Place the six of diamonds next to the five of diamonds."))
                  ((eq? value 6) (G_"Place the seven of diamonds next to the six of diamonds."))
                  ((eq? value 7) (G_"Place the eight of diamonds next to the seven of diamonds."))
                  ((eq? value 8) (G_"Place the nine of diamonds next to the eight of diamonds."))
                  ((eq? value 9) (G_"Place the ten of diamonds next to the nine of diamonds."))
                  ((eq? value 10) (G_"Place the jack of diamonds next to the ten of diamonds."))
                  ((eq? value jack) (G_"Place the queen of diamonds next to the jack of diamonds."))
                  ((eq? value queen) (G_"Place the king of diamonds next to the queen of diamonds."))
                  (#t "ERROR")))
           (#t "ERROR"))))

(define (playable-gap? slotlist)
  (if (null? slotlist)
      #f
      (if (and (empty-slot? (car slotlist))
               (not (empty-slot? (- (car slotlist) 1)))
               (not (= king (get-value(get-top-card(- (car slotlist) 1)))))
	       )
	  (let ((target-card (get-top-card (- (car slotlist) 1))))
	    (list 0 (hint-move-card target-card)))
           (playable-gap? (cdr slotlist))
      )
  )
)

(define (get-options)
  (list (list (G_"Randomly Placed Gaps on Redeal") random-gaps))
)

(define (apply-options options)
  (set! random-gaps (cadar options))
)

(define (timeout) #f)

(set-features droppable-feature)

(set-lambda new-game button-pressed button-released button-clicked 
            button-double-clicked game-continuable game-won get-hint 
            get-options apply-options timeout droppable?
)
