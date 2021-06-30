#!/bin/bash
outerr (){
	echo "$@" >&2
}
if [ "$EUID" -ne 0 ]
then
	outerr "Vous n'êtes pas en super utilisateur"
	outerr "Abandon..."
	exit 1
fi
var=($(du -s /home/* | sort -nr))
echo = "top 5 des utilisateurs les plus gourmands :"
for ((i=0 ; 10 - $i ; i++))
do
	if [ $((i%2)) -eq 0 ]
	then
		temp=$((${var[$i]}))
		var[$i]=$(($temp * 1024))
		#echo ${var[$i]}
		ko=$temp
		mo=$(($ko - $ko/1024))
		#go=$(($mo - $mo/1024))
		#to=$(($go - $go/1024))
		#echo $ko
		#echo $mo
		#echo $go
		#echo $to
	else
		username= echo ${var[$i]} | cut -d'/' -f3
		echo $username
fi
	if [ $((i%2)) -eq 0 ]
	then
		a="a"
		#echo 
	fi
done

