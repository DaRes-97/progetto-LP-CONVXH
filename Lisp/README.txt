Resmini Daniele Andrea 830446

GRUPPO:
	Moro Davide Riccardo 831110

CONVEX HULL - implementazione in Common Lisp

	-	il programma definisce come variabile globale *p0*, punto di ordinata ed ascissa minore tra la lista
		di punti acquisita. utilizza tale punto come origine del piano cartesiano, per l'ordinamento della lista

	-	una volta settato *p0*, elimina i punti duplicati dalla lista e la ordina secondo il loro angolo con *p0*,
		a parità di angolo sistema prima i punti più vicini a *p0*

	-	cerca poi i punti con lo stesso angolo nella lista e conserva solo quello più lontano da *p0*

	-	costruisce la stack di punti tramite l'algoritmo Graham Scan


--> la lista dei punti è strutturata nel formato ((px1 . py1) (px2 . py2) (px3 . py3) ...)