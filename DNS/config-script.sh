# check if the userID is (ne) not equal to root, if yes then exit failure
if [ "$EUID" -ne 0 ]; then
	echo "Vous n'êtes pas en super utilisateur !" >&2
	echo "Abandon..." >&2
	exit 0
fi


echo "Indiquez l'interface réseau à utiliser : "
read interface
echo "Indiquez l'adresse du serveur actuel : "
read address
echo "Indiquez le masque du réseau : "
read netmask
echo "Indiquez la passerelle : "
read gateway
echo "Indiquez le nom de votre zone DNS : "
read zone_name
echo "Indiquez l'adresse du serveur DNS de réplication : "
read second_dns

# Reverse network address
IFS='.' read -ra ADDR <<< "$address"
IFS='.' read -ra MASK <<< "$mask"
for i in "${!ADDR[@]}"; do
    if [ ${MASK[i]} -eq "255" ]; then
        reverse="${ADDR[i]}.$reverse"
        network="$network.${ADDR[i]}"
    else
        network="$network.0"
    fi
done
# Remove last "."
reverse=${reverse%"."}
network=${network#"."}


echo "Installation des dépendances..."
apt install -y bind9 bind9utils bind9-doc dnsutils


# if no ip is set or is dhcp, ask for the configuration
echo "Configuration des interfaces réseau..."

echo "allow-hotplug $interface\
iface $interface inet static\
	address $address\
	netmask $netmask\
	gateway $gateway\
	dns-nameservers 127.0.0.1" >> /etc/network/interfaces


# Clear the file
echo "" > /etc/resolv.conf

echo "domain localdomain\
search localdomain\
nameserver 127.0.0.1" >> /etc/resolv.conf


echo "Configuration de la zone DNS..."

# Create the main DNS zone file
touch /etc/bind/db.$zone_name

echo "\$TTL 604800\
@	IN	SOA	$zone_name.	admin.$zone_name. (\
	2018040301	; Serial\
    3h	; Refresh\
    1h	; Retry\
    1w	; Expire\
    1h	; Minimum\
)\
@       IN      NS      ns1.$zone_name.\
ns1     IN      A       $address\
@       IN      NS      ns2.$zone_name.\
ns2     IN      A       $second_dns" > /etc/bind/db.$zone_name


# Create the reverse DNS zone file
touch /etc/bind/db.$reverse.in-addr.arpa

echo "\$TTL 604800\
@	IN	SOA	$zone_name.	admin.$zone_name. (\
	2018040301	; Serial\
    3h	; Refresh\
    1h	; Retry\
    1w	; Expire\
    1h	; Minimum\
)\
@       IN      NS      ns1.nation.esgi.\
@       IN      NS      ns2.nation.esgi.\
10      IN      PTR     ns1\
11      IN      PTR     ns2" > /etc/bind/db.$reverse.in-addr.arpa


echo "Configuration du serveur DNS..."


# Clear the file
echo "" > /etc/bind/named.conf.local

echo "zone \"$zone_name\" {\
	type master;\
	file \"/etc/bind/db.$zone_name\";\
	notify yes;\
	allow-transfer { $second_dns; };\
};" >> /etc/bind/named.conf.local

# Reverse DNS zone
echo "zone \"$reverse.in-addr.arpa\" {\
	type master;\
	file \"/etc/bind/db.$reverse.in-addr.arpa\";\
	notify yes;\
	allow-transfer { $second_dns; };\
};" >> /etc/bind/named.conf.local


echo "Veuillez exécuter le script sur le DNS secondaire à présent."