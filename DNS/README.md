**Configuration des machines pour l'exemple :**  
DNS 1 : `192.168.232.10`  
DNS 2 : `192.168.232.11`  
Client 1 : `192.168.232.20`  
Client 2 : `192.168.232.21`

# Config serveur 1 (append)

**Installer les paquets :**
`apt install bind9 bind9utils bind9-doc dnsutils`

**Configurer l'interface avec ip statique :**
`/etc/network/interface`

```
auto ens36
iface ens36 inet static
	address 192.168.232.10
	netmask 255.255.255.0
	gateway 192.168.232.2
	dns-nameservers 127.0.0.1
```

`/etc/resolv.conf`

```
domain localdomain
search localdomain
nameserver 127.0.0.1
```

**Configurer la zone DNS :**
`/etc/bind/db.nation.esgi`

```
$TTL 604800
@	IN	SOA	nation.esgi. admin.nation.esgi. (
	2018040301 ; Serial
	3h	; Refresh
	1h	; Retry
	1w	; Expire
	1h	; Minimum
)

@	IN	NS	ns1.nation.esgi.
ns1	IN	A	192.168.232.10

@	IN	NS	ns2.nation.esgi.
ns2	IN	A	192.168.232.11

client1 IN	A	192.168.232.20
client2 IN	A	192.168.232.21
```

**Configuration de la zone reverse :**
`/etc/bind/db.232.168.192.in-addr.arpa`

```
$TTL 604800
@	IN	SOA	nation.esgi. admin.nation.esgi. (
	2018040301 ; Serial
	3h	; Refresh
	1h	; Retry
	1w	; Expire
	1h	; Minimum
)

@	IN	NS	ns1.nation.esgi.
10	IN	PTR	ns1
11	IN	PTR	ns2
20	IN	PTR	client1
21	IN	PTR	client2
```

**Tester les zones :**  
`named-checkzone nation.esgi db.nation.esgi`  
`named-checkzone 232.168.192.in-addr.arpa db.232.168.192.in-addr.arpa`

`/etc/bind/named.conf.local`

```
zone "nation.esgi" {
	type master;
	file "/etc/bind/db.nation.esgi";
		notify yes;
		allow-transfer { 192.168.232.11; };
};

zone "232.168.192.in-addr.arpa" {
	type master;
	file "/etc/bind/db.232.168.192.in-addr.arpa";
		notify yes;
		allow-transfer { 192.168.232.11; };
};
```

**Configuration de bind9 :**
`/etc/bind/named.conf.options`
```
options {
	directory "/var/cache/bind";

	forwarders {
		// Utiliser le DNS de CloudFlare pour les recherches sur internet
		1.1.1.1;
	};

	dnssec-validation auto;

	listen-on-v6 { any; };

	allow-query {
		localhost;
		192.168.232.0/24;
	};

	recursion yes;
};
```

**Redémarer bind9 :**
`systemctl restart bind9`

`/etc/dhcp/dhclient.conf`

```
supersede domain-name-servers 127.0.0.1;
```

**Configuration du serveur de réplication :**
`/etc/bind/named.conf.local`

```
zone "nation.esgi" {
	type slave;
	masters { 192.168.232.10; };
	masterfile-format text;
	file "/var/lib/bind/db.nation.esgi";
};

zone "232.168.192.in-addr.arpa" {
	type slave;
	masters { 192.168.232.10; };
	masterfile-format text;
	file "/var/lib/bind/db.232.168.192.in-addr.arpa";
};
```