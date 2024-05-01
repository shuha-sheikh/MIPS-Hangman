# MIPS-Hangman
Hangman - complete version\
Uses noargs front end\
Enter word to be guessed with newline character at end\
Enter 1 letter at a time (case sensitive)\
6 strikes at most\
Does not keep track of guessed characters\

Registers:\
 $1 --> input\
 $2 --> output\
 $3 --> word length\
 $4 --> pointer to word\
 $5 --> pivot element\
 $6 --> pointer to game state\
 $7 --> number of correct guesses, counter\
 $8 --> number of incorrect guesses, counter\
 $9 --> secondary counter\
 $10 --> comparison\
 $16 --> constant, newline char\
 $17 --> constant, underscore char\
 $18 --> constant, W\
 $19 --> constant, L\
 $20 --> boolean value\
 $30 --> stack
