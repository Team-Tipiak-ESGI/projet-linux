#!/bin/bash
## Setting var screen
echo  "####################################################################"
echo  "#    MISE EN PLACE DES VARIABLES D'ENVIRONNEMENT POUR LE SCRIPT    #"
echo  "####################################################################"
## Setting var
## set
# sortie immediate a l'echec
# permet d'executer une commande meme si la premiere commande est fautive
# i.e cmd_fautive || true
set -e -o pipefail
## Initialisation des fonctions
# outerr: sortie vers stderr
outerr (){
  echo "$@" >&2
}

printf "\n\n"
sleep 1

## Welcome Screen
echo  "####################################################################"
echo  "#    BIENVENUE SUR LES SCRIPTS D'INSTALLATION SAGLISS.INDUSTRIES   #"
echo  "#	 MERCI DE VERIFIER QUE VOUS POSSEDEZ LES DROITS ROOT 	  #"
echo  "#	MERCI DE VERIFIER QUE VOUS AVEZ VOTRE FICHIER DE PRET	  #"
echo  "####################################################################"
sleep 2
## verifie que l'utilisateur a bel et bien mis un fichier en argument 
## si non retourne erreur
if [ $# -eq 0 ]
 then
	outerr "Merci de mettre un fichier en argument"
	outerr "usage `useradd ficher.txt`"
	exit 1
fi

## verifie si l'utilisateur est root,
## si il n'est pas egal a 0 ca retourne erreur 

if [ "$EUID" -ne 0 ]
then 
	outerr "Vous n'etes pas root !"
	outerr "fermeture..."
	exit 1
fi
## Ecran accueil
echo "###########################################################################"
echo "#										#"
echo "# useradd - ESGI edition							#"
echo "# useradd prend en entree un fichier					#"
echo "# Il permet de creer de facon automatique des utilisateurs utilisables	#"
echo "# structure : login:surname:name:group1:group2:...:groupN:password	#"
echo "# group1 = groupe primaire						#"
echo "# group 2 -> n = groupes secondaires					#"
echo "# mot de passe expirable							#"
echo "#										#"
echo "###########################################################################"

sleep 2
fileawk=$1
echo "ficher : " $1
awk -F ':' -f parser.awk $fileawk > awk_out.tmp

# Lecture du fichier sortie d'awk
while read -r commands
do
	$commands
#done < testout.txt
done < awk_out.tmp
rm awk_out.tmp

## ajout du script de calcul automatique dans les dossiers /etc/profile.d/
cp disk-usage.sh /etc/profile.d/
