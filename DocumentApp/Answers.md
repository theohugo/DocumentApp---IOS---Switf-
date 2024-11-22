------------------------------------------------------------
#Environnement
------------------------------------------------------------
#Exercice 1

##Les Targets

Les targets définissent comment ton projet sera construit. 
Exemple : un target pour une app iOS, un autre pour des tests unitaires. On peu les configurer dans l'onglet Targets des paramètres du projet.

##Fichiers par défaut :

AppDelegate.swift : Gère les événements globaux de l'app, comme le lancement ou la fermeture.
SceneDelegate.swift : Gère les différentes scènes (fenêtres) dans une app.
Main.storyboard : Interface graphique de ton app.
Info.plist : Contient des infos de configuration (nom de l’app, permissions...).

##Assets.xcassets
Dossier où on stocke les images (logos, icônes), les couleurs, et les symboles pour ton app. 
C'est optimisé pour gérer les différentes résolutions (2x, 3x).

##Storyboard
Le storyboard est une interface visuelle pour concevoir ton app. On crées des écrans (ViewControllers) et les relis avec des segue pour définir le flux de navigation.
C’est ici que l'on ajoute des éléments comme des boutons, labels, etc.

##Simulateur
Un simulateur est un outil qui émule un appareil iOS (iPhone, iPad) directement sur le Mac. 

#Exercice 2

## ⌘ + R:
La commande : ⌘+R sert à build et run l'app 

## ⌘ + Shift + O:
La commande : ⌘+shift+O sert à rechercher des fichier spécifique dans l'app 

##Le raccourci pour indenter automatiquement le code dans Xcode est :
⌘ + A (sélectionner tout)
puis
Ctrl + I (indenter).


##Le raccourci pour commenter ou décommenter une sélection dans Xcode est :
⌘ + /

#Exercice 3

Regarde en haut à gauche de Xcode, à côté du bouton "Play".
Tu verras "Document App>Iphone 15 Pro" clique sur Iphone 15 Pro, une liste des appareils disponibles (iPhone, iPad, etc.) s'affiche et choisi celui voulu.


------------------------------------------------------------
#Delegation
------------------------------------------------------------
#Exercice 1

Les propriétés statiques permettent de gérer des données ou des états partagés, simplifient l'accès global et évitent la duplication inutile. Elles sont idéales pour des constantes, des configurations globales ou des compteurs.

#Exercice 2

dequeueReusableCell :

Réduit la consommation mémoire.
Diminue la charge CPU en évitant des créations inutiles.
Améliore la fluidité du défilement, rendant l’expérience utilisateur plus agréable.

------------------------------------------------------------
#Navigation
------------------------------------------------------------
#Exercice 1
Que venons-nous de faire ?
En ajoutant un NavigationController, nous avons encapsulé notre DocumentTableViewController dans un système de navigation hiérarchique. Cela permet de :

- Gérer la navigation entre plusieurs écrans : le NavigationController garde une pile (stack) des écrans affichés.
- Afficher une barre de navigation (NavigationBar) : cette barre permet d’ajouter un titre, des boutons de navigation (Back, Done, etc.) ou des actions spécifiques.

NavigationController : Responsable de la gestion de la navigation, de la pile d’écrans, et des animations.
NavigationBar : Un composant visuel affichant des informations et des actions spécifiques à chaque écran. Elle est contrôlée par le NavigationController




------------------------------------------------------------
#Bundle
------------------------------------------------------------
#Exercice 1
Le code fourni identifi les document de type Jpeg pour crée des instances de types DocumentFile
ces documents sont retournés dans une liste nommée documentListBundle 

// Récupère une instance du FileManager (gestionnaire de fichiers par défaut)
let fm = FileManager.default

// Obtient le chemin du bundle principal de l'application (là où sont stockés les fichiers non exécutables)
let path = Bundle.main.resourcePath!

// Récupère la liste des fichiers présents dans le dossier du bundle
let items = try! fm.contentsOfDirectory(atPath: path)

------------------------------------------------------------
#Ecran Detail
------------------------------------------------------------
#Exercice 1
Ecran detail: 
ex1 : Un Segue est un lien de navigation entre composants
ex2 : Une constraint est une règle qui définit la position, la taille, ou le comportement des éléments d'interface utilisateur (UI) dans un layout. Elle gere le positionement, dimentionnement, relation dynamique...


------------------------------------------------------------
#QLPreview
------------------------------------------------------------
#Exercice 1
Utiliser un disclosure indicator améliore l'ergonomie et la clarté de votre application. Cela respecte les conventions d'interface d'iOS, facilite la navigation pour les utilisateurs, et rend votre application plus professionnelle. C'est un petit ajustement qui peut grandement améliorer l'expérience utilisateur.

------------------------------------------------------------
#Importation
------------------------------------------------------------
#Exercice 1
La fonction defer en Swift est utilisée pour exécuter du code juste avant de quitter la portée courante, que ce soit à la fin de la fonction ou après une sortie prématurée (par exemple, suite à une erreur ou un return). Elle est souvent utilisée pour libérer des ressources, fermer des fichiers, ou nettoyer des états, garantissant que ces actions seront effectuées, peu importe le chemin d'exécution.
