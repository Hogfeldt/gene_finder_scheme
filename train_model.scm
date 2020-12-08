(load "utility.scm")
(load "data/genome1.scm")
(load "data/true-ann1.scm")
(load "data/genome2.scm")
(load "data/true-ann2.scm")
(load "data/genome3.scm")
(load "data/true-ann3.scm")
(load "data/genome4.scm")
(load "data/true-ann4.scm")
(load "data/genome5.scm")
(load "data/true-ann5.scm")

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

(training-by-counting (null-model 7 4) 
                      (foldl append 
                             genome1 
                             (list genome2 genome3 genome4 genome5))
                      (foldl append 
                             true-ann1 
                             (list true-ann2 true-ann3 true-ann4 true-ann5)))
