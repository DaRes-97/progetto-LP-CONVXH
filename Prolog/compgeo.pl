%   Resmini Daniele Andrea 830446

%   GRUPPO:
%	    Moro Davide Riccardo 831110

%%%%%%%%%%%%%%%%%%% VARIABILI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   definizione variabile p0, inizialmente corrispondente all'origine
%   del piano cartesiano
:- dynamic
    p0/2.

p0(0,0).

%%%%%%%%%%%%%%%%%%% UTILITA' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   calcola il quadrato della distanza tra 2 punti
dist_square(P1, P2, R) :-
    P1 = point(X1, Y1),
    P2 = point(X2, Y2),
    X is (X2-X1)*(X2-X1),
    Y is (Y2-Y1)*(Y2-Y1),
    R is X + Y.

% trova il punto con l'ordinata minore, e parita di ordinata quello con
% ascissa minore
lowest_point([In | Ins], Out) :-
	low(Ins, In, Out).

low([], Temp, Temp) :- !.

low([In | Ins], Temp, Out) :-
		Temp = point(_, Yt),
		In = point(_, Y),
		Y < Yt,
		!,
		low(Ins, In, Out).

low([In | Ins], Temp, Out) :-
		Temp = point(Xt, Yt),
		In = point(X, Y),
		Y = Yt,
		X < Xt,
		!,
		low(Ins, In, Out).

low([In | Ins], Temp, Out) :-
		Temp = point(Xt, Yt),
		In = point(X, Y),
		Y = Yt,
		X > Xt,
		!,
		low(Ins, Temp, Out).

low([In | Ins], Temp, Out) :-
		Temp = point(Xt, Yt),
		In = point(X, Y),
		Y = Yt,
		X = Xt,
		!,
		low(Ins, Temp, Out).

low([In | Ins], Temp, Out) :-
		Temp = point(_, Yt),
		In = point(_, Y),
		Y > Yt,
		!,
		low(Ins, Temp, Out).

