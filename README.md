# Universal Commands

<h3>Check the listening ports and applications on Linux:</h3>

<blockquote>
sudo lsof -i -P -n | grep LISTEN 
sudo netstat -tulpn | grep LISTEN
sudo nmap -sTU -O IP-address-Here
</blockquote>


<h3>Check the listening ports in Mac:</h3>
<blockquote>
$ netstat -anp tcp | grep LISTEN
$ netstat -anp udp | grep LISTEN
</blockquote>
