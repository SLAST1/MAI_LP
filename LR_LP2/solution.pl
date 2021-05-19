% Вариант 19
% Условие:
% Кондратьев, Давыдов и Федоров живут на нашей улице. 
% Один из них столяр, другой маляр, третий водопроводчик. 
% Недавно маляр хотел попросить своего знакомого столяра сделать кое-что для своей квартиры, 
% но ему сказали, что столяр работает в доме водопроводчика. 
% Известно также, что Федоров никогда не слышал о Давыдове. 
% Кто чем занимается?

% Предикат удаления элементов из списка
remove(E,[E|S],S).
remove(E,[E1|S],[E1|X]) :- remove(E,S,X).

% Предикат перестановки элементов списка
permute([],[]).
permute(L,[X|T]):-remove(X,L,R), permute(R,T).


% Предикаты логического нет
logicalnot(true,false).
logicalnot(false,true).


% Факт: маляр знаком со столяром
data(_,znakomi,[malyar,stolyar],true).
data(_,znakomi,[stolyar,malyar],true).

% Факт: столяр знаком с водопроводчиком
data(_,znakomi,[stolyar,vodoprovodchik],true).
data(_,znakomi,[vodoprovodchik, stolyar],true).

% Факт: маляр слышал про водопроводчика
data(_,znakomi,[malyar,vodoprovodchik],true).

% Факт: Федоров не слышал о Давыдове
data([_,D,F],znakomi,[F,D],false).


% Предикат наличия противоречия
contradiction(V):- 
    data(V,F,A,TF), 
    logicalnot(TF,FT), 
    data(V,F,A,FT).


% Предикат решения
solve(K,D,F) :- 
    permute([K,D,F],[stolyar,malyar,vodoprovodchik]), 
    not(contradiction([K,D,F])).

% Предикат вывода ответа
answer():- 
    solve(K,D,F),
    write('Kondratev - '), write(K), nl,
    write('Davidov - '), write(D), nl,
    write('Fedorov - '), write(F),
    fail.




