:- use_module(library(lists)).

%subelem(+A, +Lbe, -Lki) kivonja az A elemet az Lbe-bõl, és visszaadja az Lki-ben
subelem(_, [], []).
subelem(A, [A|L], L).
subelem(A, [B|L1], [B|L2]) :- \+ A = B, subelem(A, L1, L2).

%kivonas(+L1, +L2, -L3) kivonja az L1 elemeit L2-bõl, és visszaadja L3-ban
kivonas([], L, L).
kivonas([A|L1], L2, L4) :- subelem(A, L2, L3), kivonas(L1, L3, L4).



%megengedett(+K,-L) L listában visszaadja a megengedett számokat (1-k*k-ig felsorolva)
megengedett(K,L):-
	Limit is K*K, megengedett_seged(Limit,1,[],L).

%megengedett_seged(+Limit,+I, +Acc, -L) segédfgv, L listában visszaadja a megengedett számokat (1-k*k-ig felsorolva)
megengedett_seged(Limit,Limit, Acc, L):-
	!,megfordit([Limit|Acc],L).
megengedett_seged(Limit, I, Acc, L):-
	I1 is I+1,	megengedett_seged(Limit, I1 , [I|Acc], L).

%megengedett_kettesevel(+K,+Kezdo, -L) L listában visszaadja a megengedett számokat (csak a párosakat, vagy csak a páratlanokat, a kezdõértéktõl függõen)
megengedett_kettesevel(K,Kezdo, L):-
	Limit is K*K, kettesevel(Limit, Kezdo, [], L).

%kettesevel(+Limit,+Kezdo, +Acc, -L) segédfgv, L listában visszaadja a megengedett számokat (csak a párosakat, vagy csak a páratlanokat, a kezdõértéktõl függõen)
kettesevel(Limit,Kezdo, Acc, L):-
	Kezdo>Limit,!, megfordit(Acc,L).
kettesevel(Limit, Kezdo, Acc, L):-
	Kezdo1 is Kezdo+2,	kettesevel(Limit, Kezdo1 , [Kezdo|Acc], L).



%mezo(+Mx, +R, +C, -Mezo) kivágja a Mxból a megadott sor (R), és a megadott oszlop(C) találkozásában lévõ mezõt
mezo(Mx, R, C, Mezo):-
	Sorelso is R-1, lista_felbont(Mx, Sorelso, R, Sor),
	Oszlopelso is C-1, oszlop(Sor, Oszlopelso, C, [Mezo|_T],[]).

%value(+L, +Meret, -Ki) megnézi, hogy az adott mezõben milyen értékek szerepelhetnek
%ha van benne v(x), akkor visszaadja az x-et, ha e, akkor egy páros számokból álló listát, o esetén egy páratlan számokból álló listát, különben 1-meret*meret-ig a számokat
value(L, Meret, Ki):-
	member(e, L), member(o, L), !, Ki=[];
	member(v(X), L), member(e, L), !,
	(
		Maradek is X rem 2, Maradek==0, Ki=[X];
		Ki=[]
	);
	member(v(X), L), member(o, L), !,
	(
		Maradek is X rem 2, Maradek==1, Ki=[X];
		Ki=[]
	);
	member(v(X), L),!, Ki=[X];
	member(e, L), !,megengedett_kettesevel(Meret, 2, Ki);
	member(o, L), !, megengedett_kettesevel(Meret, 1, Ki);
	!,megengedett(Meret, Ki).



%sorertekek(+Mx, +R, +C, -Ertekek) visszaadja a megadott sorban szereplõ v(x)-ek értékeit egy listában (x-eket felsorolja)
%a kiválasztott mezõt elõtte kivonjuk a sorból, azt nem vesszük figyelembe
sorertekek(Mx, R, C, Ertekek):-
	nth1(R, Mx, Sor),
	mezo(Mx, R, C, Mezo),
	kivonas([Mezo], Sor, Maradek),
	szomszedertekek(Maradek, [], Ertekek).

%cellaertekek(+Mx, +R, +C, -Ertekek) visszaadja a megadott cellában szereplõ v(x)-ek értékeit egy listában (x-eket felsorolja)
%a kiválasztott mezõt elõtte kivonjuk a cellából, azt nem vesszük figyelembe
cellaertekek(Mx, Meret, R, C, Ertekek):-
	cella(Mx, Meret, R, C, Cella),
	mezo(Mx, R, C, Mezo),
	kivonas([Mezo], Cella, Maradek),
	szomszedertekek(Maradek, [], Ertekek).

%oszlopertekek(+Mx, +R, +C, -Ertekek) visszaadja a megadott oszlopban szereplõ v(x)-ek értékeit egy listában (x-eket felsorolja)
%a kiválasztott mezõt elõtte kivonjuk a oszlopból, azt nem vesszük figyelembe
oszlopertekek(Mx, R, C, Ertekek):-
	Oszlopelso is C-1, oszlop(Mx, Oszlopelso, C, Oszlop, []),
	mezo(Mx, R, C, Mezo),
	kivonas([Mezo], Oszlop, Maradek),
	szomszedertekek(Maradek, [], Ertekek).

