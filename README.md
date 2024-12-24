# Final Project Keamanan Jaringan Komputer

## Anggota Kelompok 4

| Nama                            | NRP        |
| ------------------------------- | ---------- |
| Aqila Aqsa                      | 5027211032 |
| Tridiktya Hardani Putra         | 5027211049 |
| Samuel Yuma Krismata            | 5027221029 |
| Jacinta Syilloam                | 5027221036 |
| Muhammad Harvian Dito Syahputra | 5027221039 |

## Deskripsi Tugas

Teknologi Informasi memiliki sebuah jaringan komputer dengan detail sebagai berikut:

-   1 buah server di lantai 6 gedung perpustakaan. dalam server ini memiliki web service yang bisa diakses dari internal network.
-   di lantai 7, memiliki 4 ruang kelas dengan fasilitas wifi, dengan kapasitas masing 40 mahasiswa.
-   di lantai 9, memiliki 2 ruang lab, yang terdiri dari 25 komputer (lab 1) dan 25 komputer (lab 2) dengan koneksi ethernet. selain itu juga memiliki konektivitas wifi.
-   semua jaringan terhubung oleh router utama (backbone) yang diletakkan di gedung riset center di DPTSI.

## Pengerjaan

Pengerjaan dilakukan dengan menggunakan software [GNS3](https://www.gns3.com/).

### Topologi

![Topologi](https://github.com/user-attachments/assets/f29f0a92-3457-4f14-acdd-8116563040c2)

### Rute dan Area Subnet

| Nama Subnet | Rute                                                                  | Jumlah IP | Netmask |
| ----------- | --------------------------------------------------------------------- | --------- | ------- |
| A1          | DPTSI > Perpustakaan                                                  | 2         | /30     |
| A2          | Perpustakaan > Switch 1 > WebService                                  | 2         | /30     |
| A3          | DPTSI > TW2                                                           | 2         | /30     |
| A4          | TW2 >Switch2 > Lantai7 > Switch2 > Lantai9                            | 3         | /29     |
| A5          | Lantai7 > Switch3 > 702 > Switch3 > 703 > Switch2 > 704 Switch3 > 705 | 161       | /24     |
| A6          | Lantai9 > Switch4 > LabSOC > Switch4 > LabKCKS                        | 51        | /26     |

### Pembagian IP

| Subnet | Network ID   | Netmask         | Broadcast     | Range IP                    |
| ------ | ------------ | --------------- | ------------- | --------------------------- |
| A1     | 192.168.1.72 | 255.255.255.252 | 192.168.1.75  | 192.168.1.73 - 192.168.1.74 |
| A2     | 192.168.1.76 | 255.255.255.252 | 192.168.1.79  | 192.168.1.77 - 192.168.1.78 |
| A3     | 192.168.1.80 | 255.255.255.252 | 192.168.1.83  | 192.168.1.81 - 192.168.1.82 |
| A4     | 192.168.1.64 | 255.255.255.248 | 192.168.1.71  | 192.168.1.65 - 192.168.1.70 |
| A5     | 192.168.0.0  | 255.255.255.0   | 192.168.0.255 | 192.168.0.1 - 192.168.0.254 |
| A6     | 192.168.1.0  | 255.255.255.192 | 192.168.1.63  | 192.168.1.1 - 192.168.1.62  |

### Konfigurasi Jaringan

**DPTSI**

```bash
enable
configure terminal

interface f1/0 # A1 (Perpustakaan)
 ip address 192.168.1.73 255.255.255.252
 no shutdown

interface f2/0 # A3 (TW2)
 ip address 192.168.1.81 255.255.255.252
 no shutdown

ip route 192.168.1.76 255.255.255.252 192.168.1.74 # Ke A2 (via Perpustakaan)
ip route 192.168.1.64 255.255.255.248 192.168.1.82 # Ke A4 (via TW2)
ip route 192.168.0.0 255.255.255.0 192.168.1.82   # Ke A5 (via TW2)
ip route 192.168.1.0 255.255.255.192 192.168.1.82 # Ke A6 (via TW2)
```

**Perpustakaan**

```bash
enable
configure terminal

interface f0/0 # A1 (DPTSI)
 ip address 192.168.1.74 255.255.255.252
 no shutdown

interface f1/0 # A2 (WebService via Switch1)
 ip address 192.168.1.77 255.255.255.252
 no shutdown

ip route 0.0.0.0 0.0.0.0 192.168.1.73 # Default ke DPTSI
ip route 192.168.1.64 255.255.255.248 192.168.1.73 # Ke A4 (via DPTSI)
ip route 192.168.0.0 255.255.255.128 192.168.1.73   # Ke A5 (via DPTSI)
ip route 192.168.1.0 255.255.255.192 192.168.1.73 # Ke A6 (via DPTSI)
```

**TW2**

```bash
enable
configure terminal

interface f0/0 # A3 (DPTSI)
 ip address 192.168.1.82 255.255.255.252
 no shutdown

interface f1/0 # A4 (Lantai7 & Lantai9 via Switch2)
 ip address 192.168.1.65 255.255.255.248
 no shutdown

ip route 0.0.0.0 0.0.0.0 192.168.1.81 # Default ke DPTSI
ip route 192.168.1.72 255.255.255.252 192.168.1.81 # Ke A1 (via DPTSI)
ip route 192.168.1.76 255.255.255.252 192.168.1.81 # Ke A2 (via DPTSI)
```

**Lantai7**

```bash
enable
configure terminal

interface f0/0 # A4 (TW2)
 ip address 192.168.1.66 255.255.255.248
 no shutdown

interface f1/0 # A5 (Kelas 702-705 via Switch3)
 ip address 192.168.0.1 255.255.255.0
 no shutdown

ip route 0.0.0.0 0.0.0.0 192.168.1.65 # Default ke TW2
ip route 192.168.1.72 255.255.255.252 192.168.1.65 # Ke A1 (via TW2)
ip route 192.168.1.76 255.255.255.252 192.168.1.65 # Ke A2 (via TW2)
ip route 192.168.1.0 255.255.255.192 192.168.1.65 # Ke A6 (via TW2)
```

**Lantai9**

```bash
enable
configure terminal

interface f0/0 # A4 (TW2)
 ip address 192.168.1.67 255.255.255.248
 no shutdown

interface f1/0 # A6 (Lab via Switch4)
 ip address 192.168.1.2 255.255.255.192
 no shutdown

ip route 0.0.0.0 0.0.0.0 192.168.1.65 # Default ke TW2
ip route 192.168.1.72 255.255.255.252 192.168.1.65 # Ke A1 (via TW2)
ip route 192.168.1.76 255.255.255.252 192.168.1.65 # Ke A2 (via TW2)
ip route 192.168.0.0 255.255.255.0 192.168.1.65 # Ke A5 (via TW2)
```

**WebService**

```bash
auto eth0
iface eth0 inet static
        address 192.168.1.78
        netmask 255.255.255.252
        gateway 192.168.1.77
        up echo nameserver 8.8.8.8 > /etc/resolv.conf
```

IP Route

```bash
route add -net 192.168.1.72 netmask 255.255.255.252 gw 192.168.1.77 # A1
route add -net 192.168.1.80 netmask 255.255.255.252 gw 192.168.1.77 # A3
route add -net 192.168.1.64 netmask 255.255.255.248 gw 192.168.1.77 # A4
route add -net 192.168.0.0  netmask 255.255.255.0   gw 192.168.1.77 # A5
route add -net 192.168.1.0  netmask 255.255.255.192 gw 192.168.1.77 # A6
```

**702**

Config

```bash
auto eth0
iface eth0 inet static
        address 192.168.0.2
        netmask 255.255.255.0
        gateway 192.168.0.1
        up echo nameserver 8.8.8.8 > /etc/resolv.conf
```

IP Route

```bash
route add -net 192.168.1.72 netmask 255.255.255.252 gw 192.168.0.1 # A1
route add -net 192.168.1.76 netmask 255.255.255.252 gw 192.168.0.1 # A2
route add -net 192.168.1.80 netmask 255.255.255.252 gw 192.168.0.1 # A3
route add -net 192.168.1.64 netmask 255.255.255.248 gw 192.168.0.1 # A4
route add -net 192.168.1.0  netmask 255.255.255.192 gw 192.168.0.1 # A6
```

**703**

Config

```bash
auto eth0
iface eth0 inet static
        address 192.168.0.3
        netmask 255.255.255.0
        gateway 192.168.0.1
        up echo nameserver 8.8.8.8 > /etc/resolv.conf
```

IP Route

```bash
route add -net 192.168.1.72 netmask 255.255.255.252 gw 192.168.0.1 # A1
route add -net 192.168.1.76 netmask 255.255.255.252 gw 192.168.0.1 # A2
route add -net 192.168.1.80 netmask 255.255.255.252 gw 192.168.0.1 # A3
route add -net 192.168.1.64 netmask 255.255.255.248 gw 192.168.0.1 # A4
route add -net 192.168.1.0  netmask 255.255.255.192 gw 192.168.0.1 # A6
```

**704**

Config

```bash
auto eth0
iface eth0 inet static
        address 192.168.0.4
        netmask 255.255.255.0
        gateway 192.168.0.1
        up echo nameserver 8.8.8.8 > /etc/resolv.conf
```

IP Route

```bash
route add -net 192.168.1.72 netmask 255.255.255.252 gw 192.168.0.1 # A1
route add -net 192.168.1.76 netmask 255.255.255.252 gw 192.168.0.1 # A2
route add -net 192.168.1.80 netmask 255.255.255.252 gw 192.168.0.1 # A3
route add -net 192.168.1.64 netmask 255.255.255.248 gw 192.168.0.1 # A4
route add -net 192.168.1.0  netmask 255.255.255.192 gw 192.168.0.1 # A6
```

**705**

Config

```bash
auto eth0
iface eth0 inet static
        address 192.168.0.5
        netmask 255.255.255.0
        gateway 192.168.0.1
        up echo nameserver 8.8.8.8 > /etc/resolv.conf
```

IP Route

```bash
route add -net 192.168.1.72 netmask 255.255.255.252 gw 192.168.0.1 # A1
route add -net 192.168.1.76 netmask 255.255.255.252 gw 192.168.0.1 # A2
route add -net 192.168.1.80 netmask 255.255.255.252 gw 192.168.0.1 # A3
route add -net 192.168.1.64 netmask 255.255.255.248 gw 192.168.0.1 # A4
route add -net 192.168.1.0  netmask 255.255.255.192 gw 192.168.0.1 # A6
```

**LabSOC**

Config

```bash
auto eth0
iface eth0 inet static
        address 192.168.1.3
        netmask 255.255.255.192
        gateway 192.168.1.2
		up echo nameserver 8.8.8.8 > /etc/resolv.conf
```

IP Route

```bash
route add -net 192.168.1.72 netmask 255.255.255.252 gw 192.168.1.2 # A1
route add -net 192.168.1.76 netmask 255.255.255.252 gw 192.168.1.2 # A2
route add -net 192.168.1.80 netmask 255.255.255.252 gw 192.168.1.2 # A3
route add -net 192.168.1.64 netmask 255.255.255.248 gw 192.168.1.2 # A4
route add -net 192.168.0.0  netmask 255.255.255.0   gw 192.168.1.2 # A5
```

**LabKCKS**

Config

```bash
auto eth0
iface eth0 inet static
        address 192.168.1.4
        netmask 255.255.255.192
        gateway 192.168.1.2
		up echo nameserver 8.8.8.8 > /etc/resolv.conf
```

IP Route

```bash
route add -net 192.168.1.72 netmask 255.255.255.252 gw 192.168.1.2 # A1
route add -net 192.168.1.76 netmask 255.255.255.252 gw 192.168.1.2 # A2
route add -net 192.168.1.80 netmask 255.255.255.252 gw 192.168.1.2 # A3
route add -net 192.168.1.64 netmask 255.255.255.248 gw 192.168.1.2 # A4
route add -net 192.168.0.0  netmask 255.255.255.0   gw 192.168.1.2 # A5
```
