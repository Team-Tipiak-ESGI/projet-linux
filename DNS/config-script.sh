# check if the userID is (ne) not equal to root, if yes then exit failure
if [ "$EUID" -ne 0 ]; then
	echo "Vous n'êtes pas en super utilisateur !" >&2
	echo "Abandon..." >&2
	exit 0
fi

inquire() {
	while true; do
	read -p "$1 [y/n] " yn
	case $yn in
		[Yy]* ) return 1;;
		[Nn]* ) return 0;;
		* ) echo "Veuillez entrer y ou n.";;
	esac
done
}

ip -4 -o addr

line=$(ip -4 -o addr | head -2 | tail -1)
interface=$(echo $line | tr -s ' ' | cut -d ' ' -f 2)
address=$(hostname -I)
netmask=$(echo $line | tr -s ' ' | cut -d ' ' -f 6)

if inquire "L'interface $interface est-elle correcte ?"; then
	read -p "Indiquez l'interface réseau à utiliser : " interface
fi
if inquire "L'adresse $address est-elle correcte ?"; then
	read -p "Indiquez l'adresse du serveur actuel : " address
fi
read -p "Indiquez le masque du réseau : " netmask
read -p "Indiquez la passerelle : " gateway
read -p "Indiquez le nom de votre zone DNS : " zone_name
read -p "Indiquez l'adresse du serveur DNS de réplication : " second_dns
read -p "Indiquez le type du serveur [master/slave] : " type

# Reverse network address
IFS='.' read -ra SDNS <<< "$second_dns"

IFS='.' read -ra ADDR <<< "$address"
IFS='.' read -ra MASK <<< "$netmask"
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


# check if network card is already configured
conf=$(cat /etc/network/interfaces | grep "iface ens33 inet static" | wc -l)

if [ $conf -eq 0 ]; then
	echo "Configuration des interfaces réseau..."

	echo "allow-hotplug $interface
	iface $interface inet static
		address $address
		netmask $netmask
		gateway $gateway
		dns-nameservers 127.0.0.1" >> /etc/network/interfaces
fi


# Clear the file
echo "" > /etc/resolv.conf

echo "domain localdomain
search localdomain
nameserver 127.0.0.1" >> /etc/resolv.conf


echo "Configuration de la zone DNS..."

# Create the main DNS zone file
touch /etc/bind/db.$zone_name

echo "\$TTL 604800
@	IN	SOA	$zone_name.	admin.$zone_name. (
	2018040301	; Serial
	3h	; Refresh
	1h	; Retry
	1w	; Expire
	1h	; Minimum
)
@       IN      NS      ns1.$zone_name.
ns1     IN      A       $address
@       IN      NS      ns2.$zone_name.
ns2     IN      A       $second_dns" > /etc/bind/db.$zone_name


# Create the reverse DNS zone file
touch /etc/bind/db.$reverse.in-addr.arpa

echo "\$TTL 604800
@	IN	SOA	$zone_name.	admin.$zone_name. (
	2018040301	; Serial
	3h	; Refresh
	1h	; Retry
	1w	; Expire
	1h	; Minimum
)
@       IN      NS      ns1.nation.esgi.
@       IN      NS      ns2.nation.esgi.
${ADDR[3]}      IN      PTR     ns1
${SDNS[3]}      IN      PTR     ns2" > /etc/bind/db.$reverse.in-addr.arpa


echo "Configuration du serveur DNS..."


# Clear the file
echo "" > /etc/bind/named.conf.local

echo "zone \"$zone_name\" {
	type $type;
	file \"/etc/bind/db.$zone_name\";
	notify yes;
	allow-transfer { $second_dns; };
};" >> /etc/bind/named.conf.local

# Reverse DNS zone
echo "zone \"$reverse.in-addr.arpa\" {
	type $type;
	file \"/etc/bind/db.$reverse.in-addr.arpa\";
	notify yes;
	allow-transfer { $second_dns; };
};" >> /etc/bind/named.conf.local

echo "options {
	directory \"/var/cache/bind\";

	forwarders {
		1.1.1.1;
	};

	dnssec-validation auto;

	listen-on-v6 { any; };

	allow-query {
		localhost;
		$network/24;
	};

	recursion yes;
};" > /etc/bind/named.conf.options


echo "Veuillez exécuter le script sur le DNS secondaire à présent."
echo "Redémarrage des services."

# Restart bind9
systemctl restart bind9

# Restart networking
/etc/init.d/networking restart

