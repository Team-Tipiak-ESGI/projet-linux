#useradd --create-home --shell /bin/bash --groups groups
#appending to passwd file
function printToFile(login, nom, prenom, password, group, flags){
		print flags,
		print "echo \""nom " - " prenom "-" login \"" >> /etc/passwd
	}

BEGIN {
	print "Bonjour " ENVIRON["USER"]"... \nLancement du script."
	print "File separator = " FS
	
	}
	{	
	# arguments pour 'useradd'
	flags="useradd --create-home --shell /bin/bash"
	
	# variables pour parse
	login=$1
	nom=$2
	prenom=$3
	pwd= $(NF-1)
	j= 0
	for(i=4;i<=(NF-1);i++)
		{
		group[j]=$i
		j++
		}
	}
END {
	print "Parsing Fini, fichier de sortie : 'awk_out.tmp'."
	}
