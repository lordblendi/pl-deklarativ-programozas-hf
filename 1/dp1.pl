%visszaadja egy lista elso elemet
%lista_elso_eleme(+[H|_T],-H)
lista_elso_eleme([H|_T],H).

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

%megforditja a lista elemeinek sorrendjet
%megfordit(+In,-Out)
megfordit(In,Out):-
	megfordit_help(In,Out,[]).

%A megforditasban segit, van egy pusz Accumulatora
%megfordit_help(+[H|T],-Out,+Acc)
megfordit_help([H],Out,Acc):-
	!,append([H],Acc,Out).
megfordit_help([H|T],Out,Acc):-
	append([H],Acc,Acc1),
	megfordit_help(T,Out,Acc1).


%Visszaadja a megadott sorszamok kozotti oszlopokat egy listaba fuzve oket
%oszlop(+[H|T],+Elso,+Utolso,-R,+Acc)
oszlop([H],Elso,Utolso,R,Acc):-
	!,lista_felbont(H,Elso,Utolso,R1), append(Acc,R1,R).
oszlop([H|T],Elso,Utolso,R,Acc):-
	lista_felbont(H,Elso,Utolso,R1), append(Acc,R1,Acc1),
	oszlop(T,Elso,Utolso,R,Acc1).

%visszaadja bizonyos lepeskozzel a megadott sorokat.
%hol mondja meg, hogy hol tartok a listazas kozben
%sor(+L, +Lepeskoz, +Hol, -R, +Acc)
sor(L, Lepeskoz, Hol, R, Acc):-
	length(L,Hossz), Hol>=Hossz, !,megfordit(Acc,R);
	Vege is Hol + Lepeskoz,
	lista_felbont(L,Hol, Vege, R1), Acc1 = [R1|Acc],
	sor(L,Lepeskoz,Vege, R, Acc1).

%visszaadja bizonzos lepeskozzel a megadott oszlopokat.
%hol mondja meg, hogy hol tartok a listazas kozben
%oszlop_listazas(+L,+Lepeskoz,+Hol,-R,+Acc)
oszlop_listazas(L,Lepeskoz,Hol,R,Acc):-
	lista_elso_eleme(L,H), length(H, Hossz), Hol>= Hossz, !,megfordit(Acc,R);
	Vege is Hol + Lepeskoz,
	oszlop(L,Hol,Vege,R1,[]), Acc1 = [R1|Acc],
	oszlop_listazas(L,Lepeskoz,Vege,R,Acc1).

%matrix felbontasara szolgal,
%meghivja a megfelelo parameterekkel a sorok es oszlopok listazasat
%matrix(+L, +C,+R, -Ret)
matrix(L, C,R, Ret):-
	sor(L,R,0,L0,[]),
	matrix_help(L0, C, Ret,[]).

%arra szolgal, hogy a sorok felbontasa utan tobb lista lesz a listankban, es ezeket kapja meg
%az oszlopokat felbonto fgv-em
%matrix_help(+[H|T],+C,-R,+Acc)
matrix_help([H],C,R,Acc):-
	!,oszlop_listazas(H, C, 0, Ret,[]),  append(Acc,Ret,R).
matrix_help([H|T],C,R,Acc):-
	oszlop_listazas(H, C, 0, Ret,[]), append(Acc,Ret,Acc1),
	matrix_help(T,C,R,Acc1).

% :- type matrix == list(row).
% :- type row == list(any).
% :- type parameter ---> subRows-subCols.
% :- type subRows == int.
% :- type subCols == int.
% :- pred feldarabolasa(+matrix, +parameter, ?list(list(any))).
% feldarabolasa(Mx, P, LL): Az LL lista az Mx mátrix P paraméterû feldarabolása.
feldarabolasa(Mx, P, LL):-
	R-C = P,
	matrix(Mx, C,R,LL).
