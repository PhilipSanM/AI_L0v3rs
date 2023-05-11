% GAME OF THRONES FAMILY TREE.

% Progeny
%progeny(son, father).

progeny(eddardStark, rickardStark).
progeny(eddardStark, lyarraStark).
progeny(brandonStark, rickardStark).
progeny(brandonStark, lyarraStark).
progeny(benjenStark, rickardStark).
progeny(benjenStark, lyarraStark).
progeny(lyannaStark, rickardStark).
progeny(lyannaStark, lyarraStark).

progeny(robbStark, eddardStark).
progeny(robbStark, catelynStark).
progeny(sansaStark, eddardStark).
progeny(sansaStark, catelynStark).
progeny(aryaStark, eddardStark).
progeny(aryaStark, catelynStark).
progeny(branStark, eddardStark).
progeny(branStark, catelynStark).
progeny(rickonStark, eddardStark).
progeny(rickonStark, catelynStark).

progeny(rhaegerTargaryen, aerysTargaryen).
progeny(rhaegerTargaryen, rhaellaTargaryen).
progeny(eliaMartellTargaryen, aerysTargaryen).
progeny(eliaMartellTargaryen, rhaellaTargaryen).
progeny(viserysTargaryen, aerysTargaryen).
progeny(viserysTargaryen, rhaellaTargaryen).
progeny(daenerysTargaryen, aerysTargaryen).
progeny(daenerysTargaryen, rhaellaTargaryen).

progeny(rhaenysTargaryen, rhaegerTargaryen).
progeny(rhaenysTargaryen, eliaMartellTargaryen).
progeny(aegonTargaryen, rhaegerTargaryen).
progeny(aegonTargaryen, eliaMartellTargaryen).

%marriage.
marriage(rickardStark,lyarraStark).
marriage(eddardStark,catelynStark).
marriage(aerysTargaryen,rhaellaTargaryen).
marriage(rhaegerTargaryen,eliaMartellTargaryen).


% Atributtes
man(rickardStark).
man(eddardStark).
man(brandonStark).
man(benjenStark).
man(robbStark).
man(branStark).
man(rickonStark).
man(jonSnow).
man(aerysTargaryen).
man(rhaegerTargaryen).
man(viserysTargaryen).
man(aegonTargaryen).

woman(lyarraStark).
woman(lyannaStark).
woman(catelynStark).
woman(sansaStark).
woman(aryaStark).
woman(rhaellaTargaryen).
woman(eliaMartellTargaryen).
woman(daenerysTargaryen).
woman(rhaenysTargaryen).

% Rules
%grandfather(grandson,grand---).
grandfather(X,Y):-progeny(X,Z),progeny(Z,Y),man(Y).   
grandmother(X,Y):-progeny(X,Z),progeny(Z,Y),woman(Y).

%brother(sister, brother).
brother(X,Y):-progeny(X,Z),progeny(Y,Z),man(Y),X\==Y,man(Z).
%brother(brother, sister).
sister(X,Y):-progeny(X,Z),progeny(Y,Z),woman(Y),X\==Y,man(Z).

%husband(wife, husband).
husband(X,Y):-marriage(Y,X),man(Y).
%wife(husband, wife).
wife(X,Y):-marriage(X,Y),woman(Y).


