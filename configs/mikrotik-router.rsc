# ============================================================
# Project  : Secured Network Infrastructure & Server Monitoring Lab
# Device   : MikroTik Router
# Platform : RouterOS
# ============================================================

# ---------- Identity ----------
/system identity
set name=Router

# ---------- RoMON ----------
/tool romon
set enabled=yes secrets="CHANGE_ME"

# ---------- DHCP Client (WAN) ----------
/ip dhcp-client
add interface=ether1 disabled=no

# ---------- DNS ----------
/ip dns
set allow-remote-requests=yes

# ---------- VLAN Interfaces ----------
/interface vlan
add interface=ether2 name=vGuru vlan-id=10
add interface=ether2 name=vSiswa vlan-id=20
add interface=ether2 name=Server vlan-id=30

# ---------- IP Address ----------
/ip address
add address=192.168.10.1/24 interface=vGuru
add address=192.168.20.1/24 interface=vSiswa
add address=192.168.30.1/24 interface=Server

# ---------- DHCP Pools ----------
/ip pool
add name=poolGuru ranges=192.168.10.2-192.168.10.20
add name=poolSiswa ranges=192.168.20.2-192.168.20.20

# ---------- DHCP Server ----------
/ip dhcp-server
add name=dhcpGuru interface=vGuru address-pool=poolGuru disabled=no
add name=dhcpSiswa interface=vSiswa address-pool=poolSiswa disabled=no

# ---------- DHCP Network ----------
/ip dhcp-server network
add address=192.168.10.0/24 gateway=192.168.10.1 dns-server=192.168.30.10,8.8.8.8
add address=192.168.20.0/24 gateway=192.168.20.1 dns-server=192.168.30.10,8.8.8.8

# ---------- Firewall NAT ----------
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade

# ---------- Address List ----------
/ip firewall address-list
add list=blacklist address=192.168.20.20

# ---------- Interface List ----------
/interface list
add name=admin
/interface list member
add interface=vGuru list=admin

# ---------- Firewall Filter ----------
/ip firewall filter
add chain=input src-address-list=blacklist protocol=tcp dst-port=21,22 action=drop log=yes comment="Drop blacklist"
add chain=input protocol=tcp dst-port=21,22 action=add-src-to-address-list \
    address-list=blacklist address-list-timeout=2m log=yes comment="blokir IP Brute Force"
add chain=forward in-interface=vSiswa out-interface=vGuru action=drop log=yes comment="Blok Siswa ke Guru"
add chain=forward in-interface=vGuru out-interface=Server action=accept log=yes comment="Guru ke Server"
add chain=forward in-interface=vSiswa out-interface=Server protocol=tcp dst-port=22 action=drop log=yes comment="Blok SSH"
add chain=input in-interface=vSiswa protocol=tcp dst-port=8291 action=drop log=yes comment="Blok Winbox"

# ---------- Logging ----------
/system logging
add topics=account action=memory
add topics=firewall action=memory

# ---------- MAC Server ----------
/tool mac-server
set allowed-interface-list=admin

/tool mac-server mac-winbox
set allowed-interface-list=admin

# ---------- Graphing ----------
/tool graphing interface
add
