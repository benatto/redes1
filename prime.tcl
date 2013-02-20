if {$argc != 1} {
	puts stdeer "ERROR! Ns called with wrong number of args!($argc)"
	exit 1
} else {
	set j [lindex $argv 0]
}


proc prime {j} {
	for {set a 2} {$a <= $j} {incr a} {
		set b 0
		
		for {set i 2} {$i < $a} {incr i} {
			set d [expr fmod($a, $i)]

			if {$d==0} {
				set b 1
			}
		}
	
		if {$b==1} {
			puts "$a is not a prime number"
		} else {
			puts "$a is a prime number"
		}
	}
}

prime $j

