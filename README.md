# Linux System Programming

Based on book "Hands-on System Programming with Linux"

## Process Credentials

Execute the following script to evaluate the commands and output

```sh
cd process_credentials
./commands.sh
./show_setuidgid.sh
./root_hack3.sh
```

## Process Capabilities

Execute the following script to evaluate the commands and output

**In set_pcap2.c, by default, capability sets are lost across an UID transition, use prctl(PR_SET_KEEPCAPS, 1, 0, 0, 0); to keep it.**

```sh
cd process_capabilities
./commands.sh
```