Resmini Daniele Andrea 830446

GRUPPO:
	Moro Davide Riccardo 831110

CONVEX HULL - implementazione in swi-Prolog

	-	il programma asserta come predicato p0(X,Y), punto di ordinata ed ascissa minore tra la lista
		di punti acquisita. utilizza tale punto come origine del piano cartesiano, per l'ordinamento della lista

	-	una volta settato p0(X,Y), elimina i punti duplicati dalla lista e la ordina secondo il loro angolo con p0(X,Y),
		a parità di angolo sistema prima i punti più vicini a p0(X,Y)

	-	cerca poi i punti con lo stesso angolo nella lista e conserva solo quello più lontano da p0(X,Y)

	-	costruisce la stack di punti tramite l'algoritmo Graham Scan