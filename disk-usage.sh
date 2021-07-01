#!/bin/bash
var=($(du -sb /home/* 2> >(grep -v '^du: \(impossible\|cannot\)' >&2) | sort -nr))
printf "\n\n\nATTENTION: Certains fichiers peuvent etre masques, et par consequent fausser les resultats du top \n"
printf "top 5 des utilisateurs les plus gourmands :\n"
for ((i=0 ; 10 - $i ; i++))
do
	if [ $((i%2)) -eq 0 ]
	then
		temp=$((${var[$i]}))
		to=$(($temp / 1099511627776))
		go=$((($temp - $to * 1099511627776) / 1073741824))
		mo=$((($temp - $go * 1073741824) / 1048576))
		ko=$((($temp - $mo * 1048576) / 1024))
		o=$(($temp - $to * 1099511627776 - $go * 1073741824 - $mo * 1048576 - $ko * 1024 ))
fi

	if [ $((i%2)) -eq 1 ]
	then
		username=$(echo ${var[$i]} | cut -d/ -f3)
		count=$(($i / 2 + 1))
		printf "%d  - %d Go, %d Mo, %d ko, %d octets - %s\n" "$count" "$go" "$mo" "$ko" "$o" "$username"
fi
done
	du=($(du -sb $HOME))
	temp=$((${du[0]}))
	to=$(($temp / 1099511627776))
	go=$((($temp - $to * 1099511627776) / 1073741824))
	mo=$((($temp - $go * 1073741824) / 1048576))
	ko=$((($temp - $mo * 1048576) / 1024))
	o=$(($temp - $to * 1099511627776 - $go * 1073741824 - $mo * 1048576 - $ko * 1024 ))
	printf "\n\n\nVotre repertoire personnel fait actuellement %d Go, %d Mo, %d Ko, %d Octets \n" "$go" "$mo" "$ko" "$o"
	if [ $mo -lt 100 ]
	then
		printf "\nAttention, votre repertoire personnel depasse la limite autorisee de 100Mo!\n"
fi
