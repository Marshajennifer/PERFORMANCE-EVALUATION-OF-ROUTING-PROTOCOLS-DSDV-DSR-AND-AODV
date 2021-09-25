BEGIN {
received=0
send=0
routing=0
}
{
if ( $1 == "r" && $3 == "_4_" && $4 == "AGT" && $7 == "tcp" )
	received++
if ( $1 == "s" && $4 == "RTR" )
	routing++
if ( $1 == "s" && $3 == "_0_" && $4 == "AGT" && $7 == "tcp" )
	send++
a=routing/received
b=received/send
}
END {
print "Received packets= "received
print "Routing packets " routing
print "Send packets " send
print "Overhead=" a
print "Packet delivery ratio " b
}
