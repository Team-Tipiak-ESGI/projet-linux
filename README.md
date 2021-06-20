# PROJET LINUX - 2A1

**Vous allez mettre en place une machine sous Linux.**
**Vous l'installerez sans interface graphique.**


**I - Scripts et personnalisation :**

• Vous  allez  créer  un  premier  script  permettant  de  créer automatiquement des utilisateurs utilisables.  

• Vous  utiliserez  un  fichier source  pour  cette  création dont  chaque  ligne  aura  la structure suivante :
`Login:prénom:nom:groupe1:groupe2:...:groupen:motdepasse`

• Chaque utilisateur aura, dans le champ commentaire de `/etc/passwd`, son prénom suivi de son nom, 
il pourra se connecter avec le login et le mot de passe donnés dans le fichier. 

• Chaque  utilisateur aura  groupe1  comme  groupe  primaire  et  les  groupes  suivants  seront  ses groupes  secondaires. 
• Si  les  groupes  n'existent  pas,  il  faudra  les  créer.  
• Le  nombre  de  groupes par ligne pourra être différent (et devra l'être pour votre démonstration).

• De plus, l'utilisateur devra changer son mot de passe lors de sa première connexion.
• Vous  peuplerez  leurs  répertoires  de  5  à  10  fichiers  d'une  taille  aléatoire,  pour  chaque  fichier, entre 5Mo et 50Mo.
• Si vous lancez le script plusieurs fois, il ne doit pas recréer des utilisateurs qui existent déjà.
• Vous  allez  écrire  un  script  shell  qui  va  calculer  la  taille  des  répertoires  personnels  de  tous  les utilisateurs humains du système.

**II - Calcul espace utilisation au login :**

• Ce  script  classera  les  utilisateurs  du  plus  au  moins  gourmand  en  espace  disque  grâce  à l'algorithme "tri pair/impair" que vous implémenterez.A la connexion, chaque utilisateur verra apparaître la liste des 5 plus gros consommateurs d'espacedans l'ordre décroissant.
• De plus, vous modifierez le fichier `.bashrc` de chaque utilisateur pour qu'il voit s'afficher la taille de son répertoire personnel ainsi qu'un avertissement s'il occupe plus de 100Mo.

• Les tailles devront s'afficher sous la forme "XGo,YMo,Zko et Toctets".
• NB:  le  fichier  .bashrc  ne  doit  pas exécuter  votre  script,  il  doit  seulement  contenir  les  lignes permettant  d’afficher  ce  qui  est  demandé.  
• Votre  script  doit  écrire  ces  lignes  d’affichage  dans .bashrc.

• Attention : si on lance plusieurs fois le script, les messages ne doivent pas s'afficher plusieurs fois.
• Vous  allez  créer  un  script permettant  de  contrôler  les  exécutables  pour  lesquels  le  SUID et/ou le SGID est activé. 
• Il permettra de générer une liste de ces fichiers et de la comparer, si elle existe, avec la liste créée lors du précédent appel du script.
• Si les 2 listes sont différentes, un avertissement s'affiche avec la liste des différences.Vous afficherez la date de modificationdes fichiers litigieux.


**III–Serveur DNS :**

• Vous mettrez  en place un  serveur  DNS primaire  sur  votre machine.  Il devra être capable de résoudre des  requêtes  concernant  des  machines  du  réseau  local  et  des  requêtes  concernant  des  hôtes  sur internet. Le nom de la zone est laissé à votre choix.Vous devrez définir au moins 2 machines avec un alias pour l'une d'entre elles.Vous définirez aussi la zone reverse et mettrez en place un serveur secondaire sur une autre machine.Lors  de  la  soutenance, vous  devrez  avoir  prévu  des  procédures  de  testde  toutes  les fonctionnalités. Vous  rédigerez  une  notice  donnant  les  différentes  configurations  et  scripts.  Vous  la  téléchargerez  sur l'interface de gestion de projet.
