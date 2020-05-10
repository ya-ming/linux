#!/bin/bash

gcc root_hack3.c ../common.c -o root_hack3.out
sudo chown root root_hack3.out
sudo chmod u+s root_hack3.out
./root_hack3.out

### Output
# RUID=1000 EUID=0
# RGID=1000 EGID=1000
#
# RUID=1000 EUID=1000
# RGID=1000 EGID=1000

# RUID=1000 EUID=0
# RGID=1000 EGID=1000
#
# E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)
# E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), are you root?
#
# RUID=0 EUID=0
# RGID=1000 EGID=1000
#
# Reading package lists... Done
# Building dependency tree       
# Reading state information... Done
#
# RUID=1000 EUID=1000
# RGID=1000 EGID=1000