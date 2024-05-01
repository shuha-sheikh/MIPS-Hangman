;; Input/Output --------------------------------------------------------------------------

lis $1
        .word 0xffff0004                ;; input
lis $2
        .word 0xffff000c                ;; output

;; Constants ---------------------------------------------------------------------------

addi $16, $0, 0xA                       ;; newline character
addi $17, $0, 0x5F                      ;; underscore
addi $18, $0, 0x57			;; W
addi $19, $0, 0x4C			;; L

;; Setup ----------------------------------------------------------------------------

add $3, $0, $0				;; word length
add $7, $0, $0				;; number of correct guesses
addi $8, $0, 6				;; number of incorrect guesses

addi $4, $30, -4			;; pointer to bottom of stack

lw $5, 0($1)				;; read character
read:   beq $5, $16,  initgame          ;; word read
        sw $5, 0($4)                    ;; push character on stack
        addi $3, $3, 1                  ;; increment counter
	addi $4, $4, -4                 ;; make space on stack
	lw $5, 0($1)			;; read next character
        beq $0, $0, read

initgame: addi $6, $4, -4		;; $6 points to top of stack
	  add $9, $0, $0		;; counter

initgameloop: beq $9, $3, readjust	;; whole game state initialized
	      sw $17, 0($6)		;; initialize to all underscores
	      addi $6, $6, -4		;; make space on stack
	      addi $9, $9, 1		;; increment counter
	      beq $0, $0, initgameloop

;; Main Loop ------------------------------------------------------------------------

readjust: beq $9, $0, guess
	  addi $4, $4, 4		;; move back one position
	  addi $6, $6, 4		;; move back one position
	  addi $9, $9, -1		;; decrement counter
	  beq $0, $0, readjust

guess:	lw $5, 0($1)
	beq $5, $16, guess		;; while character read is newline

add $20, $0, $0				;; boolean value

update:	beq $9, $3, readjust2
	lw $10, 0($6)			;; letter in game state
	beq $10, $17, valid             ;; letter not yet guessed
	addi $4, $4, -4
        addi $6, $6, -4
        addi $9, $9, 1                  ;; increment counter
	beq $0, $0, update

valid:	lw $10, 0($4)			;; letter in original word
	beq $10, $5, correct            ;; guess is correct
	addi $4, $4, -4
	addi $6, $6, -4
	addi $9, $9, 1
	beq $0, $0, update

correct: sw $5, 0($6)			;; replace underscore by letter
	 addi $4, $4, -4
	 addi $6, $6, -4
	 addi $9, $9, 1			;; increment counter
	 addi $7, $7, 1			;; increment correct guess counter
	 addi $20, $0, 1		;; boolean value
	 beq $0, $0, update

readjust2: beq $9, $0, print
           addi $4, $4, 4                ;; move back one position
           addi $6, $6, 4                ;; move back one position
           addi $9, $9, -1               ;; decrement counter
           beq $0, $0, readjust2

print:	beq $9, $3, check
	lw $10, 0($6)			 ;; current letter in game state
	sw $10, 0($2)			 ;; print to output
	addi $6, $6, -4
	addi $4, $4, -4
	addi $9, $9, 1			 ;; decrement counter
	beq $0, $0, print

check:	sw $16, 0($2)			 ;; print newline to output
	beq $20, $0, wrong		 ;; boolean = 0 ==> wrong guess
	beq $7, $3, win			 ;; all letters guessed
	beq $0, $0, readjust

wrong:	addi $8, $8, -1			 ;; wrong guess ==> decrement strikes
	beq $8, $0, lose		 ;; all strikes over
	beq $0, $0, readjust

win:	sw $18, 0($2)			 ;; print W
	sw $16, 0($2)			 ;; print newline
	beq $0, $0, release		 ;; release stack

lose:	sw $19, 0($2)			 ;; print L
	sw $16, 0($2)			 ;; print newline
	beq $0, $0, release		 ;; release stack

release:   beq $9, $0, end
           addi $4, $4, 4                ;; move back one position
           addi $6, $6, 4                ;; move back one position
           addi $9, $9, -1               ;; decrement counter
           beq $0, $0, release

end:	jr $31
