(load "stdlib.scm")

(define (cons-n-times x lst n) 
  (if (zero? n) 
    lst 
    (cons-n-times x (cons x lst) (- n 1))))

(define (zeros n m)
  (cons-n-times 
    (cons-n-times 0 '() m) 
    '() 
    n))

(define (null-model K D)
  (list 
    (car (zeros 1 K))
    (zeros K K)
    (zeros K D)))

(define (lst-add n i lst)
  (if (zero? i)
    (cons 
      (+ n (car lst)) 
      (cdr lst))
    (cons 
      (car lst) 
      (lst-add n (- i 1) (cdr lst)))))
(define (lst-inc i lst) 
  (lst-add 1 i lst))

(define (matrix-add n i j mat)
  (if (zero? i)
    (cons 
      (lst-add n j (car mat)) 
      (cdr mat))
    (cons 
      (car mat) 
      (matrix-add n (- i 1) j (cdr mat)))))
(define (matrix-inc i j mat) 
  (matrix-add 1 i j mat))

(define (nth n lst)
  (if (zero? n)
    (car lst)
    (nth (- n 1) (cdr lst))))

(define get-init    car)
(define get-trans   (curry nth 1))
(define get-emmis   (curry nth 2))

(define (matrix-inc-pair mat pair)
  (matrix-inc (nth 1 pair) (car pair) mat))

(define (sum-axis-1 mat)
  (map (curry apply +) mat))

(define (sum-axis-0 mat)
  (foldl 
    (lambda (a b) (map (curry apply +) (zip a b)))
    (car mat)
    (cdr mat)))

(define (normalize mat)
  (map 
    (lambda (pair) (if (zero? (nth 1 pair))
                     (car pair)
                     (map (curry (flip /) (nth 1 pair)) (car pair)))) 
    (zip mat (sum-axis-1 mat))))

(define (training-by-counting model x z)
  (list
    (lst-inc (car z) (get-init model))
    (normalize (foldl
      matrix-inc-pair
      (get-trans model)
      (zip z (cdr z))))
    (normalize (foldl 
      matrix-inc-pair
      (get-emmis model)
      (zip x z)))))

(define mat '((1 2 3) (4 5 6)))
(zip mat (sum-axis-1 mat))
(normalize '((1 2 3) (4 5 6)))

(load "data/genome1.scm")
(load "data/true-ann1.scm")
(training-by-counting (null-model 7 4) genome1 true-ann1)
