% Вариант 9
%
% Реализовать разбор фраз языка (вопросов), выделяя в них неизвестный объект
% ..........................................................................
% Запрос:    ?- an_q(["Кто", "любит", "шоколад" "?"], X).
%            ?- an_q(["Где", "лежат", "деньги" "?"], X).
%            ?- an_q(["Что", "любит", "Даша" "?"], X).
% Результат: X='любить'(agent(Y), object('шоколад')),
%            X='лежать'(object('деньги'), loc(X)),
%            X='любить'(agent("Даша"), object(Y)).

entity('Даша').
entity('Ваня').
entity('Саша').
entity('Лена').
entity('Он').
entity('Она').
entity('Они').

object('шоколад').
object('деньги').
object('программу').
object('здесь').

member(X,[X|L]).
member(X,[L|T]) :- member(X,T).

% Определение оператора, используемого в словаре
:-op(200, xfy, ':').

% Поиск словоформы в словаре
find(Word, CanonWord, Type, File):-
  member(X, File),
  condition(Word, CanonWord, Type, X).

condition(W, CW, T, CW:T:L):-
  member(W, L).

% Предикат глагола
verb(CW, T, W):-
  gen(File),
  find(W, CW, T, File).

% Словарь глаголов
gen(File):-
  File=[
  'любить':infinitiv('неинф'):['любит', 'любят','любила', 'любили'],
  'лежать':infinitiv('неинф'):['лежат', 'лежит','лежал', 'лежали'],
  'жить':infinitiv('неинф'):['живет', 'живут','жила', 'жили','жил'],
  'запустить':infinitiv('неинф'):['запускает', 'запускают','запкскала', 'запускали','запкскал']
  ].

% Предикат выделения элемента в списке
getElem([],_,_).
getElem([H|T],T,H).

% Предикаты для анализа предложений с вопросительным словом 'Кто'
find_agent(QW,S):- QW == 'Кто'; entity(S).
find_agent1(QW):- QW == 'Кто'.

% Предикаты для анализа предложений с вопросительным словом 'Что'
find_object(QW,S):- QW == 'Что'; object(S).
find_object1(QW):- QW == 'Что'.

% Предикаты для анализа предложений с вопросительным словом 'Где'
find_loc(QW,S):- QW == 'Где', loc(S).
find_loc1(QW):- QW == 'Где'.
find_loc2(S):-loc(S).

% Предикат разделения вопроса на части
split(Question,QuestionWord,Verb,Something):-
    getElem(Question,Q1,QuestionWord), 
    getElem(Q1,Q2,Verb),
    getElem(Q2,Q3,Something).

% Предикат поиска неизвестного объекта в вопросе
an_q(Q):- 
  split(Q, QW, V, S), 
  verb(IV, infinitiv('неинф'), V), write(IV), 
  (find_agent(QW,S), !,
     write("(agent("), (find_agent1(QW), !, 
      write("Y),");
    write(S),write("),")), (find_loc(QW,S), !, 
      write("loc("),(find_loc1(QW), !, 
        write("Y))");
      write(S),write("))"));
    write("object("),(find_object1(QW), !, 
      write("Y))");
    write(S),write("))")));
  write("(object("),(find_object1(QW), !,
    write("Y),");
  write(S),write("),")), (write("loc("),(find_loc1(QW), !, 
    write("X))");
  write(S),write("))")))).