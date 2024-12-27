echo 'auto eth0
iface eth0 inet static
        address 192.168.1.78
        netmask 255.255.255.252
        gateway 192.168.1.77
        up echo nameserver 8.8.8.8'> /etc/resolv.conf

route add -net 192.168.1.72 netmask 255.255.255.252 gw 192.168.1.77 
route add -net 192.168.1.80 netmask 255.255.255.252 gw 192.168.1.77 
route add -net 192.168.1.64 netmask 255.255.255.248 gw 192.168.1.77 
route add -net 192.168.0.0  netmask 255.255.255.0   gw 192.168.1.77 
route add -net 192.168.1.0  netmask 255.255.255.192 gw 192.168.1.77 
