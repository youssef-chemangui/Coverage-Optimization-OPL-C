# Coverage-Optimization-OPL-C
# 📡 Optimisation de la Couverture par Antennes

Ce projet traite un problème d’optimisation consistant à couvrir un ensemble de points géographiques 
à l’aide de différents modèles d’antennes possédant des portées et des coûts distincts.

L’objectif est de minimiser le coût total d’installation tout en assurant la couverture complète de la zone.

---

## 🧠 Méthode utilisée

Une heuristique gloutonne (greedy) est implémentée :

- À chaque itération, on sélectionne l’antenne et la position maximisant le ratio :
  
  couverture / coût
  
- Les points couverts sont retirés de l’ensemble des points restants
- Le processus continue jusqu’à couverture complète

---

## 🛠️ Technologies utilisées

- OPL (IBM ILOG CPLEX Optimization Studio)
- Langage C
- Script shell pour automatisation des tests

---

## 📂 Structure du projet

- `couv2heuristique.mod` → Heuristique implémentée en OPL
- `dat2cprog.mod` → Conversion des données OPL vers format C
- `heuristique.c` → Implémentation C de l’heuristique
- `genPoints` → Générateur d’instances
- Script bash → Lancement automatique des expérimentations

---

## ▶️ Exécution

### Génération et test avec OPL
```bash
oplrun couv2heuristique.mod couv.dat

