;Name: Jackie Yang
;Date: Oct 22 2024
;Id: 1164236
;OS: pep/9
;Program summary: This program takes in user inputs and checks whether
;        the input is a plaindrome or not. Execution does not end until a single
;        period is inputted.
         Br greeting ;skip data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Data initialization
input:   .BLOCK 35; user input
backward:   .BLOCK 35; user input but backwards
ilower: .BLOCK 35; user input with all cases lowered
blower: .BLOCK 35; backward user input with all cases lowered
length:   .BLOCK 2; length of user input
blength: .BLOCK 2; length of backward input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Print messages
welcome:   .ASCII "Welcome to PALINDROMES\x00"
word:   .ASCII "\nWord:\n\x00"
part1:     .ASCII "The word\x00"
part2t:  .ASCII "is a palindrome\x00"
part2f:  .ASCII "is NOT a plaindrome\n\x00"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;string input and storing 
greeting:STRO welcome, d ;print a greeting\
continue: STRO word, d ;print a greeting\ 
main:    LDBA charIn, d ;takes the first character of the input
         STBA input, x ;places char into input block
         ADDx 1,i ;add 1 to the register 
         CPWa '\n',i ;check if character is a new line
         BRNE main, i ;if not equal to \n go back to the top
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Reverses the user input and stores it into backward
;Does not store the null character from input
STWx length, d ;stores the length of the word into length
reverse: LDWa length, d ;load length of word into accumulator
         LDWx length, d ;load length of word into index
         SUBa 1, i ;minus 1 from length
         STWa length, d ;update length 
         LDBa input, x ;load the input block char at the current index
         LDWx blength, d ;load blength to index
         CPWa '\x00', i      ;check if the current char is null
         BREQ skip, i ;goto skip if equal to null
         CPWa '\n', i ;check if current char is \n
         BREQ skip, i ;goto skip if equal to \n
         STBa backward, x ;put word into backward block
         LDWa blength, d ;load blength to accumulator
         ADDa 1, i ;add 1 to blength
         STWa blength, d ;update blength
skip:    LDWa length, d ;load length of word into accumulator
         CPWa 0, i
         BRGE reverse, i
;Adds newline at the end of backward input
LDWa '\n',i
LDWx blength,d
STBa backward, x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;below handles palindrome checking
;and prints whether user input is a palindrome or not
nextWord:LDWx 0, i ;resets index
         LDBa input, x ;load the first element of the input block
         CPWa '.', i ;checks if it is a period [refine later!!!!!!!!!]
         BREQ quit, i    ;quit if it is a period
         ;STRO backward, d ;prints out the input block
         br lowcase, i; goto lowcase
afterlow:LDWx 0, i ; Returns here after input has been set to lowercase
         br compare, i; goto compare
not:     STRO part2f, d ; prints not a plaindrome 
         br jump, i
true:    STRO part2t, d  ; prints is a plaindrome   
         br jump, i     
jump:    br reset, i; goes here after is or isn't palindrome message is printed
                    ; goto reset to reset input blocks
resume:  LDWx 0, i ;resets index
         BR continue, i    ;returns to top and asks for another input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Compare function compares each character of user input
;with each character of backward user input
compare: LDBa ilower, x ;loads lower cased user input
         CPBa blower, x ;compares character with lower cased backward input
         BRNE not, i; if not equal then returns and prints not a plaindrome
         ADDx 1, i
         CPBa '\n', i; checks if end of word is reached
         BREQ true, i; if the end of the word is reached with all char equal
                     ; then it is a plaindrome
         br compare, i;loops to the top of compare
reset:   LDWx 0, i ;resets index
         STWx blength, d 
         LDBa '\x00', i ;load null into accumulator
reset2:  STBa input, x ;sets all blocks at the current index to null
         STBa backward, x
         STBa ilower, x
         STBa blower, x
         CPWx 34, i; if end of block is reached
         BRGE resume, i; exits loop and goto resume
         ADDx 1, i
         BR reset2, i
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;lowcase1 and 2 sets user input chars to lowercase and stores them
;this allows plaindromes with mixed cases to work
lowcase: LDWx 0, i ;reset index
lowcase2:LDBa input, x ;set accumulator to first word
         CPBa '\x00', i;if end of word is reached
         BREQ lowcase3, i;goto lowcase3 to set backward input
         ;Checks if character is captial or not
         CPBa 91, i
         BRGE false, i
         CPBa 64, i
         BRLE false, i
         ;If it is capital, change it to lowercase and store
         ADDa 32, i
         STBa ilower, x 
         ADDx 1, i
         br lowcase2, i
;lowcase3 and 4 sets backward user input chars to lowercase and stores them
lowcase3:LDWx 0, i 
lowcase4:LDBa backward, x ;set accumulator to first word
         CPBa '\x00', i
         BREQ afterlow, i; returns above to afterlow
         ;Checks if character is captial or not
         CPBa 91, i
         BRGE false2, i
         CPBa 64, i
         BRLE false2, i
         ;If it is capital, change it to lowercase and store
         ADDa 32, i
         STBa blower, x 
         ADDx 1, i
         br lowcase4, i
;If compared char is not a capital goto false and just store
;original character
false:   STBa ilower, x    
         ADDx 1, i  
         br lowcase2,i
false2:  STBa blower, x    
         ADDx 1, i  
         br lowcase4,i
STOP
quit:    .END