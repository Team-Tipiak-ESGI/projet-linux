
#!/bin/bash
var=($(du -sb /home/* 2> >(grep -v '^du: \(impossible\|cannot\)' >&2) | sort -nr))
printf "ATTENTION, Certains fichiers peuvent etre masques, et par consequent fausser les resultats du top \n"
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
		#ko=$(($temp / 1024))
		#go=$(($temp / 1073741824))
		#mo=$(($temp / 1048576))
fi
	if [ $((i%2)) -eq 1 ]
	then
		username=$(echo ${var[$i]} | cut -d/ -f3)
		count=$(($i / 2 + 1))
		printf "%d  - %d Go, %d Mo, %d ko, %d octets - %s\n" "$count" "$go" "$mo" "$ko" "$o" "$username"
	fi
done

