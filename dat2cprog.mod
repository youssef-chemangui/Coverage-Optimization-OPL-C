// L Lemarchand
// c 2023
// ecrit dans un fichier c.dat les donn�es du probleme de couverture,
// dans un format facilement lisible par un programme C. Format :
// nbmodeles
// pAnt1 coutAnt1
// pAnt2 coutAnt2
// ...
// nbPoints
// distP1-P1 visiP1-P1
// distP1-P2 visiP1-P2
// ...

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

tuple Tantenne {
	float portee;
	int cout;
};

{ Tantenne } modeles = ...;

int visibilite[points][points] = ...;

{Tpoint} nonCouverts;
{Tpoint} tmpCouverts;
{Tpoint} bestCouverts;
int select[modeles][points];
float cout = 0.0;

// Conversion pour lecture en C
execute {
	var sortie = "c.dat";
        var ofile = new IloOplOutputFile(sortie);
	writeln("extracting covering problem data into c.dat file"); 
	ofile.writeln(modeles.size);
        for (var a in modeles)
		ofile.writeln(a.portee, " ", a.cout);
	ofile.writeln(points.size);
        for (var p1 in points)
                for (var p2 in points) {
			ofile.writeln(Distance[p1][p2]);
			ofile.writeln(visibilite[p1][p2]);
		}
	ofile.close();
}

