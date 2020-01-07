# Two Virtual Machines in different VNets

## Description
This is a very simple deployment which consists of two virtual machines placed in different VNet in the same region. Virtual machines can communicate with each other despite being placed in different VNet b means of establishing VNet peering.

## Deployment through Terraform
Update the variables in the terraform_github.tfvars with valid credentials and rename the file to terraform.tfvars.

## Network Diagram
![](02-two_vm_different_vnet.PNG)

## Access to Virtual Machines
Virtual machines are accessible with public key authentication for user azureuser. Such a setup with exposing the public addresses to the internet is nor recommended though it maybe useful for testing scenarios i.e. for NSG etc. when virtual machines are not connected to on-premise through VPN or Express routes. 
The public key is stored as a variable pubkey defined in the [variables.tf](variables.tf).  

## Tips&Tricks
If the public IP addresses are not shown in the terraform output in the first go then try *terraform refresh* to have them displayed in the CLI.
Example.
```shell
Outputs:

ubuntu_vm-01_public_ip = 13.73.230.122
ubuntu_vm-02_public_ip = 13.93.70.237
```

Ping from the ubuntu-vm-02 to ubuntu-vm-01
```shell
azureuser@ubuntu-vm-02:~⟫ ping 10.1.0.4
PING 10.1.0.4 (10.1.0.4) 56(84) bytes of data.
64 bytes from 10.1.0.4: icmp_seq=1 ttl=64 time=2.02 ms
64 bytes from 10.1.0.4: icmp_seq=2 ttl=64 time=2.07 ms
64 bytes from 10.1.0.4: icmp_seq=3 ttl=64 time=1.90 ms
^C
--- 10.1.0.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 1.906/2.002/2.073/0.070 ms
azureuser@ubuntu-vm-02:~⟫
```
