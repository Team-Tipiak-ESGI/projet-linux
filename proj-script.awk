{
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
