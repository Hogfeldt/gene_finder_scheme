(load "../scheme/stdlib.scm")
(load "utility.scm")
(load "model.scm")
(load "data/genome6.scm")

(define (vlog lst)
  (map 
    (lambda (x) (if (= 0.0 x) 
                  x
                  (log 2 x)))
    lst))

(define (vmax lst)
  (fold
    (lambda (old new) (if (> old new) old new))
    (car lst)
    (cdr lst)))


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

(define omega 
  (compute-omega 
    model 
    (cons 
      (vsum 
        (vlog (get-init model)) 
        (vlog (nth-col (car genome6) (get-emmis model))))
      '())
    (cdr genome6)))

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

(argmax (car omega))
