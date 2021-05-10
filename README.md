# progetto LP-CONVXH

Implementazione in Prolog e in Lisp di un [convex hull](https://en.wikipedia.org/wiki/Convex_hull) (inviluppo convesso) dato un insieme di punti del piano cartesiano in ingresso, utilizzando l'algoritmo [Graham's scan](https://en.wikipedia.org/wiki/Graham_scan)


# LISP

Per l'implementazione in **Lisp** l'input è un insieme di punti sottoforma di lista del tipo:
<code>(convexh '((px1 py1) (px2 py2) (px3 py3) ...))</code> 

un esempio di input:
<code>(convexh '((5 1) (8 15) (7 34) (1 1) (8 88)))</code>

che viene valutato nel modo seguente:
<code>((8 88) (8 15) (5 1) (1 1))</code>

## PROLOG

La parte in **Prolog** prende in input un insieme di punti inseriti in un file con formattazione del tipo:
px1 (/tab) py1
px2 (/tab) py2
px3 (/tab) py3
...

un esempio di file 'points.txt'
2 5
1 7
80 15
55 14
-1 4

comando di input:
<code>read_points('points.txt',P),convexh(P,C).</code>

con valutazione:
<code>P = [point(2, 5), point(1, 7), point(80, 15), point(55, 14), point(-1, 4)],</code>
<code>C = [point(1, 7), point(55, 14), point(80, 15), point(-1, 4)].</code>
