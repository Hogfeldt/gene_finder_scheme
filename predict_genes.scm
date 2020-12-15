(load "../scheme/stdlib.scm")
(load "utility.scm")
(load "model.scm")
(load "data/genome6.scm")
(load "data/genome7.scm")
(load "data/genome8.scm")
(load "data/genome9.scm")
(load "data/genome10.scm")

(define (vlog lst)
  (map 
    (lambda (x) (if (= 0.0 x) 
                  x
                  (log 2 x)))
    lst))

(define (scalar-add-lst a lst)
  (map  (curry + a) lst))

(define (scalar-add-mat a mat)
  (map  (curry scalar-add-lst a) mat))

(define (vmax lst)
  (fold
    (lambda (old new) (if (> old new) old new))
    (car lst)
    (cdr lst)))

(define (seq n)
  (if (zero? n)
    '()
    (cons n (seq (- n 1)))))

(define (argmax lst)
  (fold
    (lambda (old new) (if (> (nth 1 old) (nth 1 new)) old new))
    (list
      0
      (car lst))
    (zip 
      (reverse (seq (length lst)))
      (cdr lst))))

(define (compute-omega model omega xs) 
  (if (null? xs)
    omega
    (compute-omega 
      model
      (cons 
        (vsum
          (vlog (nth-col (car xs) (get-emmis model)))
          (map vmax (map (curry vsum (car omega)) (transpose (map vlog (get-trans model))))))
        omega)
      (cdr xs))))

(define (omega model xs)
  (compute-omega 
    model 
    (cons 
      (vsum 
        (vlog (get-init model)) 
        (vlog (nth-col (car xs) (get-emmis model))))
      '())
    (cdr xs)))


(define (compute-backtrack model omega xs zs)
  (if (null? omega)
    zs
    (compute-backtrack
      model
      (cdr omega)
      (cdr xs)
      (cons 
        (car (argmax 
               (scalar-add-lst
                 (log 
                   2 
                   (nth (car zs) (nth (car xs) (get-emmis model))))
                 (vsum 
                   (car omega)
                   (vlog (nth-col (car zs) (get-trans model)))))))
        zs))))

(define (backtrack model omega xs)
  (compute-backtrack 
    model 
    (cdr omega) 
    xs 
    (list (car (argmax (car omega))))))


(define omega6 (omega model genome6))
(define pred6 (backtrack model omega6 genome6))
(define omega7 (omega model genome7))
(define pred7 (backtrack model omega7 genome7))
(define omega8 (omega model genome8))
(define pred8 (backtrack model omega8 genome8))
(define omega9 (omega model genome9))
(define pred9 (backtrack model omega9 genome9))
(define omega10 (omega model genome10))
(define pred10 (backtrack model omega10 genome10))

(list 
  pred6
  pred7
  pred8
  pred9
  pred10)
