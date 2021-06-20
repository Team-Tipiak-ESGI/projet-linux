#!/bin/bash/

####################################################
#
# useradd - ESGI edition
# useradd prend en entree un fichier
# Il permet de creer de facon automatique des utilisateurs utilisables
# structure : login:surname:name:group1:group2:...:groupN:password
# group1 = groupe primaire
# group 2 -> n = groupes secondaires
# mot de passe expirable
#
####################################################

flags_home="--create-home " # creation du home @/home/user
flags_shell="--shell /bin/bash " # affectation du shell bash a l'user, on peux mettre zsh pour plus de flex
flags_groups="--groups $groups " # affectations des groups TODO: A verifier au prealable si les groupes sont pas au prealable crees
flags_primary="--gid $groups[1] " # groups etant un tableau de group1 -> groupN
flags_password="--password $(echo $password | openssl passwd -crypt -stdin)" # voir le man de useradd et passwd

user_password=""
user_name=""


passwd -e $user_name

#TODO: Creation Script GAWK pour parse le fichier utilisateur