%%%%%%%%%%%%%%%%%%% GESTIONE FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   funzione di lettura del file
read_points(Filename, Points) :-
    csv_read_file(Filename, R, [separator(0'\t), convert(true)]),
    rows_to_points(R, Points).

%   funzione di supporto alla lettura del file
rows_to_points([], []).
rows_to_points([row(X, Y) | Rs], [P | Ps]) :-
    integer(X),
    integer(Y),
    P = point(X, Y),
    rows_to_points(Rs, Ps).

%%%%%%%%%%%%%%%%%%% GESTIONE DIREZIONE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   calcola l'area del triangolo compreso tra 3 punti
area2(A, B, C, Area) :-
    A = point(X1, Y1),
    B = point(X2, Y2),
    C = point(X3, Y3),
    D is ((X2-X1)*(Y3-Y1)),
    E is ((X3-X1)*(Y2-Y1)),
    Area is D - E.

% svolta a sx tra 3 punti
left(A, B, C) :-
    area2(A, B, C, Area),
    Area > 0.

%%%%%%%%%%%%%%%%%%% GESTIONE ANGOLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

angle2d(A, B, R) :-
    A = point(_, _),
    B = point(_, _),
    angle(A,A1),
    angle(B,A2),
    R is A2 - A1.

% definisce l'angolo di un punto rispetto a p0(X,Y)
angle(P1, Out) :-
    P1 = point(Xt,Yt),
    p0(X0,Y0),
    X is Xt - X0,
    Y is Yt - Y0,
    Y = 0,
    X < 0,
    !,
    Out is pi.

angle(P1, Out) :-
    P1 = point(Xt,Yt),
    p0(X0,Y0),
    X is Xt - X0,
    Y is Yt - Y0,
    Y = 0,
    X > 0,
    !,
    Out is 0.

angle(P1, Out) :-
    P1 = point(Xt,Yt),
    p0(X0,Y0),
    X is Xt - X0,
    Y is Yt - Y0,
    Y = 0,
    X = 0,
    !,
    Out is 0.

angle(P1, Out) :-
    P1 = point(Xt,Yt),
    p0(X0,Y0),
    X is Xt - X0,
    Y is Yt - Y0,
    Y \= 0,
    X = 0,
    !,
    Out is pi / 2.

angle(P1, Out) :-
    P1 = point(Xt,Yt),
    p0(X0,Y0),
    X is Xt - X0,
    Y is Yt - Y0,
    Y \= 0,
    X < 0,
    !,
    M = (0 - X) / Y,
    Out is (pi / 2 + atan(M)).

angle(P1, Out) :-
    P1 = point(Xt,Yt),
    p0(X0,Y0),
    X is Xt - X0,
    Y is Yt - Y0,
    Y \= 0,
    X > 0,
    !,
    M = Y / X,
    Out is atan(M).

% confronta l'angolo tra due punti, a parita  di angolo scelglie
% il punto piu vicino a p0(X,Y)
angle_compare(>, A, B) :-
    A = point(_, _),
    B = point(_, _),
    angle(A, A1),
    angle(B, A2),
    A1 > A2,
    !.

angle_compare(>, A, B) :-
    A = point(_, _),
    B = point(_, _),
    angle(A, A1),
    angle(B, A2),
    A1 = A2,
    p0(X,Y),
    dist_square(A, point(X,Y), D1),
    dist_square(B, point(X,Y), D2),
    D1 > D2,
    !.

angle_compare(=, A,B) :-
    A = point(_, _),
    B = point(_, _),
    angle(A, A1),
    angle(B, A2),
    A1 = A2,
    p0(X,Y),
    dist_square(A, p0(X,Y),D1),
    dist_square(B, p0(X,Y),D2),
    D1 = D2,
    !.

angle_compare(<, A, B) :-
    A = point(_, _),
    B = point(_, _),
    angle(A,A1),
    angle(B, A2),
    A1 < A2,
    !.

angle_compare(<, A, B) :-
    A = point(_, _),
    B = point(_, _),
    angle(A,A1),
    angle(B,A2),
    A1 = A2,
    p0(X,Y),
    dist_square(A, point(X,Y),D1),
    dist_square(B, point(X,Y),D2),
    D1 < D2,
    !.

% ordina i punti per angolo
sort_points_by_angle(In, Out) :-
    predsort(angle_compare, In, Out).

% data una lista di punti ordinata per angolo polare,
% a parita  di angolo polare conserva nella lista quello
% piu lontano dall' origine ed elimina gli altri
keep_farthest([],[]) :- !.

keep_farthest([A , B | Rest], Out) :-
	angle2d(A, B, R),
	R = 0.0,
        p0(X,Y),
	dist_square(A, point(X,Y), DA),
	dist_square(B, point(X,Y), DB),
	DA < DB,
        !,
	keep_farthest([B | Rest], Out).

keep_farthest([A | Rest], [A | Out]) :-
	keep_farthest(Rest, Out).

%%%%%%%%%%%%%%%%%%% COSTRUZIONE STACK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% controlla che non ci siano errori nel file .txt, dopodichè
% inizializza la variabile p0(X,Y) e la elimina dalla lista dei punti
initialize(In,Out) :-
    length(In,Len),
    Len > 2,
    !,
    retractall(p0(_,_)),
    lowest_point(In, L),
    L = point(X,Y),
    T =..[p0,X,Y],
    asserta(T),
    delete(In,L,Out).

initialize(_,_) :-
    write("errore nel file database"),
    false.


% costruisce lo stack di punti della chiglia convessa
% utilizzando l'algoritmo Grahan scan
build_stack([],[],[]) :- !.

build_stack([], [S | Ss], [S | Out]) :-
    !,
    build_stack([], Ss, Out).

build_stack([P | Ps], [S1, S2 | Ss], Out) :-
    length([S1, S2 | Ss], Ls),
    Ls > 1,
    not(left(S2, S1, P)),
    !,
    build_stack([P | Ps], [S2 | Ss], Out).

build_stack([P | Ps], Ss, Out) :-
    !,
    build_stack(Ps, [P | Ss], Out).

%   FUNZIONE PRINCIPALE
convexh(In, Out) :-
        initialize(In, A),
        sort(A, B),
        sort_points_by_angle(B,C),
        keep_farthest(C,D),
        p0(X,Y),
        build_stack(D,[point(X,Y)],Out),
        retractall(p0(_,_)),
        New =.. [p0,0,0],
        asserta(New).

