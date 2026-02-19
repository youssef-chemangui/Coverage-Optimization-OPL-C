// L Lemarchand
// c 2018
tuple Tpoint {
	int x;
	int y;
};
{ Tpoint } points = ...;

float Distance[points][points];
execute {
// calcul des distances
        for (var p1 in points)
                for (var p2 in points) {
                        var dx = p1.x - p2.x;
                        var dy = p1.y - p2.y;
                        Distance[p1][p2] = Opl.sqrt(dx*dx + dy*dy);
                }
}

tuple Tmodele {
	float portee;
	int cout;
};

{ Tmodele } modeles = ...;

int visibilite[points][points] = ...;

// variables utiles

{Tpoint} nonCouverts; // points non encore couverts
{Tpoint} tmpCouverts; // sauvegarde des points couverts par une antenne dans une iteration
{Tpoint} bestCouverts; // meilleure ens couvert courant
int select[modeles][points]; // solution
float cout = 0.0;

// Heuristique
execute {
	//import d'un set de point pas encore couvert
	nonCouverts.importSet(points);
	for(a in modeles)
		for(pa in points) select[a][pa] =0;
	//tant que tous les points ne sont pas couvert recommance
	while (nonCouverts.size > 0){
		var meilleurRatio = 0.0;
		var nouvPA, nouvA;
		for(a in modeles)
			for(pa in points){
				//a chaque iteration on supprime le couvert temporaire	
				tmpCouverts.clear();
				for(p in nonCouverts)
				//si mon antenne peut couvrir le point et est visible
				//alors ajout dans tmpsCouverts
					if((Distance[p][pa] <= a.portee) && (visibilite[p][pa] == 1))
						tmpCouverts.add(p);
				//si le ratio taille de couverture/cout est meilleur que le premier ratio
				//alors remplace bestCouverts par tmpCouverts
				if(tmpCouverts.size/a.cout > meilleurRatio){
					meilleurRatio = tmpCouverts.size/a.cout;
					nouvPA = pa;
					nouvA = a;
					bestCouverts.clear();
					bestCouverts.importSet(tmpCouverts);
  				}
   			} 
   		//cas ou il est impossible de couvir toute la zone 							
		if(bestCouverts.size == 0){
			writeln("impossible pour", nonCouverts);
		}
		//calcul du cout final	
		for(p in bestCouverts) nonCouverts.remove(p);
		select[nouvA][nouvPA] = 1;
		cout = cout + nouvA.cout;
	}


}

// sortie du resultat
execute {
	var sortie = "couv2.res";
        var ofile = new IloOplOutputFile(sortie);
        ofile.writeln(cout);
	for(var a in modeles)
		for (var pa in points)
			if (select[a][pa] == 1)
				ofile.writeln(a.portee, ", ", pa.x, " ", pa.y);
        ofile.close();
        writeln("trace dans ", sortie);
}

// Il est possible d'éviter l'appel au solver en écrivant un main() à la place du dernier execute -- cf exemples OPL
