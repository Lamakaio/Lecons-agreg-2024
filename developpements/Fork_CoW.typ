#import "../utils.typtp": *
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#import "dev_tplt.typtp": developpement
#import "@preview/syntree:0.2.1": tree


#show: developpement.with(
  titre: [Fork et l'optimisation du Copy-on-Write], 
  niveau: [L3], 
  prerequis: [Concurrence, notions de C, mémoire virtuelle])


= Introduction : Qu'est ce que fork, et pourquoi l'utiliser ? 
== Thread ou Processus ? 

En C, ce sont les thread qui sont au programme. Mais il existe deux paradigmes pour avoir multiples fils d'executions dans un programme : les thread et les processus. Voici un bref tableau comparatif. 

#grid(columns: (1fr, 2fr, 2fr), align: center, gutter: 15pt, [],
underline[Thread], 
underline[Processus], 
[Espace mémoire], 
[Partagé entre les thread], 
[Propre à chaque processus], 
[Sécurité], 
[Accès à la mémoire des autres thread possible], 
[Accès à la mémoire des autres processus impossible], 
[Gestion des erreurs], 
[Une erreur dans un thread peut se propager aux autres],
[Chaque processus est indépendant et n'affecte pas les autres], 
[Vitesse d'execution], 
[Rapide], 
[2-20 fois plus lent]
)

== Sémantique de `fork()`
Dans les systèmes Unix, l'appel système principal permettant de créer un nouveau processus. `fork()` effectue les actions suivante : 
- duplique le processus courant et le contenu de sa mémoire
- renvoie 0 dans le processus "enfant" et le `pid` de l'enfant dans le parent
- continue l'execution du programme en cours dans les deux processus. 


#underline[Exemple]

```C
int global_var = 4;
int main() {
  int local_var = 3; 
  pid_t pid = fork();
  if (pid == 0) {
    printf("Je suis l'enfant !\n");
  }
  else {
    printf("Je suis le parent, mon enfant est %d !\n", pid);
  }
}
```

#text(fill: red)[Faire un dessin qui montre le branchement]

Attention : même si les deux processus executent le même code, leur mémoire n'est pas partagé ! Si le parent écrit dans `global_var`, ce ne sera pas visible depuis l'enfant. 

Mais copier toute la mémoire, c'est très long ! Comment faire pour être plus rapide ? 

= Copy-on-Write 

== Principe général 
L'idée, c'est de ne pas réèllement copier les données. En effet, tant que les deux processus ne font que des lectures mémoire, il n'y a pas besoin de faire de copie ! 
Ainsi, en vérité, `fork` utilise la stratégie suivante : 
- Juste après l'appel à `fork`, les deux processus partagent tout leur espace mémoire. 
- Tant qu'il n'y a que des lectures : tout va bien, la mémoire peut reste partagée. 
- Si un des deux processus effectue une écriture : on copie la donnée en question, et on sépare la mémoire des deux processus à cet endroit de la mémoire. 

Ce procédé est totalement invisible pour l'utilisateur, et rend `fork` raisonnablement rapide à utiliser en pratique ! 
En revanche, le temps de copie est déplacé sur les instructions d'écriture en mémoire. 

== Implémentation grâce à la table de pages. 
Comment implémenter le Copy-on-Write en pratique ? On va utiliser la mémoire virtuelle et la table des pages. 

Chaque bloc de 4Ko a une correspondance vers la mémoire physique dans la table des pages. Cette table contient les adresses physique et virtuelles de la page, mais aussi plusieurs drapeaux !  

Lors des accès mémoire, c'est le CPU lui-même qui gère la traduction, c'est donc très rapide. 

#text(fill: red)[Rappeler le fonctionnement de la mémoire virtuelle avec un petit schema]

Parmis ces drapeaux, on a, en particulier, des permissions : `read`, `write` et `exec`. Nos blocs partagés peuvent être lus et executés, mais pas modifiés ! On va donc mettre le drapeau `write` à 0. Ces drapeaux sont vérifiés par le CPU lors des accès mémoire. 

Il y a aussi, sur certains CPU, des drapeau "libre" qui peut être utilisé pour marquer qu'un bloc est "Copy-on-Write".

Quand un accès en écriture est faire sur une page "Copy-on-Write", comme le drapeau `write` est à 0, le CPU lève une interuption. Cette exception est rattrapée par le système, qui peut ensuite copier la page correspondante et reprendre l'execution. 

Pour résumer, l'appel à `fork` fais les actions suivantes : 
- Marque toutes les pages de la mémoire du processus actuel en `read-only` et "Copy-on-Write". 
- Crée un nouveau processus avec le même espace mémoire que le parent. 


Puis, lors d'un accès en écriture : 
- Le CPU lève une interruption car le système a interdit l'écriture. 
- Le système alloue une nouvelle page physique pour l'adresse mémoire qui doit être écrite. 
- Le système copie les données de l'ancienne page vers la nouvelle. 
- La nouvelle page peut être écrite. L'ancienne page, si elle n'est plus partagée, peut être écrite aussi. 
- Le système reprend l'execution juste avant l'écriture mémoire, et le programme ne se rend compte de rien ! 