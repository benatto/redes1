if { $argc != 1 } {
	puts "Erro ao executar a simulação. Uso: ns bus.tcl"
	puts " \$<numero de transmissores>"

	exit
}

#Gatting transmissors count
set tcount [lindex $argv 0]

puts "Simulation started using $tcount transmissors"

#Create a new instance of NS2
set ns [new Simulator]

#Open a sim tracefile
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open a sim namfile
set namfile [open out.nam w]
$ns namtrace-all $namfile

$ns color 0 red
$ns color 2 green
$ns color 3 blue

#Create a new bus node
set bus [$ns node]

#Create a new node list(machines)
set tmachines 4
set machines(0) [$ns node]

$ns duplex-link $bus $machines(0) 10Mb 10ms DropTail

#Create all machines and connect each one to main bus
for { set i 1 } { $i <= [expr $tmachines] } { incr i } {
	#allocate a new machine
	set machines($i) [$ns node]

	#connects machine i to main bus
	$ns duplex-link $bus $machines($i) 10Mb 10ms DropTail
}

#Create traffic from any source to any destine
set dest_id 3
set src_id 1

#Set a null Agent to the dest machine
set null [new Agent/Null]
$ns attach-agent $machines([expr $dest_id-1]) $null

#Create network traffic
set udp [new Agent/UDP]
$ns attach-agent $machines([expr $src_id-1]) $udp

set cbr [new Application/Traffic/CBR]

$cbr set type_ CBR
$cbr set packet_size 512
$cbr set rate_ [expr 512 * 8 * 10]

$cbr attach-agent $udp

$ns connect $udp $null

$ns at 0 "$cbr start"

$ns at 3 "finish"

#************************************************************#
# PROC: spawn_messages									  	 #
# DESCRIPTION: spawn all messages from all SRCS to all DESTS #
# PARAMS:													 #
# 		 SRC: An array with transmissors ID's				 #
# 		 DEST: An array with destination ID's                #
#************************************************************# 		 
proc spawn_messages {SRC,DEST} {

}

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace

	close $tracefile
	close $namfile
	
	exit 1
}

$ns run
