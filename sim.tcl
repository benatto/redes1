set ns [new Simulator]

#Opening trace files
set tf1 [open out.tr w]
$ns trace-all $tf1

#Oepning the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns queue-limit $n0 $n1 20

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink

$ns connect $tcp $sink

$tcp set fid_ 1
$tcp set packetSize_ 552

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.1 "$ftp start"
$ns at 10.0 "$ftp stop"

proc finish {} {
	global ns tracefile1 namfile
	$ns flush-trace
	close $tf1
	close $namfile
	exec nam out.nam &
	
	exit 0
}
