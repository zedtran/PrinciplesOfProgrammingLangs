
#lang plai


(require racket/path)


;;creates global list variable called tokens
;;reads in every line from tokens file and saves
;;each token/lexeme pair as a separate list item
(define tokens (file->lines (string->path "/Users/donaldtran/Documents/AU Course Work and Info/2017/Spring 2017/COMP 3220/Assignment 1 - Ruby/KEY/tokens")));;home computer


;;helper function
;;retrieves the first token from the list of tokens
(define current_token
  (lambda ()
    (regexp-split #px" " (car tokens))
    );end lambda
  );end current_token

;;helper function
;;removes one token from the tokens list
;;so that current_token function always extracts
;;the next available token
(define next_token
  (lambda ()
    (set! tokens (cdr tokens))
    (cond
      ((null? tokens)
       (display "No more tokens to parse!")
       (newline)
       (display "Exiting prematurely, no eof found")
       (inc-count)
       (newline)
       (exit));end null tokens
      (else
       (cond
         ((equal? (car (current_token)) "whitespace")
          (next_token);call yourself again
          )     
         );end cond
       );end else
      );end cond
    );end lambda
  );end next_token
    

;;checks ID rule
;;if current_token is an id token
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
;;if current_token is not id, displays an error message
(define id
  (lambda ()
    (display "Entering <id>")
    (newline)
    (cond
      ((equal? (car (current_token)) "id")
       (display "Found ")
       (display (second (current_token)))
       (newline)
       (next_token)
       (display "Leaving <id>")
       (newline)
       );end first equality check in condition
      (else
       (display "Not an id token: Error")
       (inc-count)
       (newline)
       );end else statement
      );end condition block
    );end lambda
  );end id

;;checks int rule
;;if current_token is an int token
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
;;if current_token is not int, displays an error message
(define int
  (lambda ()
    (display "Entering <int>")
    (newline)
    (cond
      ((equal? (car (current_token)) "int")
       (display "Found ")
       (display (second (current_token)))
       (newline)
       (next_token)
       (display "Leaving <int>")
       (newline)
       );end first equality check in condition
      (else
       (display "Not an int token: Error")
       (inc-count)
       (newline)
       );end else statement
      );end condition block
    );end lambda
  );end int


;;checks whitespace rule
;;if current_token is a whitespace token
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
;;if current_token is not whitespace, displays an error message
(define whitespace
  (lambda ()
    (display "Entering <whitespace>")
    (newline)
    (cond
      ((equal? (car (current_token)) " ")
       (display "Found ")
       (display (second (current_token)))
       (newline)
       (next_token)
       (display "Leaving <whitespace>")
       (newline)
       );end first equality check in condition
      ((equal? (car (current_token)) "\n")
       (display "Found ")
       (display (second (current_token)))
       (newline)
       (next_token)
       (display "Leaving <whitespace>")
       (newline)
      );end second equality check in condition 
      (else
       (display "Error: Not a whitespace token")
       (inc-count)
       (newline)
       );end else statement
      );end condition block
    );end lambda
  );end whitespace



;;checks factor rule
;;prints terminals along the way, calling the appropriate function
;;for non-terminals
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
(define factor
  (lambda ()
    (display "Entering <factor>")
    (cond
      [(equal? (car (current_token)) "id")
       (newline)
       (id)
       (display "Leaving <factor>")];end first equality check in condition
      [(equal? (car (current_token)) "int")
       (newline)
       (int)
       (display "Leaving <factor>")];end second equality check in condition
      [(equal? (car (current_token)) "(")
       (newline)
       (display "Found ")
       (display (second (current_token)))
       (next_token)
       (newline)
       (exp)
         (cond
            [(equal? (car (current_token)) ")")
             (newline)
             (display "Found ")
             (display (second (current_token)))
             (next_token)
             (newline)
             (display "Leaving <factor>")]
            (else
             (newline)
             (display "Error: expected ')' but received ")
             (display "'")
             (display (second (current_token)))
             (display "'")
             (inc-count)
            )
         )
      ]
      (else
        (display "Error: No ID, interger literal, or left parentheses detected (<factor>)")
        (inc-count)
        (newline)
       );end else statement
      );end condition block
      );end lambda
    );end define factor


;;checks stmt rule
;;prints terminals along the way, calling the appropriate function
;;for non-terminals
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
(define stmt
  (lambda ()
    (display "Entering <stmt>")
    (cond
      [(equal? (car (current_token)) "print")
       (newline)
       (display "Found ")
       (display (second (current_token)))
       (next_token)
       (newline)
       (exp)
       (newline)
       (display "Leaving <stmt>")];end first equality check in condition
      (else
       (assign)
       (newline)
       (display "Leaving <stmt>") 
       );end else statement
    );end condition block
  );end lambda
);end define stmt

;;checks pgm rule
;;prints terminals along the way, calling the appropriate function
;;for non-terminals
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
(define pgm
  (lambda ()
    (newline)
    (stmt)
    (cond 
      ((equal? (car (current_token)) "eof")
        (newline)
        (display "Reached end of file. Parse complete... ")
        (newline)
        (display "Parse completed with ")
        (display (get-count))
        (display " error(s).")
        (newline)
        (display "Now exiting program")
        (exit)
        );end of file check
      (else
        (pgm)
      )
    )
  );end lambda
);end define stmt
         

;;checks exp rule
;;prints terminals along the way, calling the appropriate function
;;for non-terminals
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
(define exp
  (lambda ()
    (display "Entering <exp>")
    (newline)
    (term)
    (etail)
    (newline)
    (display "Leaving <exp>")
  );end lambda
);end define exp

;;checks term rule
;;prints terminals along the way, calling the appropriate function
;;for non-terminals
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
(define term
  (lambda ()
    (display "Entering <term>")
    (newline)
    (factor)
    (ttail)
    (newline)
    (display "Leaving <term>")
  );end lambda
);end define term

;;checks assign rule
;;prints terminals along the way, calling the appropriate function
;;for non-terminals
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
(define assign
  (lambda ()
    (newline)
    (display "Entering <assign>")
    (cond
      ((equal? (car (current_token)) "id")
       (newline)
       (id)) 
      (else
       (display "Error: No id found in <assign>")
       (inc-count)
       (newline)
       (display "Leaving <assign>")));end first condition block
    (cond 
       ((equal? (car (current_token)) "=")
         (display "Found ")
         (display (second (current_token)))
         (next_token)
         (newline)
         (exp)
         (newline)
         (display "Leaving <assign>"))
       (else
        (newline)
        (display "Error: No '=' found after the id in <assign>")
        (inc-count)
        (newline)
       );end second else statement
    );end second conditional
  );end lambda
);end define assign


;;checks ttail rule
;;prints terminals along the way, calling the appropriate function
;;for non-terminals
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
(define ttail
  (lambda ()
    (newline)
    (display "Entering <ttail>") 
    (cond
      [(equal? (car (current_token)) "*")
       (newline)
       (display "Found ")
       (display (second (current_token)))];end first equality check in condition
      [(equal? (car (current_token)) "/")
       (newline)
       (display "Found ")
       (display (second (current_token)))];end second equality check in condition
      (else
        (newline)
        (display "Next token is not * or /, choosing EPSILON production")
      );end else statement
    );end condition block
    (while (or (equal? (car (current_token)) "*")
               (equal? (car (current_token)) "/"))
      (next_token)
      (newline)
      (factor))
    (newline)
    (display "Leaving <ttail>")
  );end lambda
);end define factor


;;checks etail rule
;;prints terminals along the way, calling the appropriate function
;;for non-terminals
;;displays message found + lexeme that was encountered
;;in addition, also displays when entering or leaving
;;function (parse trace)
(define etail
  (lambda ()
    (newline)
    (display "Entering <etail>") 
    (cond
      [(equal? (car (current_token)) "+")
       (newline)
       (display "Found ")
       (display (second (current_token)))];end first equality check in condition
      [(equal? (car (current_token)) "-")
       (newline)
       (display "Found ")
       (display (second (current_token)))];end second equality check in condition
      (else
        (newline)
        (display "Next token is not + or -, choosing EPSILON production")
      );end else statement
    );end condition block
    (while (or (equal? (car (current_token)) "+")
               (equal? (car (current_token)) "-"))
      (next_token)
      (newline)
      (term))
    (newline)
    (display "Leaving <etail>")
  );end lambda
);end define factor

;;test function to test whether or not next_token
;;will actually terminate program when it encounters
;;eof
(define tt
  (lambda ()
    (display (current_token))
    (newline)
    (next_token)
    (tt)
    )
  )



;;Counter function for Error checking 
(define (make-counter)
  (let ((count 0))
    (values (lambda ()
              (set! count (+ count 1))
              count)
            (lambda ()
              count))))

;;Supplemental function to the Error counter function to define
;;incrmenting the counter versus retrieving the value
(define-values (inc-count get-count)
  (make-counter))


;;Defines syntax for a iterative while loop
;;http://codeimmersion.i3ci.hampshire.edu/2009/10/15/a-scheme-while-loop/ 
(define-syntax (while stx)
  (syntax-case stx ()
      ((_ condition expression ...)
       #`(do ()
           ((not condition))
           expression
           ...))))
