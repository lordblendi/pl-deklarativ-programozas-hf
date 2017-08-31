# Deklaratív programozás Prolog házi

A feladat egy teljesen kitöltött Sudoku-megoldás _helyességének_ ellenőrzése, azaz annak eldöntése, hogy az adott Sudoku-megoldás egy, a félévi nagy házi feladatban specifikált formájú Sudoku-feladvány által előírt összes megszorítást kielégíti-e.

A Sudoku-feladványt a nagy házi feladatban leírt Prolog-struktúrával adjuk meg.

A Sudoku-megoldás a Sudoku-feladvánnyal azonos méretű, egész számokból álló mátrix, amelyet listák listájaként ábrázolunk.

Egy n=k*k sorból és n oszlopból álló Sudoku-megoldás akkor helyes egy adott Sudoku-feladványra nézve, ha

  - minden sorában, oszlopában, illetve cellájában 1 és n közötti, egymástól különböző értékű mezők vannak,
  - kielégíti az adott Sudoku-feladványt, azaz a benne szereplő ún. segítő információk (infók) által előírt összes feltételt.

A feladvány és a megoldás méretét, illetve az infók formáját nem kell ellenőrizni, feltehető, hogy a feladványnak és a megoldásnak a megadott k cellaméretnek megfelelő számú sora és oszlopa van, és az is, hogy az infókat a specifikációban leírtak szerint adtuk meg.

## Specifikáció

Írjon Prolog-eljárást `helyese/2` néven egy Sudoku-megoldás helyességének a megállapítására.


```prolog
% :- pred helyese(sspec::in, ssol::in).
% helyese(+SSpec,+SSol) : sikeres, ha a teljesen kitöltött SSol Sudoku-megoldás
%   (a) minden sorában, oszlopában, illetve cellájában egymástól különböző
%       értékű, az SSpec által előírt tartományba eső egészek vannak,
%   (b) kielégíti az SSpec specifikációt.
```

## Gyakorló feladatok

A házi feladat megoldásának előkészítésére a következő kisebb gyakorló feladatok megoldását javasoljuk.
  - Annak eldöntése, hogy egy listában vannak-e ismétlődő elemek.
  - Annak eldöntése, hogy egy lista, ill. mátrix minden elemére teljesül-e egy adott predikátum.
  - Annak eldöntése, hogy egy lista, ill. mátrix legalább egy elemére teljesül-e egy adott predikátum.

## Példák

Az Erlang-tesztek között a nem helyes Sudoku-megoldások minden alapesetére mutatunk példát. Természetesen programjának Prolog-változatát is érdemes lefuttatnia ezekre az alapesetekre.

```prolog
|?- helyese(s(2,
            [[[v(2)],   [w],     [],   [w]],
             [    [],   [s],     [],   [o]],

             [    [],    [], [v(1)],    []],
             [    [],    [],     [],    []]]),

            [[2,3, 4,1],
             [4,1, 2,3],

             [3,2, 1,4],
             [1,4, 3,2]]
           ).
yes
|?- helyese(s(2,
            [[[v(2)],   [w],    [s],    []],
             [    [],   [s],     [],   [o]],

             [    [],    [], [v(1)],    []],
             [    [],    [],     [],    []]]),

            [[2,3, 4,1],
             [4,1, 2,3],

             [3,2, 1,4],
             [1,4, 3,2]]
           ).
no
|?- helyese(s(2,
            [[  [e,v(2),s],         [w],           [e],          []],
              [         [],     [e,s,w],            [],         [o]],

              [         [],          [],        [v(1)],          []],
              [         [],          [],            [],          []]]),

            [[2,1, 4,3],
             [3,4, 2,1],

             [4,3, 1,2],
             [1,2, 3,4]]
           ).
yes
|?- helyese(s(3,
            [[    [],[v(2)],[v(3)], [v(4)],[v(1)],    [], [v(5)],[v(8)],    []],
             [    [],[v(7)],[v(8)],     [],    [],    [],     [],[v(2)],[v(1)]],
             [    [],    [],[v(5)], [v(7)],[v(2)],    [],     [],[v(3)],[v(9)]],

             [    [],[v(8)],[v(2)], [v(9)],[v(6)],[v(1)],     [],[v(4)],    []],
             [    [],[v(9)],    [], [v(5)],    [],[v(4)],     [],[v(1)],    []],
             [    [],[v(6)],    [], [v(2)],[v(7)],[v(3)], [v(9)],[v(5)],    []],

             [[v(7)],[v(4)],    [],     [],[v(9)],[v(5)], [v(3)],    [],    []],
             [[v(2)],[v(3)],    [],     [],    [],    [], [v(8)],[v(9)],    []],
             [    [],[v(5)],[v(9)],     [],[v(3)],[v(2)], [v(1)],[v(7)],    []]]),

            [[6,2,3, 4,1,9, 5,8,7],
             [9,7,8, 3,5,6, 4,2,1],
             [4,1,5, 7,2,8, 6,3,9],

             [5,8,2, 9,6,1, 7,4,3],
             [3,9,7, 5,8,4, 2,1,6],
             [1,6,4, 2,7,3, 9,5,8],

             [7,4,1, 8,9,5, 3,6,2],
             [2,3,6, 1,4,7, 8,9,5],
             [8,5,9, 6,3,2, 1,7,4]]
           ).
yes
|?- helyese(s(3,
            [[[v(2)],    [],[v(9)],    [s],    [],   [s],    [s],   [e],    []],
             [    [],   [s],[v(4)],    [w],[v(9)],[v(8)],     [],   [o],   [e]],
             [    [], [e,w],[v(1)],    [w],    [],   [o],     [],   [w], [s,w]],

             [    [],    [],    [],    [w],    [],   [w],     [],   [o],    []],
             [    [],    [],    [],     [],   [w],    [],    [w],   [w],[v(8)]],
             [    [],    [],    [],     [],    [],    [],    [o],   [o],    []],

             [    [],    [],    [], [v(3)],    [],    [], [v(1)],   [e],   [s]],
             [    [],    [],    [], [v(1)],    [],    [], [v(2)],    [],   [e]],
             [    [],    [],    [],    [w],   [w],[v(2)],     [],   [w],    []]]),

            [[2,8,9, 6,1,7, 5,4,3],
             [3,7,4, 5,9,8, 6,1,2],
             [5,6,1, 2,4,3, 9,8,7],

             [7,3,8, 9,2,1, 4,5,6],
             [1,9,5, 7,6,4, 3,2,8],
             [4,2,6, 8,3,5, 7,9,1],

             [8,4,2, 3,7,9, 1,6,5],
             [9,5,7, 1,8,6, 2,3,4],
             [6,1,3, 4,5,2, 8,7,9]]
           ).
yes
```
