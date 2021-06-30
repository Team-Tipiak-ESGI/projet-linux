	{	
	# variables pour parse
	login=$1
	nom=$2
	prenom=$3
	pwd=$NF
	j= 0
	# arguments pour 'useradd'
	flags="useradd --create-home --shell /bin/bash "
	passwdFlag="--password $(echo "pwd" | openssl passwd -crypt -stdin) "
	# modification du user - ajout groupe - informations complementaires
	usermodGECOS="usermod -c \"" $3 " - " $2"\""    " " $1 
	usermodGROUPprim="usermod -g "$4" "$1
	usermodGROUPsec="usermod -aG "
	#sortie dans le terminal, recup par stdin dans un fichier
	print flags passwdFlag login
	print usermodGECOS
	print "groupadd -f " $4
	print usermodGROUPprim
	for(i=5;i<=(NF-1);i++)
		{
		print "groupadd -f " $i
		print usermodGROUPsec $i" "$1
		}
	print "passwd -e "$1
}
