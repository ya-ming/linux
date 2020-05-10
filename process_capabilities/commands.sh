#!/bin/bash

function exec_cmd {
  echo "exec: $1"
  $1
}

echo "####################"

####################
# Viewing process capabilities via procfs
exec_cmd "grep -i cap /proc/self/status"
exec_cmd "sudo grep -i cap /proc/self/status"
echo "####################"
#CapInh: 0000000000000000
#CapPrm: 0000000000000000
#CapEff: 0000000000000000
#CapBnd: 0000003fffffffff
#CapAmb: 0000000000000000
#
#CapInh: 0000000000000000
#CapPrm: 0000003fffffffff
#CapEff: 0000003fffffffff
#CapBnd: 0000003fffffffff
#CapAmb: 0000000000000000
# End

####################
# Embedding capabilities into a program binary
exec_cmd "gcc hello_pause.c -o hello_pause.out"
exec_cmd "gcc query_pcap.c ../common.c -o query_pcap.out -lcap"
exec_cmd "./query_pcap.out 1"
#exec_cmd "./hello_pause.out &"
#exec_cmd "./query_pcap.out 24313"
exec_cmd "sudo setcap cap_net_admin,cap_net_raw+ep ./hello_pause.out"
#exec_cmd "./hello_pause.out &"
#exec_cmd "./query_pcap.out 24313"
echo "####################"
#[1] 24313
#Process  24313 : capabilities are: =
#
# After setting capabilities
#
#[1] 24486
#Process  24486 : capabilities are: = cap_net_admin,cap_net_raw+ep
# End

####################
# Embedding capabilities into a program binary
exec_cmd "getcap /bin/bash"
exec_cmd "getcap /usr/bin/ping"
exec_cmd "getcap ./hello_pause.out"
echo "####################"
#/usr/bin/ping = cap_net_raw+ep
#./hello_pause.out = cap_net_admin,cap_net_raw+ep
# End

####################
# Setting capabilities programmatically
exec_cmd "gcc set_pcap.c ../common.c -o set_pcap.out -lcap"
exec_cmd "sudo setcap cap_setuid,cap_sys_admin+ep ./set_pcap.out"
#exec_cmd "./set_pcap.out 2 &"
#exec_cmd "./query_pcap.out 25441"
#exec_cmd "grep -i cap /proc/25441/status"
#
#exec_cmd "kill %1"
#
#exec_cmd "./query_pcap.out 25441"
#exec_cmd "grep -i cap /proc/25441/status"
#
#exec_cmd "kill %1"
echo "####################"
#[2] 25441
#Process  25441 : capabilities are: = cap_setuid,cap_sys_admin+ep
#Name:   set_pcap.out
#CapInh: 0000000000000000
#CapPrm: 0000000000200080
#CapEff: 0000000000200080
#CapBnd: 0000003fffffffff
#CapAmb: 0000000000000000
#
# kill %1
#
#*(boing!)*
#test_setuid:
#RUID = 1000 EUID = 1000
#RUID = 1000 EUID = 0
#Now dropping all capabilities and reverting to original self...
#test_setuid:
#RUID = 1000 EUID = 1000
#!WARNING! set_pcap.c:test_setuid:28: seteuid(0) failed...
#  kernel says: Operation not permitted
#RUID = 1000 EUID = 1000
#Pasuing #2 ...
#
# query pcaps again
#
#Process  25441 : capabilities are: =
#Name:   set_pcap.out
#CapInh: 0000000000000000
#CapPrm: 0000000000000000
#CapEff: 0000000000000000
#CapBnd: 0000003fffffffff
#CapAmb: 0000000000000000
# End

####################
# Setting capabilities programmatically 2
# 3 rounds switching ruid/euid between normal user and root
# Requires 'prctl(PR_SET_KEEPCAPS, 1, 0, 0, 0)' to keep the capabilities
#     Otherwise, the capabilities are lost after UID transition.
exec_cmd "gcc set_pcap2.c ../common.c -o set_pcap2.out -lcap"
exec_cmd "sudo setcap cap_setuid,cap_sys_admin+ep ./set_pcap2.out"
#execmd "./set_pcap2.out &"
# End