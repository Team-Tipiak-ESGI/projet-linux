read -p "Test de la zone actuelle. Entrez le nom de la zone : " zone

cd /etc/bind
named-checkzone $zone db.$zone

# Internet lookup
dig google.com

# Cache lookup
dig google.com

# Self name resolution
nslookup ns1.$zone

# Reverse name resolution
nslookup $(hostname -I)