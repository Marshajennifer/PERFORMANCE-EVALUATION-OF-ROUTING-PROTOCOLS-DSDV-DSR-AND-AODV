set opt(chan) Channel/WirelessChannel ;
set opt(prop) Propagation/TwoRayGround ; 
set opt(netif) Phy/WirelessPhy ;
set opt(mac) Mac/802_11 ;
#normally  set opt(ifq) Queue/DropTail/PriQueue ;but for DSR it is different.
set opt(ifq) CMUPriQueue ;
set opt(ll) LL ;
set opt(ant) Antenna/OmniAntenna ;
set opt(ifqlen) 50 ;
set opt(adhocRouting) DSR;


set ns [new Simulator]
set dsr [lindex [split [info script] "."] 0]
set tracefd [open $dsr.tr w]
set namtrace [open $dsr.nam w]
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace 650 400
set topo [new Topography]


#set ns [new Simulator]
#set name [lindex [split [info script] "."] 0]
#set tracefile [open $name.tr w]
#$ns trace-all $tracefile
#set namfile [open $name.nam w]
#$ns namtrace-all-wireless $namfile 650 400 #wireless

set topo [new Topography]
$topo load_flatgrid 650 400
create-god 4

set chan1 [new $opt(chan)]
$ns node-config -adhocRouting $opt(adhocRouting) \
		-llType $opt(ll) \
		-macType $opt(mac) \
		-ifqType $opt(ifq) \
		-ifqLen $opt(ifqlen) \
		-antType $opt(ant) \
		-propType $opt(prop) \
		-phyType $opt(netif) \
		-channel $chan1 \
		-topoInstance $topo \
		-wiredRouting OFF \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace OFF
#node creation
#for {set i 0} {$i < 4} {incr i} {
#set node($i) [$ns node]
#$node($i) set Z_ 0
#}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]


$n0 set X_ 000
$n0 set Y_ 200
$n0 set Z_ 0

$n1 set X_ 140
$n1 set Y_ 000
$n1 set Z_ 0

$n2 set X_ 280
$n2 set Y_ 200
$n2 set Z_ 0

$n3 set X_ 420
$n3 set Y_ 000
$n3 set Z_ 0

$n4 set X_ 560
$n4 set Y_ 200
$n4 set Z_ 0

set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n0 $tcp
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set packetsize_ 500
$tcp set interval_ 0.005
$tcp set class_ Blue


set ftp [new Application/FTP]
$ftp attach-agent $tcp


$ns initial_node_pos $n0 20
$ns initial_node_pos $n1 20
$ns initial_node_pos $n2 20
$ns initial_node_pos $n3 20
$ns initial_node_pos $n4 20

$ns at 10.0 "$n0 setdest 05.0 9.0 3"
$ns at 50.0 "$n0 setdest 10.0 0.1.0 5"
$ns at 10.0 "$n1 setdest 50.0 90.0 3"
$ns at 50.0 "$n1 setdest 50.0 15.0 5"
$ns at 10.0 "$n2 setdest 50.0 9.0 3"
$ns at 50.0 "$n2 setdest 70.0 30.0 5"
$ns at 10.0 "$n3 setdest 25.0 65.0 3"
$ns at 50.0 "$n3 setdest 9.0 65.0 3"
$ns at 10.0 "$n4 setdest 15.0 48.0 3"
$ns at 50.0 "$n4 setdest 75.0 34.0 3"

$ns at 0.5 "$ftp start"
$ns at 100 "$ftp stop"
$ns at 101 "finish"


proc finish {} {
#extra name variable
	global ns tracefd namtrace dsr
	$ns flush-trace
	close $tracefd
	close $namtrace
	exec nam $dsr.nam &
	exec awk -f exp8.awk $dsr.tr > dsr.dat &
	exit 0
}
$ns run



































