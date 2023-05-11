%reino
frame(animal, subclase_de(objeto), propiedades([puede(sentir), puede(respirar)])).
%tipo
frame(mamifero, subclase_de(animal), propiedades([puede(mamar), respira(aire)])).
%Orden
%frame(artiodactilo, subclase_de(mamifero, propiedades([tiene(pesugnas_pares), comen(plantas)]))).
frame(carnivora, subclase_de(mamifero), propiedades([comen(carne)])).
frame(primates, subclase_de(mamifero), propiedades([tiene(cerebro_desarrollado)])).
frame(proboscidea, subclase_de(mamifero), propiedades([es(grande)])).
frame(perissodactyla, subclase_de(mamifero), propiedades([tiene(pesugnas_impares)])).
frame(chiroptera, subclase_de(mamifero), propiedades([tiene(alas), es(roedor)])).
%Familia
%frame(camelidos, subclase_de(artiodactilo), propiedades([familia_de(camellos)])).
frame(canidae, subclase_de(carnivora), propiedades([puede(comer_vegetales)])).
%frame(suidae, subclase_de(artiodactilo), propiedades([son(inteligentes)])).
frame(hominidae, subclase_de(primates), propiedades([son(grandes_simios)])).
frame(felidae, subclase_de(carnivora), propiedades([son(felinos)])).
frame(elephantidae, subclase_de(proboscidea), propiedades([son(elefantes)])).
frame(equidae, subclase_de(perissodactyla), propiedades([son(compatibles)])).
frame(rhinocerotidae, subclase_de(perissodactyla), propiedades([tien(cuerno)])).
frame(ursidae, subclase_de(carnivora), propiedades([son(osos)])).
frame(noctilionoidea, subclase_de(chiroptera), propiedades([es(pescador)])).
%Ejemplares
frame(vicugna_vicugna, subclase_de(camelidos), propiedades([nombre_comun(vicugna), imagen('vicugna.jpg')])).
frame(lama_guanicoe, subclase_de(camelidos), propiedades([nombre_comun(guanaco), imagen('guanaco.jpg')])).
frame(lama_pacos, subclase_de(camelidos), propiedades([nombre_comun(llama), imagen('llama.jpg')])).
frame(canis_lupus_familiaris, subclase_de(canidae), propiedades([nombre_comun(perro_domestico), imagen('husky.jpg')])).
frame(canis_rufus, subclase_de(canidae), propiedades([nombre_comun(lobo_rojo), imagen('lobo_rojo.jpg')])).
frame(canis_latrans, subclase_de(canidae), propiedades([nombre_comun(coyote), imagen('coyote.jpg')])).
frame(babyrousa_babyrussa, subclase_de(suidae), propiedades([nombre_comun(babirusa), imagen('babirusa.jpg')])).
frame(sus_scrofa, subclase_de(suidae), propiedades([nombre_comun(jabali), imagen('jabali.jpg')])).
frame(pan_troglodytes, subclase_de(hominidae), propiedades([nombre_comun(chimpance), vive_en(selvas), imagen('chimpance.jpg')])).
frame(gorilla_gorilla, subclase_de(hominidae), propiedades([nombre_comun(gorila), vive_en(bosques_costeros), imagen('gorila.jpg')])).
frame(pongo_pygmaeus, subclase_de(hominidae), propiedades([nombre_comun(orangutan), vive_en(selvas), imagen('orangutan.jpg')])).
frame(puma_concolor, subclase_de(felidae), propiedades([nombre_comun(puma), es(pequegna), emite(maullidos), imagen('puma.jpg')])).
frame(panthera_pardus, subclase_de(felidae), propiedades([nombre_comun(leopardo), es(rapido), imagen('leopardo.jpg')])).
frame(leopardus_geoffroyi, subclase_de(felidae), propiedades([nombre_comun(gato_montes), es(chiquito), imagen('montes.jpg')])).
frame(elephas_maximus, subclase_de(elephantidae), propiedades([nombre_comun(elefante_asiatico), imagen('elefante.jpg')])).
frame(equus_caballus, subclase_de(equidae), propiedades([nombre_comun(caballo), ruido(relincha), imagen('caballo.jpg')])).
frame(ceratotherium_simum, subclase_de(rhinocerotidae), propiedades([nombre_comun(rinoceronte_blanco), imagen('rino.jpg')])).
frame(ursus_arctos, subclase_de(ursidae), propiedades([nombre_comun(pardo), pelaje(marron), imagen('pardo.jpg')])).
frame(ursus_maritimus, subclase_de(ursidae), propiedades([nombre_comun(polar), pelaje(blanco), imagen('polar.jpg')])).
frame(ailuropoda_melanoleuca, subclase_de(ursidae), propiedades([nombre_comun(panda), pelaje(blanco_y_negro), imagen('panda.jpg')])).
frame(noctilio_albiventris, subclase_de(noctilionoidea), propiedades([nombre_comun(murcielago_bulldog), imagen('murcielago')])).




que_es(X):-((instancia(X),es(Clase,X));

(subclase(X),subc(X,Clase))),Clase\=objeto,write('es '),writeln(Clase),fail.

es(Clase,Obj):- frame(Obj,instancia_de(Clase),_).
es(Clase,Obj):- frame(Obj,instancia_de(Clasep),_),subc(Clasep,Clase).

subc(C1,C2):- frame(C1,subclase_de(C2),_).
subc(C1,C2):- frame(C1,subclase_de(C3),_),subc(C3,C2).

subclase(X):-frame(X,subclase_de(_),_).

instancia(X):-frame(X,instancia_de(_),_).

propiedadesc(objeto):-!.

propiedadesc(X):-frame(X,subclase_de(Y),propiedades(Z)),imprime(Z),propiedadesc(Y).
propiedadesi(X):-frame(X,instancia_de(Y),propiedades(Z)),imprime(Z),propiedadesc(Y).

props(X):-(instancia(X),propiedadesi(X));(subclase(X),propiedadesc(X)).

imprime([]):-!.
imprime([H|T]):-writeln(H),imprime(T).

about(X):-que_es(X);props(X).
