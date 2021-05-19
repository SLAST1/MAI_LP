% Вторая часть задания - реляционное представление предметной области

:- ['four.pl'].

% 1. Получить таблицу групп и средний балл по каждой из групп

% Предикат для нахождения суммы
% Формат ввода: (список сумма)
mysum([], 0).
mysum([X|Y], S) :-
    mysum(Y, N),
    S is N + X.

% Предикат для нахождения среднего значения
% Формат ввода: (список, среднее ар.)
sredn(L, R) :-
    length(L, Len),
    mysum(L, Sum),
    R is Sum / Len.

% Предикат для нахождения всех оценок студента 'Student'
% Формат ввода: (студент, оценка) 
grades(Student, G) :-
    subject(_, X),
    member(grade(Student, G), X).

% Предикат для нахождения среднего ар. всех оценок студента 'Student'
% Формат ввода: (студент, ср. ар)
allgradeaver(Student, Aver) :-
    findall(G, grades(Student, G), List),
    sredn(List, Aver).

% Предикат для нахождения среднего балла студента 'Student' в группе
% Формат ввода: (студент, ср. б. в группе)
allgradeaveringroup(Group, GrAver) :-
    group(Group, StudList),
    member(Stud, StudList),
    allgradeaver(Stud, GrAver).

% Предикат для вывода таблицы групп и среднего балла по каждой из групп
tablesredn() :-
    group(Group,_),
    findall(GrAver, allgradeaveringroup(Group, GrAver), X),
    sredn(X, Ans),
    write('| Группа №'), write(Group), write(' | Cредний бал: '), write(Ans), write('\n'), fail.

% 2. Для каждого предмета получить список студентов, не сдавших экзамен (grade=2)

% Предикат для нахождения имен студентов, не сдавших экзамен 'Exam'
% Формат ввода: (экзамен, фамилия студента) 
failstud(Exam, Surname) :-
    subject(Exam, Students),
    member(grade(Surname, 2), Students).

% Предикат для нахождения списка студентов, не сдавших экзамен 'Exam'
% Формат ввода: (экзамен, список студентов)
failstudlist(Exam, List) :-
    subject(Exam,_),
    findall(Surname, failstud(Exam, Surname), List).
  
% 3. Найти количество не сдавших студентов в каждой из групп

% Предикат для нахождения несдавших студентов в группе
% Формат ввода: (группа, фамилии несдавших студентов)
failstudingroup(Group,Surname) :-
    subject(_,GradesList),
    group(Group,StudsList),
    member(Surname,StudsList),
    member(grade(Surname,2),GradesList).

% Предикат для нахождения кол-ва несдавших студентов в группе
% Формат ввода: (группа, число несдавших)
numberfailstudingroup(Group, Num) :-
    findall(Surname, failstudingroup(Group, Surname), List),
    length(List, Num).