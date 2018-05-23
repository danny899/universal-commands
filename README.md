# Universal Commands

<h3>Check the listening ports and applications on Linux:</h3>

<blockquote>
sudo lsof -i -P -n | grep LISTEN  <br/>
sudo netstat -tulpn | grep LISTEN <br/>
sudo nmap -sTU -O IP-address-Here <br/>
</blockquote>


<h3>Check the listening ports in Mac:</h3>
<blockquote>
$ netstat -anp tcp | grep LISTEN <br/>
$ netstat -anp udp | grep LISTEN <br/>
</blockquote>