%szomszedertekek(+L, +Acc, -Ki) végigmegy a megkapott mezõ szomszédain (pl az adott sort, amibõl kiválasztottuk a mezõnket, de a mezõ nélkül), és kigyûjti egy listába a benne szereplõ v(x)-ek értékét
szomszedertekek([], Acc, Acc).
szomszedertekek([H|T], Acc, Ki):-
	member(v(X), H), szomszedertekek(T, [X| Acc], Ki);
	szomszedertekek(T, Acc, Ki).



%cella(+Mx,+Meret, +R, +C, -Cella) kiválasztja, hogy az adott mezõnk a sudoku melyik cellájában van.
%cella: kxk méretû négyzet, amibõl k darab van egy sorban és egy oszlopban
cella(Mx,Meret, R, C, Cella):-
	szamertek(C, Meret, Meret, Oszlop),
	szamertek(R, Meret, Meret, Sor),
	Sorelso is Sor-Meret, lista_felbont(Mx, Sorelso, Sor, KivagottSorok),
	Oszlopelso is Oszlop-Meret, oszlop(KivagottSorok, Oszlopelso, Oszlop, Cella, []).


%szamertek(+Szam,+Meret,+Ujmeret, -Ki) Kiszámolja, hogy a megadott szám melyik intervallumba esik. egy cella szélessége=magassága számít jelenleg egy intervallumnak
szamertek(Szam,Meret,Ujmeret, Ki):-
	Szam > Ujmeret,Uj is Meret + Ujmeret,
	szamertek(Szam, Meret, Uj, Ki);
	Ki = Ujmeret.


%lista_elso_eleme(+[H|_T],-H) visszaadja egy lista elso elemet
lista_elso_eleme([H|_T],H).

%megfordit(+In,-Out) megforditja a lista elemeinek sorrendjet
megfordit([],[]).
megfordit(In,Out):-
	megfordit_help(In,Out,[]).

%A megforditasban segit, van egy pusz Accumulatora
%megfordit_help(+[H|T],-Out,+Acc)
megfordit_help([H],Out,Acc):-
	!,append([H],Acc,Out).
megfordit_help([H|T],Out,Acc):-
	append([H],Acc,Acc1),
	megfordit_help(T,Out,Acc1).



%Egy adott lista megadott elemeit adja vissza
%Elso az elso elem, ami benne van a listaban
%Utolso az elso elem, ami mar nincs benne a listaban
%ha az intervallum nagyobb, mint a lista, akkor visszaadja a listat
%ha az intervallum tullog a listan, akkor visszaadja a lista veget
%egyebkent kivagja a kozepso reszt a listabol, es azt adja vissza
%lista_felbont(+L,+Elso,+Utolso,-L3)
lista_felbont(L,0,Utolso,L3) :-
	length(L,Hossz), Hossz=<Utolso,!, L3 =L.
lista_felbont(L,Elso,Utolso,L3) :-
	length(L,Hossz2), Hossz2=<Utolso, !,append(L0, L5, L), length(L0,Elso), L3=L5;
	append(L1, L2, L), length(L1,Elso),
	append(L3,_L4,L2), H2 is Utolso-Elso, length(L3,H2).

%oszlop(+[H|T],+Elso,+Utolso,-R,+Acc) Visszaadja a megadott sorszamok kozotti oszlopokat egy listaba fuzve oket
oszlop([H],Elso,Utolso,R,Acc):-
	!,lista_felbont(H,Elso,Utolso,R1), append(Acc,R1,R).
oszlop([H|T],Elso,Utolso,R,Acc):-
	lista_felbont(H,Elso,Utolso,R1), append(Acc,R1,Acc1),
	oszlop(T,Elso,Utolso,R,Acc1).


% :- type col  == int.
% :- type row  == int.
% :- type coords -->row-col.
% :- pred ertekek(sspec::in, coords::in, list(int)::out).
% ertekek(SSpec, R_C, Vals), ahol
%   SSpec az sspec típusspecifikációnak megfelelõ Sudoku-tábla.
%   R_C az adott tábla egy mezõjének (sor-oszlop formában megadott) koordinátája.
%   Vals list(int) típusú mezõértéklista, az SSpec tábla R_C koordinátájú
%   mezõjében megengedett értékek listája. Egy érték pontosan akkor szerepel
%   a Vals listában, ha:
%    (a) 1..k*k közötti egész, ahol k az SSpec tábla cellamérete,
%    (b) teljesíti az adott mezõre vonatkozó szám- és paritási infók
%        által elõírt megszorításokat, továbbá
%    (c) különbözik az adott mezõt tartalmazó sor, oszlop és cella többi
%        mezõjében szereplõ száminfóktól.
ertekek(s(Meret, Mx), R-C, Vals):-
	mezo(Mx, R, C, Mezo), value(Mezo, Meret, Ertek),
	cellaertekek(Mx, Meret, R, C, Cella),
	kivonas(Cella, Ertek, Ertek2),
	oszlopertekek(Mx, R, C, Oszlop),
	kivonas(Oszlop, Ertek2, Ertek3),
	sorertekek(Mx, R, C, Sor),
	kivonas(Sor, Ertek3, Vals), !.
