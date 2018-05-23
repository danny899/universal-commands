# Universal Commands

Check the listening ports and applications on Linux:

sudo lsof -i -P -n | grep LISTEN 
sudo netstat -tulpn | grep LISTEN
sudo nmap -sTU -O IP-address-Here


Check the listening ports in Mac:

$ netstat -anp tcp | grep LISTEN
$ netstat -anp udp | grep LISTEN

