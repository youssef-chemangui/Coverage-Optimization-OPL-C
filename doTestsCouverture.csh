#!/bin/csh

# genere une serie de problemes de couverture
set trials = 10

# la description des antennes
rm -f tmpantennes.dat
cat << FIN > tmpantennes.dat
modeles = {
< 3.6, 120 >,
< 1.4, 100 >
< 0.4, 10 >
};
FIN

foreach i (`seq $trials`)
	rm -f couv.dat
	cp tmpantennes.dat couv.dat # les antennes dans le .dat du probleme
	./genPoints 100 $i >> couv.dat # les points et leur matrice de visibilité ajoutés au .dat
	oplrun couv2heuristique.mod couv.dat # resolution heuristique 
	echo val trial $i " : " `head -1 couv.res` # analyse partielle du resultat (val fct obj)
end

#rm -f couv.dat couv.res tmpantennes.dat

