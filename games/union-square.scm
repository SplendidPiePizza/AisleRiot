; AisleRiot - union_square.scm
; Copyright (C) 1999 Rosanna Yuen <rwsy@mit.edu>
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

(define stock 0)
(define waste 1)
(define tableau '(2 3 4 5 7 8 9 10 12 13 14 15 17 18 19 20))
(define foundation '(6 11 16 21))

(define (new-game)
  (initialize-playing-area)
  (set-ace-low)
  (make-standard-double-deck)
  (shuffle-deck)

  (add-normal-slot DECK 'stock)
  (add-normal-slot '() 'waste)

  (add-blank-slot)

  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)

  (add-blank-slot)

  (add-partially-extended-slot '() right 2 'foundation)

  (add-carriage-return-slot)
  (add-blank-slot)
  (add-blank-slot)
  (add-blank-slot)

  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)

  (add-blank-slot)

  (add-partially-extended-slot '() right 2 'foundation)

  (add-carriage-return-slot)
  (add-blank-slot)
  (add-blank-slot)
  (add-blank-slot)

  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)

  (add-blank-slot)

  (add-partially-extended-slot '() right 2 'foundation)
  (add-carriage-return-slot)
  (add-blank-slot)
  (add-blank-slot)
  (add-blank-slot)

  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)
  (add-partially-extended-slot '() right 2 'tableau)

  (add-blank-slot)

  (add-partially-extended-slot '() right 2 'foundation)

  (deal-cards-face-up 0 '(2 3 4 5 7 8 9 10 12 13 14 15 17 18 19 20))

  (give-status-message)

  (list 10 4)
)

(define (give-status-message)
  (set-statusbar-message (get-stock-no-string)))

(define (get-stock-no-string)
  (string-append (G_"Stock left:") " " 
		 (number->string (length (get-cards 0)))))


(define (button-pressed slot-id card-list)
  (and (not (empty-slot? slot-id))
       (is-visible? (car card-list))
       (= (length card-list) 1)
       (not (or (= slot-id 6)
		(= slot-id 11)
		(= slot-id 16)
		(= slot-id 21)))))

