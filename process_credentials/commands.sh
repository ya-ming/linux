#!/bin/bash

function exec_cmd {
  echo "exec: $1"
  $1
}

echo "####################"

####################
# Query user's information
# exec_cmd "grep osboxes /etc/passwd"  
exec_cmd "grep osboxes /etc/passwd"
echo "####################"
# username:<passwd>:UID :GID :descriptive_name:home_dir     :program
# osboxes :x       :1000:1000:osboxes.org,,,  :/home/osboxes:/bin/bash
# End

####################
# ps
exec_cmd "ps"
echo "####################"
#  PID TTY          TIME CMD
# 5195 pts/2    00:00:00 bash
# 6742 pts/2    00:00:00 ps
# End

####################
# id
exec_cmd "id"
echo "####################"
# uid=1000(osboxes) gid=1000(osboxes) groups=1000(osboxes),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),119(lpadmin),131(lxd),132(sambashare)
# End

####################
# stat
exec_cmd "stat commands.sh"
echo "####################"
#  File: commands.sh
#  Size: 892             Blocks: 8          IO Block: 4096   regular file
#Device: 804h/2052d      Inode: 7345871     Links: 1
#Access: (0777/-rwxrwxrwx)  Uid: ( 1000/ osboxes)   Gid: ( 1000/ osboxes)
#Access: 2020-05-08 21:40:01.847168506 -0500
#Modify: 2020-05-08 21:39:55.315168237 -0500
#Change: 2020-05-08 21:39:55.315168237 -0500
# Birth: -
# End

####################
# ls -l myfile
exec_cmd "ls -l myfile"
echo "####################"
# -rw-r--r-- 1 osboxes osboxes 184 May  8 20:52 myfile
# End

####################
# /etc/shadow
exec_cmd "ls -l /etc/shadow"
echo "####################"
# -rw-r----- 1 root shadow 1402 Apr  9 23:12 /etc/shadow
# End

####################
# /usr/bin/passwd - setuid-root binary
exec_cmd "ls -l /usr/bin/passwd"
echo "####################"
# -rwsr-xr-x 1 root root 67992 Aug 29  2019 /usr/bin/passwd
# End

####################
# Setting the setuid and setgid bits with chmod
exec_cmd "gcc hello.c -o hello.out"
exec_cmd "./hello.out"
exec_cmd "ls -l hello.out"
exec_cmd "chmod u+s hello.out"
exec_cmd "ls -l hello.out"
exec_cmd "chmod u-s,g+s hello.out"
exec_cmd "ls -l hello.out"
exec_cmd "chmod g-s hello.out"
exec_cmd "ls -l hello.out"
echo "####################"
#hello
#-rwxr-xr-x 1 osboxes osboxes 16696 May  9 20:32 hello.out
#-rwsr-xr-x 1 osboxes osboxes 16696 May  9 20:32 hello.out
#-rwxr-sr-x 1 osboxes osboxes 16696 May  9 20:32 hello.out
#-rwxr-xr-x 1 osboxes osboxes 16696 May  9 20:32 hello.out
## End

####################
# Hacking attempt 1
exec_cmd "gcc rootsh_hack1.c -o rootsh_hack1.out"
exec_cmd "ls -l rootsh_hack1.out"
exec_cmd "./rootsh_hack1.out"
# enter id -u
# enter exit
exec_cmd "chmod u+s rootsh_hack1.out"
exec_cmd "ls -l rootsh_hack1.out"
exec_cmd "./rootsh_hack1.out"
# enter id -u
# enter exit

# change file owner from user to root
# try again to elevate the privilege
# it won't work because of security concerns
exec_cmd "sudo chown root rootsh_hack1.out"
# set setuid bit again
exec_cmd "sudo chmod u+s rootsh_hack1.out"
exec_cmd "ls -l rootsh_hack1.out"
exec_cmd "./rootsh_hack1.out"
# enter id -u
# enter exit
echo "####################"
# End

####################
# Querying the process credentials
exec_cmd "gcc query_creds.c -o query_creds.out"
exec_cmd "./query_creds.out"
exec_cmd "sudo ./query_creds.out"
### sudo, yet another setuid-root program
exec_cmd "ls -l /usr/bin/sudo"
echo "####################"
#exec: gcc query_creds.c -o query_creds.out
#exec: ./query_creds.out
#RUID=1000 EUID=1000
#RGID=1000 EGID=1000
#exec: sudo ./query_creds.out
#RUID=0 EUID=0
#RGID=0 EGID=0
#./query_creds.out now effectively running as root! ...
#exec: ls -l /usr/bin/sudo
#-rwsr-xr-x 1 root root 161448 Jan 31 11:07 /usr/bin/sudo
# End

####################
# Setting the process credentials
exec_cmd "id"
exec_cmd "sudo id"
exec_cmd "gcc rootsh_hack2.c ../common.c -o rootsh_hack2.out"
exec_cmd "ps"
exec_cmd "./rootsh_hack2.out"
# enter id -u
# enter ps
# enter exit

# change the owner of the file to root
# set setuid bit to make it a setuid-root executable
exec_cmd "ls -l rootsh_hack2.out"
exec_cmd "sudo chown root rootsh_hack2.out"
exec_cmd "sudo chmod u+s rootsh_hack2.out"
exec_cmd "ls -l rootsh_hack2.out"
exec_cmd "./rootsh_hack2.out"
# enter id -u
# enter ps
# enter exit
echo "####################"
# End

####################
# Saved-set UID – a quick demo
exec_cmd "gcc savedset_demo.c ../common.c -o savedset_demo.out"
# change the owner of the file to root
# set setuid bit to make it a setuid-root executable
exec_cmd "ls -l savedset_demo.out"
exec_cmd "sudo chown root savedset_demo.out"
exec_cmd "sudo chmod u+s savedset_demo.out"
exec_cmd "ls -l savedset_demo.out"
exec_cmd "./savedset_demo.out"
# enter id -u
# enter ps
# enter exit
echo "####################"
# End

####################
# trace system calls to setuid, setreuid, and setresuid
exec_cmd "id"
exec_cmd "sudo strace -e trace=setuid,setreuid,setresuid sudo -u mail id"
echo "####################"
# End