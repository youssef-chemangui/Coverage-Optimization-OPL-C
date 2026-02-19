#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// genPoints <nbPoints> [<seed>]
// les points sont à la fois les points à couvrir et les points possibles pour les antennes
/* produit:
points = {
< 1, 1>,
< 1, 2>,
< 1, 3>, 
< 1, 4>,
< 2, 1>,
< 2, 2>,
< 2, 3>, 
< 2, 4>
};

visibilite = [
[ 1 1 1 0 0 0 0 0 ]
[ 1 1 1 0 0 0 0 0 ]
[ 1 1 0 0 0 0 1 0 ]
[ 0 1 1 0 0 0 1 0 ]
[ 1 1 1 0 0 1 0 1 ]
[ 1 1 1 0 1 0 0 0 ]
[ 1 0 1 1 0 0 0 1 ]
[ 1 1 1 0 0 0 1 0 ]
];
*/

// A utiliser pour ajouter a couv.dat les points: ./genPoints 100 3 >> couv.dat
// les antennes doivent etre saisies � part
// cf doTestsCouverture
int main(int argc, char *argv[]) 
{

	int i, j;
	if (argc < 2) goto usage;

	int n = atoi(argv[1]);
	if (argc == 3) srand(atoi(argv[2]));

	printf("points = {\n");
	// A vous
	// generer les points
    for (i = 1; i <= n / 4; i++) {
        for (j = 1; j <= 4; j++) {
            printf("< %d, %d>,\n", i, j);
        }
    }
	printf("};\n");

	printf("visibilite = [\n");
	for(i=0; i<n; i++){
		printf("[ ");
		for(j=0; j<n; j++){
			printf("%d ", (rand()%2));
		}
		printf("]\n");
	}
	printf("];\n");

	// A vous
	// generer une matrice de visibilite


	return 0;
usage:
	fprintf(stderr, "usage: %s <nbPoints> [<seed>]\n", argv[0]);
	return 1;


}
