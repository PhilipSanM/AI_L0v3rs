

% Base de conocimiento, Coloque aqu� los predicados para representar el
% conocimiento
%Frutas
fruta(papaya, 45).
fruta(melon, 31).

%Cereales
cereal(pan_centeno, 241).
cereal(pan_blanco, 255).

%jugos
jugo(zumo_naranja,42).

%Huevo
huevo(huevo_entero, 147).

%C�rnico

carnico(chuleta_cerdo, 330).
carnico(chicharron, 601).

%Pastas

pasta(pasta_huevo, 368).
pasta(pasta_semola, 361).

%Postre
postre(flan_vainilla, 102).
postre(flan_huevo, 126).

%Lacteo
lacteo(leche_entera, 68).
lacteo(leche_semidescremada, 49).

%Colaci�n
colacion(donut, 456).
colacion(pastel_manzana, 311).

%Regla para armar el desayuno
desayuno(D1, D2, D3, D4, KCal):-fruta(D1,K1), cereal(D2, K2), jugo(D3, K3), huevo(D4, K4), KCal is K1+K2+K3+K4.

%Regla para armar la comida
comida(C1, C2, C3, KCal):-carnico(C1,K1), pasta(C2, K2), postre(C3, K3), KCal is K1+K2+K3.

%Regla para armar la merienda
merienda(M1, M2, KCal):-lacteo(M1, K1), colacion(M2, K2), KCal is K1+K2.

% Ciclo principal

main:-repeat,
      pinta_menu,
      read(Opcion),
      ( (Opcion=1,doImc,fail);
	(Opcion=2,doDieta,fail);
	(Opcion=3,!)).

% Muestra el men�

pinta_menu:-nl,nl,
      writeln('===================================='),
      writeln('         DRA. MIKU HATSUNE'),
      writeln('          M�dica Virtual'),
      writeln('   <<  Experta en Nutrici�n  >>'),
      writeln('===================================='),
      nl,writeln('       MENU PRINCIPAL'),
      nl,write('1 Calcular indice de masa corporal'),
      nl,write('2 Recomendar una dieta saludable'),
      nl,write('3 Salir'),
      nl,write('================================='),
      nl,write('Indique una opcion v�lida:').

% Regla para calcular IMC

doImc:-nl, write('================================='),nl,
       write('Elegiste: Calculo del Indice de Masa Corporal\n'),nl,
       write('Indique su peso en Kilogramos:'),read(Peso),
       write('Indique su estatura en Metros:'),read(Estatura),Estatura > 0,
       write('Indique su genero (1/Male, 2/Female):'),read(Sexo),
       IND is Peso/(Estatura*Estatura),
       nl,format('Su indice de masa corporal es: ~g',IND),
       nl, write('DIAGNOSTICO: '),
        ((Sexo=1,(
                 (IND<17,write('USTED PADECE DESNUTRICION!'));
                 (IND>=17,IND<20,write('USTED PADECE BAJO PESO!'));
                 (IND>=20,IND<25,write('USTED ESTA NORMAL!'));
                 (IND>=25,IND<30,write('USTED PADECE LIGERO SOBREPESO!'));
                 (IND>=30,IND<40,write('USTED PADECE OBESIDAD SEVERA!'));
                 (IND>=40,write('USTED PADECE OBESIDAD MORBIDA!'))
                 )
             );
	   (Sexo=2,(
                 (IND<16,write('USTED PADECE DESNUTRICION!'));
                 (IND>=16,IND<20,write('USTED PADECE BAJO PESO!'));
                 (IND>=20,IND<24,write('USTED ESTA NORMAL!'));
                 (IND>=24,IND<29,write('USTED PADECE LIGERO SOBREPESO!'));
                 (IND>=29,IND<37,write('USTED PADECE OBESIDAD SEVERA!'));
                 (IND>=37,write('USTED PADECE OBESIDAD MORBIDA!'))
                 )
             )
        ).

% Regla para recomendar dietas

doDieta:-nl, write('================================='), nl,
    	 writeln('Elegiste: Nutriologo Artificial'), nl,
         write('Indique su peso en Kilogramos:'),read(Peso),Peso > 0,
         write('Indique su edad en años:'),read(Edad),Edad > 0,
         write('Indique su genero (1/Male, 2/Female):'),read(Sexo),
         nl, write('DIAGNOSTICO: '),
         ( (Sexo=1,
               KCalAux is Peso * 24
             );
	       (Sexo=2,
               KCalAux is Peso * 21.6
             )
          ),
    	  ( (Edad<25,
                KCal is KCalAux + 300);
             (Edad>=25,Edad<55,
                KCal is KCalAux);
          	 (Edad>=55,
                 KCal is KCalAux - ((((Edad-45) - ((Edad-45) mod 10))/10) * 100))
          
          ),
          format("\nEl total de KCalorias a comer son: ~f",KCal),nl,
    	  writeln('Su comida escogida puede ser: '),nl,
    	  dieta(KCal).
    	
 dieta(Gasto):-desayuno(D1,D2,D3,D4,K1),
              comida(C1,C2,C3,K2),
              merienda(M1,M2,K3),
              KCalComida is K1+K2+K3,
              Inferior is Gasto-(Gasto*0.1),
              Superior is Gasto+(Gasto*0.1),
              KCalComida >= Inferior, KCalComida=< Superior,
              format("\nDesayuno: ~s, ~s, ~s y ~s", [D1,D2,D3,D4]),
              format("\nComida  : ~s, ~s y ~s", [C1,C2,C3]),
              format("\nCena: ~s y ~s", [M1,M2]),
              format("\nLa suma de calorias seria: ~d \n<<Ingrese cualquier tecla para continuar>>",KCalComida),
    		  read(tecla),fail.







