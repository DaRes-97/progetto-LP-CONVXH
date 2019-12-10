;;;;    Resmini Daniele Andrea 830446

;;;;    GRUPPO:
;;;;	    Moro Davide Riccardo 831110

;;;;;;;;;;;;VARIABILI;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; definizione variabile *p0*, inizialmente corrispondente all'origine
;;; del piano cartesiano
(defvar *p0* (cons 0 0))

;;;;;;;;;;;;UTILITA';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

;;; ritorna l'ascissa del punto
(defun x (point)
    (car point)
)

;;; ritorna l'ordinata del punto
(defun y (point)
    (if (atom (cdr point))
        (cdr point)
        (cadr point)
    )
)

;;; organizza i punti in una lista di cons
(defun consator (lista)
    (if (null lista)
    nil
    (cons (cons (car lista) (cadr lista)) (consator (cddr lista)))))

;;; controlla se la lista è formata da una coppia di punti
;;; (quindi se è valida)
(defun pairs (lista)
    (cond
        ((null lista)
            T)
        ((or (null (caar lista)) (null (cdr (car lista))))
            nil)
        (T
            (pairs (cdr lista)))
    ))

;;; calcola il quadrato della distanza tra due punti
(defun dist-square (p1 p2)
    (+ (* (- (x p1) (x p2)) (- (x p1) (x p2))) (* (- (y p1) (y p2)) (- (y p1) (y p2)))))

;;; nuovo punto
(defun new-point (x y)
    (if (and (integerp x) (integerp y))
        (cons x y)
        ()))

;;; trova il punto con l'ordinata minore, e parità di ordinata quello con ascissa minore
(defun lowest-point (punti pmin)
    (if (null punti)
        pmin
        (if (or (< (y (car punti)) (y pmin)) (and (= (y (car punti)) (y pmin)) (< (x (car punti)) (x pmin))))
            (lowest-point (cdr punti) (car punti))
            (lowest-point (cdr punti) pmin)
        )
    )
)

;;;;;;;;;;;;GESTIONE FILE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; funzione di supporto alla lettura del file
(defun r-l-f (input-s)
  (let ((e (read input-s nil 'eof)))
    (unless (eq e 'eof)
      (cons e (r-l-f input-s)))))

;;; funzione di lettura del file
(defun read-points (Filename) 
    (with-open-file (in Filename
                    :direction :input
                    :if-does-not-exist :error) 
    (consator (r-l-f in))))

;;;;;;;;;;;;GESTIONE DIREZIONE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;calcola l'area del triangolo compreso tra 3 punti
(defun area2 (p1 p2 p3)
    (let ((xa (x p1))
          (ya (y p1))
          (xb (x p2))
          (yb (y p2))
          (xc (x p3))
          (yc (y p3)))
    (- (* (- xb xa) (- yc ya)) (* (- xc xa) (- yb ya)))))

;;; svolta a sx tra 3 punti
(defun left (p1 p2 p3)
    (if (< 0 (area2 p1 p2 p3))
        T
        nil))

;;;;;;;;;;;;GESTIONE ANGOLO;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; definisce l'angolo di un punto rispetto a *p0*
(defun angle (punto)
    (let (
            (p (cons (- (x punto) (x *p0*)) (- (y punto) (y *p0*))))
         )
            (if (= (y p) 0)
                (cond
                    ((< (x p) 0) pi)
                    ((= (x p) 0) 0)
                    ((> (x p) 0) 0)
                )
                (cond
                    ((= (x p) 0)
                        (/ pi 2))
                    ((< (x p) 0)
                        (+ (/ pi 2) (atan (/ (x p) (- (y p))))))
                    (T
                        (atan (/ (y p) (x p))))
                )
            )
    )
)

;;; confronta l'angolo tra due punti, a parità di angolo scelglie
;;; il punto più vicino a *p0*
(defun angle-compare (p1 p2)
    (cond
        ((< (angle p1) (angle p2))
            T)
        ((= (angle p1) (angle p2))
            (if (not (< (dist-square p1 *p0*) (dist-square p2 *p0*)))
                nil
                T
            ))
        (T 
            nil)
    )
)

;;; ordina i punti per angolo 
(defun sort-points-by-angle (punti)
    (sort punti #'angle-compare)
)

;;; data una lista di punti ordinata per angolo polare,
;;; a parità di angolo polare conserva nella lista quello
;;; più lontano dall' origine ed elimina gli altri
(defun keep-farthest (punti)
    (cond
        ((null punti)
            nil)
        ((= 1 (list-length punti))
            punti)
        ((= (angle (car punti)) (angle (cadr punti)))
            (if (> (dist-square (car punti) *p0*) (dist-square (cadr punti) *p0*))
                (keep-farthest (cons (car punti) (cddr punti)))
                (keep-farthest (cons (cadr punti) (cddr punti)))
            ))
        (T
            (cons (car punti) (keep-farthest (cdr punti))))
    )
)

;;;;;;;;;;;;COSTRUZIONE STACK;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; controlla che non ci siano errori nel file .txt, dopodichè
;;; inizializza la variabile *p0* e la elimina dalla lista dei punti
(defun initialize (punti)
    (if (or (not (pairs punti)) (< (list-length punti) 3))
        (error "errore nel file database"))
    (setf *p0* (lowest-point punti (car punti)))
    (remove *p0* punti)
)

;;; costruisce lo stack di punti della chiglia convessa
;;; utilizzando l'algoritmo Grahan scan
(defun build-stack (punti stack)
    (cond
        ((null punti)
            stack)
        ((and (> (list-length stack) 1) (not (left (second stack) (first stack) (first punti))))
            (build-stack punti (cdr stack)))
        (T
            (build-stack (cdr punti) (cons (car punti) stack)))
    )
)

;;; FUNZIONE PRINCIPALE
(defun convexh (punti)
    (let* ( (a (remove-duplicates punti))
            (b (initialize a))
            (c (sort-points-by-angle b))
            (d (keep-farthest c))
            (e (build-stack d (list *p0*)))
          )
        e
    )
)
