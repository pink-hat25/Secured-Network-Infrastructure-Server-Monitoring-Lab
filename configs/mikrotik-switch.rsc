# ============================================================
# Project  : Secured Network Infrastructure & Server Monitoring Lab
# Device   : MikroTik Switch
# Platform : RouterOS
# ============================================================

# ---------- Identity ----------
/system identity
set name=SWITCH

# ---------- RoMON ----------
/tool romon
set enabled=yes secrets="CHANGE_ME"

# ---------- Bridge ----------
/interface bridge
add name=bridge1 vlan-filtering=yes

# ---------- Bridge Ports ----------
/interface bridge port
add bridge=bridge1 interface=ether1
add bridge=bridge1 interface=ether2 pvid=10
add bridge=bridge1 interface=ether3 pvid=10
add bridge=bridge1 interface=ether4 pvid=20
add bridge=bridge1 interface=ether5 pvid=20
add bridge=bridge1 interface=ether6 pvid=20
add bridge=bridge1 interface=ether7 pvid=20
add bridge=bridge1 interface=ether8 pvid=30

# ---------- Bridge VLAN ----------
/interface bridge vlan
add bridge=bridge1 \
    vlan-ids=10,20,30 \
    tagged=ether1
    
untagged=ether2,ether3,ether4,ether5,ether6,ether7,ether8