(define (to-foundation? card-list end-slot)
  (if (empty-slot? end-slot)
      (and (eq? (get-value (car card-list)) ace)
	   (or (= end-slot 6)
	       (empty-slot? 6)
	       (not (eq? (get-suit (get-top-card 6))
			 (get-suit (car card-list)))))
	   (or (= end-slot 11)
	       (empty-slot? 11)
	       (not (eq? (get-suit (get-top-card 11))
			 (get-suit (car card-list)))))
	   (or (= end-slot 16)
	       (empty-slot? 16)
	       (not (eq? (get-suit (get-top-card 16))
			 (get-suit (car card-list)))))
	   (or (= end-slot 21)
	       (empty-slot? 21)
	       (not (eq? (get-suit (get-top-card 21))
			 (get-suit (car card-list))))))
      (if (eq? (get-suit (get-top-card end-slot))
	       (get-suit (car card-list)))
	  (cond ((< (length (get-cards end-slot)) 13)
		 (= (+ 1 (get-value (get-top-card end-slot)))
		    (get-value (car card-list))))
		((= (length (get-cards end-slot)) 13)
		 (= (get-value (car card-list)) 13))
		(#t
		 (= (get-value (get-top-card end-slot))
		    (+ 1 (get-value (car card-list))))))
	  #f)))

(define (to-tableau? card-list end-slot)
  (if (empty-slot? end-slot)
      #t
      (if (eq? (get-suit (get-top-card end-slot))
	       (get-suit (car card-list)))
	  (cond ((= (length (get-cards end-slot)) 1)
		 (or (= (get-value (car card-list))
			(+ 1 (get-value (get-top-card end-slot))))
		     (= (+ 1 (get-value (car card-list)))
			(get-value (get-top-card end-slot)))))
		((= (get-value (get-top-card end-slot))
		    (+ 1 (get-value (cadr (get-cards end-slot)))))
		 (= (get-value (car card-list))
		    (+ 1 (get-value (get-top-card end-slot)))))
		((= (+ 1 (get-value (get-top-card end-slot)))
		    (get-value (cadr (get-cards end-slot))))
		 (= (+ 1 (get-value (car card-list)))
		    (get-value (get-top-card end-slot))))
		(#t #f))
	  #f)))

(define (droppable? start-slot card-list end-slot)
  (cond ((or (= end-slot start-slot)
             (= end-slot 0)
	     (= end-slot 1))
	 #f)
	((or (= end-slot 6)
	     (= end-slot 11)
	     (= end-slot 16)
	     (= end-slot 21))
	 (to-foundation? card-list end-slot))
	(#t
	 (to-tableau? card-list end-slot))))

(define (button-released start-slot card-list end-slot)
  (and (droppable? start-slot card-list end-slot)
       (cond ((or (= end-slot 6)
                  (= end-slot 11)
	          (= end-slot 16)
	          (= end-slot 21))
	      (and (move-n-cards! start-slot end-slot card-list)
		   (add-to-score! 1)))
	     (#t
	      (move-n-cards! start-slot end-slot card-list)))))

(define (button-clicked slot-id)
  (and (= slot-id 0)
       (not (empty-slot? 0))
       (deal-cards-face-up 0 '(1))))

(define (play-foundation-helper start-slot end-slots)
  (define card (get-top-card start-slot))
  (if (to-foundation? (list card) (car end-slots))
      (and (remove-card start-slot)
           (move-n-cards! start-slot (car end-slots) (list card))
           (add-to-score! 1))
      (if (eq? (cdr end-slots) '())
          #f
          (play-foundation-helper start-slot (cdr end-slots)))))

(define (button-double-clicked slot-id)
  (cond ((member slot-id '(1 2 3 4 5 7 8 9 10 12 13 14 15 17 18 19 20))
         (and (not (empty-slot? slot-id))
              (play-foundation-helper slot-id '(6 11 16 21))))
        ((member slot-id '(6 11 16 21))
         (autoplay-foundations))
        (#t #f)))

(define (autoplay-foundations)
  (define (autoplay-foundations-tail)
    (if (or-map button-double-clicked '(1 2 3 4 5 7 8 9 10 12 13 14 15 17 18 19 20))
        (delayed-call autoplay-foundations-tail)
        #t))
  (if (or-map button-double-clicked '(1 2 3 4 5 7 8 9 10 12 13 14 15 17 18 19 20))
      (autoplay-foundations-tail)
      #f))

(define (game-continuable)
  (give-status-message)
  (not (game-won)))

(define (game-won)
  (and (= (length (get-cards 6)) 26)
       (= (length (get-cards 11)) 26)
       (= (length (get-cards 16)) 26)
       (= (length (get-cards 21)) 26)))

(define (check-a-foundation card-list end-slot)
  (if (> end-slot 21)
      #f
      (if (to-foundation? card-list end-slot)
	  end-slot
	  (check-a-foundation card-list (+ 5 end-slot)))))

(define (check-to-foundations slot-id)
  (if (> slot-id 20)
      #f
      (if (or (empty-slot? slot-id)
	      (= slot-id 6)
	      (= slot-id 11)
	      (= slot-id 16)
	      (not (check-a-foundation (list (get-top-card slot-id)) 6)))
	  (check-to-foundations (+ 1 slot-id))
	  (hint-move slot-id 1 (check-a-foundation (list (get-top-card slot-id)) 6)))))

(define (check-imbedded card-list foundation-id)
  (if (> (length card-list) 0)
      (if (to-foundation? card-list foundation-id)
	  #t
	  (check-imbedded (cdr card-list) foundation-id))
      #f))

(define (check-slot-contents slot-id)
  (cond ((and (not (empty-slot? 6))
	      (eq? (get-suit (get-top-card slot-id))
		   (get-suit (get-top-card 6)))
	      (check-imbedded (get-cards slot-id) 6))
	 (check-imbedded (get-cards slot-id) 6))
	((and (not (empty-slot? 11))
	      (eq? (get-suit (get-top-card slot-id))
		   (get-suit (get-top-card 11)))
	      (check-imbedded (get-cards slot-id) 11))
	 (check-imbedded (get-cards slot-id) 11))
	((and (not (empty-slot? 16))
	      (eq? (get-suit (get-top-card slot-id))
		   (get-suit (get-top-card 16)))
	      (check-imbedded (get-cards slot-id) 16))
	 (check-imbedded (get-cards slot-id) 16))
	((and (not (empty-slot? 21))
	      (eq? (get-suit (get-top-card slot-id))
		   (get-suit (get-top-card 21)))
	      (check-imbedded (get-cards slot-id) 21))
	 (check-imbedded (get-cards slot-id) 21))
	((and (empty-slot? 6)
	      (check-imbedded (get-cards slot-id) 6))
	 (check-imbedded (get-cards slot-id) 6))
	((and (empty-slot? 11)
	      (check-imbedded (get-cards slot-id) 11))
	 (check-imbedded (get-cards slot-id) 11))
	((and (empty-slot? 16)
	      (check-imbedded (get-cards slot-id) 16))
	 (check-imbedded (get-cards slot-id) 16))
	((and (empty-slot? 21)
	      (check-imbedded (get-cards slot-id) 21))
	 (check-imbedded (get-cards slot-id) 21))
	((and (> (length (get-cards slot-id)) 1)
	      (or (and (not (= slot-id 2))
		       (not (empty-slot? 2))
		       (to-tableau? (reverse (get-cards slot-id)) 2)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 2)))))
		  (and (not (= slot-id 3))
		       (not (empty-slot? 3))
		       (to-tableau? (reverse (get-cards slot-id)) 3)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 3)))))
		  (and (not (= slot-id 4))
		       (not (empty-slot? 4))
		       (to-tableau? (reverse (get-cards slot-id)) 4)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 4)))))
		  (and (not (= slot-id 5))
		       (not (empty-slot? 5))
		       (to-tableau? (reverse (get-cards slot-id)) 5)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 5)))))
		  (and (not (= slot-id 7))
		       (not (empty-slot? 7))
		       (to-tableau? (reverse (get-cards slot-id)) 7)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 7)))))
		  (and (not (= slot-id 8))
		       (not (empty-slot? 8))
		       (to-tableau? (reverse (get-cards slot-id)) 8)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 8)))))
		  (and (not (= slot-id 9))
		       (not (empty-slot? 9))
		       (to-tableau? (reverse (get-cards slot-id)) 9)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 9)))))
		  (and (not (= slot-id 10))
		       (not (empty-slot? 10))
		       (to-tableau? (reverse (get-cards slot-id)) 10)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 10)))))
		  (and (not (= slot-id 12))
		       (not (empty-slot? 12))
		       (to-tableau? (reverse (get-cards slot-id)) 12)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 12)))))
		  (and (not (= slot-id 13))
		       (not (empty-slot? 13))
		       (to-tableau? (reverse (get-cards slot-id)) 13)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 13)))))
		  (and (not (= slot-id 14))
		       (not (empty-slot? 14))
		       (to-tableau? (reverse (get-cards slot-id)) 14)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 14)))))
		  (and (not (= slot-id 15))
		       (not (empty-slot? 15))
		       (to-tableau? (reverse (get-cards slot-id)) 15)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 15)))))
		  (and (not (= slot-id 17))
		       (not (empty-slot? 17))
		       (to-tableau? (reverse (get-cards slot-id)) 17)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 17)))))
		  (and (not (= slot-id 18))
		       (not (empty-slot? 18))
		       (to-tableau? (reverse (get-cards slot-id)) 18)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 18)))))
		  (and (not (= slot-id 19))
		       (not (empty-slot? 19))
		       (to-tableau? (reverse (get-cards slot-id)) 19)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 19)))))
		  (and (not (= slot-id 20))
		       (not (empty-slot? 20))
                       (to-tableau? (reverse (get-cards slot-id)) 20)
		       (not (= (get-value (cadr (reverse (get-cards slot-id))))
			       (get-value (get-top-card 20)))))))
	 #t)
	(#t #f)))

(define (check-a-tslot slot1 slot2)
  (if (> slot2 20)
      #f
      (if (and (not (= slot2 6))
	       (not (= slot2 11))
	       (not (= slot2 16))
	       (not (empty-slot? slot2))
	       (not (= slot1 slot2))
	       (not (empty-slot? slot1))
	       (to-tableau? (list (get-top-card slot1)) slot2)
	       (or (= slot1 1)
		   (= (length (get-cards slot1)) 1)
		   (not (= (get-value (cadr (get-cards slot1)))
			   (get-value (get-top-card slot2))))))
	  (if (and (not (= slot1 1))
		   (not (empty-slot? slot2))
		   (to-tableau? (list (get-top-card slot2)) slot1)
		   (check-slot-contents slot2))
	      (hint-move slot2 1 slot1)
	      (hint-move slot1 1 slot2))
	  (check-a-tslot slot1 (+ 1 slot2)))))

(define (check-tableau slot-id)
  (if (= slot-id 1)
      (and (not (empty-slot? 1))
	   (check-a-tslot 1 2))
      (if (or (= slot-id 6)
	      (= slot-id 11)
	      (= slot-id 16))
	  (check-tableau (- slot-id 1))
	  (or (check-a-tslot slot-id 2)
	      (check-tableau (- slot-id 1))))))

(define (check-for-empty slot-id)
  (if (= slot-id 21)
      #f
      (if (and (not (= slot-id 6))
	       (not (= slot-id 11))
	       (not (= slot-id 16))
	       (empty-slot? slot-id))
	  slot-id
	  (check-for-empty (+ 1 slot-id)))))

(define (check-rev-tableau slot1 slot2)
  (if (= slot2 21)
      #f
      (if (or (empty-slot? slot2)
	      (= slot1 slot2)
	      (= slot2 6)
	      (= slot2 11)
	      (= slot2 16))
	  (check-rev-tableau slot1 (+ 1 slot2))
	  (if (and (to-tableau? (reverse (get-cards slot1)) slot2)
		   (= (abs (- (get-value (cadr (reverse (get-cards slot1))))
			      (get-value (get-top-card slot2))))
		      2))
	      slot1
	      (check-rev-tableau slot1 (+ 1 slot2))))))

(define (check-for-bottom slot-id)
  (if (= slot-id 21)
      #f
      (if (or (empty-slot? slot-id)
	      (= 1 (length (get-cards slot-id)))
	      (= slot-id 6)
	      (= slot-id 11)
	      (= slot-id 16))
	  (check-for-bottom (+ 1 slot-id))
	  (or (check-rev-tableau slot-id 2)
	      (check-for-bottom (+ 1 slot-id))))))
	      
(define (contents-check slot-id)
  (if (= slot-id 21)
      #f
      (if (and (not (= slot-id 6))
	       (not (= slot-id 11))
	       (not (= slot-id 16))
	       (not (empty-slot? slot-id))
	       (check-slot-contents slot-id))
	  slot-id
	  (contents-check (+ 1 slot-id)))))

(define (check-empty-slot)
  (if (not (check-for-empty 2))
      #f
      (cond ((contents-check 2)
	     (hint-move (contents-check 2) 1 (find-empty-slot tableau)))
	    ((check-for-bottom 2)
	     (hint-move (check-for-bottom 2) 1 (find-empty-slot tableau)))
	    ((not (empty-slot? waste))
	     (hint-move waste 1 (find-empty-slot tableau)))
	    (#t #f))))

(define (dealable?)
  (if (not (empty-slot? 0))
      (list 0 (G_"Deal a card"))
      #f))

(define (get-hint)
  (or (check-to-foundations 1)
      (check-tableau 20)
      (check-empty-slot)
      (dealable?)
      (list 0 (G_"No hint available right now"))))

(define (get-options) 
  #f)

(define (apply-options options) 
  #f)

(define (timeout) 
  #f)

(set-features droppable-feature)

(set-lambda new-game button-pressed button-released button-clicked
button-double-clicked game-continuable game-won get-hint get-options
apply-options timeout droppable?)

