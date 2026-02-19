#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#define MAXANTENNES 10
#define MAXPOINTS 1000

typedef struct {
	float portee;
	int cout;
} antenne_t;


int NbAntennes;
antenne_t modeles[MAXANTENNES];

int NbPoints;
float Distances[MAXPOINTS][MAXPOINTS];
int Visibilite[MAXPOINTS][MAXPOINTS];

void readCouverture(char *filename)
{
	FILE *fp = fopen(filename, "r");
	if (!fp) exit(0);

	fscanf(fp, "%d", &NbAntennes);
	for (int a=0; a<NbAntennes; a++)
		fscanf(fp, "%f%d", &(modeles[a].portee),
				   &(modeles[a].cout));
	fscanf(fp, "%d", &NbPoints);
	for (int i=0; i<NbPoints; i++)
		for (int j=0; j<NbPoints; j++)
			fscanf(fp, "%f%d", 
				&(Distances[i][j]),
				&(Visibilite[i][j]));
}

int couvrir(int select[MAXANTENNES][MAXPOINTS]) {
    float cout = 0.0;
    int nonCouverts[MAXPOINTS];
    for (int i = 0; i < NbPoints; i++) nonCouverts[i] = 1; 

    while (1) {
        int bestAntenne = -1;
        int bestPoint = -1;
        int bestCouverts = 0;
        float bestRatio = -1.0;

        for (int a = 0; a < NbAntennes; a++) {

            for (int pa = 0; pa < NbPoints; pa++) {
                int couverts = 0;

                for (int p = 0; p < NbPoints; p++) {
                    if (nonCouverts[p] && Distances[pa][p] <= modeles[a].portee && Visibilite[pa][p]) {
                        couverts++;
                    }
                }

                if (couverts > 0) {
                    float ratio = (float)couverts / modeles[a].cout;
                    if (ratio > bestRatio) { 
                        bestRatio = ratio;
                        bestAntenne = a;
                        bestPoint = pa;
                        bestCouverts = couverts;
                    }
                }
            }
        }

        if (bestAntenne == -1) break;

        select[bestAntenne][bestPoint] = 1;
        cout += modeles[bestAntenne].cout;

        for (int p = 0; p < NbPoints; p++) {
            if (nonCouverts[p] && Distances[bestPoint][p] <= modeles[bestAntenne].portee && Visibilite[bestPoint][p]) {
                nonCouverts[p] = 0;
            }
        }
    }

    return cout;
}

int main(char argc, char *argv[])
{
	char *filename = "c.dat";
	if (argc == 2) {
		filename = argv[1];
		char cmd[1024];
		sprintf(cmd, "oplrun dat2cprog.mod %s", argv[1]);
		system(cmd);
		sleep(1);
	}
	readCouverture("c.dat");

	printf("from %s: read %d points and %d antennas problem\n", 
			filename, NbPoints, NbAntennes);

	int select[MAXANTENNES][MAXPOINTS];

	int cout = couvrir(select);

	for(int a=0; a<NbAntennes; a++)
		for(int p=0; p<NbPoints; p++)
			if (select[a][p] == 1)
				printf("ant %d at point %d\n", a+1, p+1);

	printf("cost : %d\n", cout);
}
