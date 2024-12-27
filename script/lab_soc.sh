# Instalasi snort
sudo apt update -y
sudo apt install snort -y

# Konfigurasi Snort
sudo nano /etc/snort/snort.conf

# Cari: ipvar HOME_NET
# Ubah menjadi: 
ipvar HOME_NET [192.168.1.78]

# Kemudian, tambahkan rules:
log tcp any any -> $HOME_NET any (msg:"TCP traffic to HOME_NET"; sid:1002; rev:1;)
log udp any any -> $HOME_NET any (msg:"UDP traffic to HOME_NET"; sid:1003; rev:1;)

# di snort.conf (file yang sama)

# Memulai logging
snort -v -i ens3 -l /var/log/snort
