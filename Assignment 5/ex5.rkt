#lang racket

(provide (all-defined-out))

(define id (lambda (x) x))
(define cons-lzl cons)
(define empty-lzl? empty?)
(define empty-lzl '())
(define head car)
(define tail
  (lambda (lzl)
    ((cdr lzl))))
(define plus$
  (lambda (x y cont)
    (cont (+ x y))))

(define div$
  (lambda (x y cont)
    (cont (/ x y))))

(define integers-from
   (lambda (n)
       (cons-lzl n (lambda () (integers-from (+ n 1))))))

(define take
  (lambda (lz-lst n)
    (if (or (= n 0) (empty-lzl? lz-lst))
      empty-lzl
      (cons (head lz-lst)
                 (take (tail lz-lst) (- n 1))))))




;;; Q1.a
; Signature: compose(f g)
; Type: [T1 -> T2] * [T2 -> T3]  -> [T1->T3]
; Purpose: given two unary functions return their composition, in the same order left to right
; test: ((compose - sqrt) 16) ==> -4
;       ((compose not not) true)==> true
(define compose
  (lambda (f g)
    (lambda (x)
       (g (f x)))))


; Signature: pipe(lst-fun)
; Type: [[T1 -> T2],[T2 -> T3]...[Tn-1 -> Tn]]  -> [T1->Tn]
; Purpose: Returns the composition of a given list of unary functions. For (pipe (list f1 f2 ... fn)), returns the composition fn(....(f1(x)))
; test: ((pipe (list sqrt - - number?)) 16)) ==> true
;       ((pipe (list sqrt - - number? not)) 16) ==> false
;       ((pipe (list sqrt add1 - )) 100) ==> -11
(define pipe
  (lambda (fs)  
    (if (empty? (cdr fs))
        (car fs)
        (compose (car fs) (pipe (cdr fs))))))

(define compose$
  (lambda (f$ g$ cont)
    (cont(lambda(x c)
       (g$ x (lambda(res)
               (f$ res c)))))))


; Signature: pipe$(lst-fun,cont)
;         [T1 * [T2->T3] ] -> T3,
;         [T3 * [T4 -> T5] ] -> T5,
;         ...,
;         [T2n-1 * [T2n * T2n+1]] -> T2n+1
;        ]
;       * 
;       [T2n+1 * [T2n+2 -> T2n+3]] -> T2n+3
;      -> [T1 * [T2n+3 -> T2n+4]] -> T2n+4
; Purpose: Returns the composition of a given list of unry CPS functions. 
(define pipe$
  (lambda (fs cont)
    (if (empty? (cdr fs))
        (cont (car fs))
        (pipe$ (cdr fs) (lambda(res)(compose$ res (car fs) cont)) ))))


;;; Q1.c

; Signature: reduce-prim$(reducer, init, lst, cont)
; Type:[number*number->number]*number*[number*number*....*number]*[number->number] -> [number]
; Purpose: Returns the reduced value of the given list, from left 
;          to right, with cont post-processing
; Pre-condition: reducer is primitive
; test: (reduce-prim$ + 0 '( 8 2 2) (lambda (x) x))==> 12
;      (reduce-prim$ * 1 '(1 2 3 4 5) (lambda (x) x)) ==> 120
;      (reduce-prim$ - 1 '(1 2 3 4 5) (lambda (x) x))==> -14

(define reduce-prim$
	(lambda (reducer init list cont)
		(if (empty? list)
			(cont init)
			(reduce-prim$ reducer init (cdr list)(lambda(res)(cont(reducer res (car list))))))))

; Signature: reduce-user$(reducer, init, lst, cont)
; Type: [T1*T1*[T1*T1->T1]->T2]*T1*[T1*T1*...*T1]*[T2->T3] -> T3
; Purpose: Returns the reduced value of the given list, from left 
;          to right, with cont post-processing
; Pre-condition: reducer is a CPS user prococedure
; test: (reduce-user$ plus$ 0 '(3 8 2 2) (lambda (x) x)) ==> 15
;        (reduce-user$ div$ 100 '(5 4 1) (lambda (x) (* x 2))) ==> -14

(define reduce-user$
  (lambda (reducer init list cont)
		(if (empty? list)
			(cont init)
			(reduce-user$ reducer init (cdr list)(lambda(res)(reducer res (car list) cont))))))

;;; Q2.c.1
; Signature: take1(lz-lst,pred)
; Type: [LzL<T>*[T -> boolean] -> List<T>]
; Purpose: while pred holds return the list elments
; Tests: (take-while (integers-from 0) (lambda (x) (< x 9)))==>'(0 1 2 3 4 5 6 7 8)
;          (take-while(integers-from 0) (lambda (x)  (= x 128))))==>'()
(define take-while
  (lambda (lzl pred)
    (if (or (not(pred(head lzl))) (empty-lzl? lzl))
        empty-lzl
        (cons(head lzl)(take-while(tail lzl) pred)))))
                     

;;; Q2.c.2
; Signature: take-while-lzl(lz-lst,pred)
; Type: [LzL<T>*[T -> boolean] -> Lzl<T>]
; Purpose: while pred holds return list elments as a lazy list
; Tests: (take (take-while-lzl (integers-from 0) (lambda (x) (< x 9))) 10) ==>'(0 1 2 3 4 5 6 7 8)
;           (take-while-lzl(integers-from 0) (lambda (x)  (= x 128))))==>'()
(define take-while-lzl
  (lambda (lzl pred)
    (if (or (not(pred(head lzl))) (empty-lzl? lzl))
        empty-lzl
        (cons(head lzl)(lambda()(take-while-lzl (tail lzl) pred))))))


;;; Q2.d
; Signature: reduce-lzl(reducer, init, lzl)
; Type: [T2*T1 -> T2] * T2 * LzL<T1> -> T2
; Purpose: Returns the reduced value of the given lazy list
(define reduce-lzl 
  (lambda (reducer init lzl)
   (if (empty-lzl? lzl)
       init
       (reduce-lzl reducer (reducer init (head lzl)) (tail lzl)))))



























(define square$
  (lambda (x cont) (cont(* x x))))
(define add1$
  (lambda (x cont) (cont(+ x 1))))
(define div2$
  (lambda (x cont) (cont(/ x 2))))
(define g-0$
  (lambda (n cont)
    (cont (if (> n 0) #t #f))))
(define bool-num$
  (lambda (b cont)
    (cont (if b 1 0))))


