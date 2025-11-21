proc startlor {} {
# Procedure to start a Lorentzian model for 1pds,2pds,3rea,4ima,5pla,6coh

# save the chatter level then set to a low chatter
    set chatlevel [scan [tcloutr chatter] "%d"]
    chatter 0

query yes
xset LINECRITLEVEL 1e-10
mdefine xlor Lorentz(LineE,Width)cos(plag+3.14159265/4.0) : add
mdefine ylor Lorentz(LineE,Width)sin(plag+3.14159265/4.0) : add

puts "Starting a Lorentzian model for 1pds,2pds,3rea,4ima"
model 1:1pds lor
0.1 0.01 1e-10 1e-10
0.1 0.01 1e-10 1e-10
0.01 0.01 1e-10 1e-10

model 2:2pds lor
=1pds:p1
=1pds:p2
0.01 0.01 1e-10 1e-10

model 3:3rea xlor
=1pds:p1
=1pds:p2
0.00 0.01
0.01 0.01 1e-10 1e-10

model 4:4ima ylor
=3rea:p1
=3rea:p2
=3rea:p3
=3rea:p4

puts "Arranging plag and coherence to 1 Lor"
plags 1
cohes 1

puts "Finished starting Lorentzian model for 1 Lor."

# reset the chatter level to that on input
    chatter $chatlevel
}

proc dellor {args} {
# Procedure to delete a Lorentzian from 1pds, 2pds, 3rea, 4ima at $args[0]

# save the chatter level then set to a low chatter
    set chatlevel [scan [tcloutr chatter] "%d"]
    chatter 0

# Argument is the Lor number
set nlor [lindex $args 0]

puts "Removing Lor $nlor from 1pds,2pds,3rea,4ima"
delco 1pds:$nlor
delco 2pds:$nlor
delco 3rea:$nlor
delco 4ima:$nlor

set lors [tcloutr modcomp 1pds]

puts "Rearranging plag and coherence to $lors Lors"
plags $lors
cohes $lors

puts "Finished deleting Lor $nlor. The model has now $lors Lors."

# reset the chatter level to that on input
    chatter $chatlevel
}

proc addlor {args} {
# Procedure to add a Lorentzian to 1pds, 2pds, 3rea, 4ima at $args[0]

# save the chatter level then set to a low chatter
    set chatlevel [scan [tcloutr chatter] "%d"]
    chatter 0

# Mdefines
query yes
mdefine xlor Lorentz(LineE,Width)cos(plag+3.14159265/4.0) : add
mdefine ylor Lorentz(LineE,Width)sin(plag+3.14159265/4.0) : add

# Arguments are the Lor number, Frequency and Width
set nlor [lindex $args 0]
set freq [lindex $args 1]
set width [lindex $args 2]

puts "Adding lor $nlor to 1pds"
addco 1pds:$nlor lorentz
$freq
$width
0.01,0.01,1e-10,1e-10

puts "Adding lor $nlor to 2pds"
set p1 "=1pds:p[expr 3*($nlor-1)+1]"
set p2 "=1pds:p[expr 3*($nlor-1)+2]"
addco 2pds:$nlor lorentz
$p1
$p2
0.01,0.01,1e-10,1e-10

puts "Adding xlor $nlor to 3rea"
addco 3rea:$nlor xlor
$p1
$p2
0.00,0.01
0.01,0.01,1e-10,1e-10


puts "Adding ylor $nlor to 4ima"
set r1 "=3rea:p[expr 4*($nlor-1)+1]"
set r2 "=3rea:p[expr 4*($nlor-1)+2]"
set r3 "=3rea:p[expr 4*($nlor-1)+3]"
set r4 "=3rea:p[expr 4*($nlor-1)+4]"
addco 4ima:$nlor ylor
$r1
$r2
$r3
$r4

set lors [tcloutr modcomp 1pds]

puts "Rearranging plag and coherence to $lors Lors"
plags $lors
cohes $lors

puts "Finished adding Lor $nlor"

# reset the chatter level to that on input
    chatter $chatlevel
}


proc switchlors {args} {
# Procedure to reorder/switch Lorentzian A with Lorentzian B

# save the chatter level then set to a low chatter
    set chatlevel [scan [tcloutr chatter] "%d"]
    chatter 0

# Mdefines
query yes

# Arguments are the Lor numbers A and B
set nlorA [lindex $args 0]
set nlorB [lindex $args 1]

puts "Switching Lor $nlorA with Lor $nlorB in PDS1"
set A1 [tcloutr param 1pds:[expr 3*($nlorA-1)+1]]
set A2 [tcloutr param 1pds:[expr 3*($nlorA-1)+2]]
set A3 [tcloutr param 1pds:[expr 3*($nlorA-1)+3]]

set B1 [tcloutr param 1pds:[expr 3*($nlorB-1)+1]]
set B2 [tcloutr param 1pds:[expr 3*($nlorB-1)+2]]
set B3 [tcloutr param 1pds:[expr 3*($nlorB-1)+3]]
 
newpa 1pds:[expr 3*($nlorB-1)+1] $A1
newpa 1pds:[expr 3*($nlorB-1)+2] $A2
newpa 1pds:[expr 3*($nlorB-1)+3] $A3

newpa 1pds:[expr 3*($nlorA-1)+1] $B1
newpa 1pds:[expr 3*($nlorA-1)+2] $B2
newpa 1pds:[expr 3*($nlorA-1)+3] $B3

puts "Switching Lor $nlorA with Lor $nlorB in PDS2"
set A3 [tcloutr param 2pds:[expr 3*($nlorA-1)+3]]
set B3 [tcloutr param 2pds:[expr 3*($nlorB-1)+3]]
 
newpa 2pds:[expr 3*($nlorB-1)+3] $A3
newpa 2pds:[expr 3*($nlorA-1)+3] $B3

puts "Switching Lor $nlorA with Lor $nlorB in CDS"
set A3 [tcloutr param 3rea:[expr 4*($nlorA-1)+3]]
set A4 [tcloutr param 3rea:[expr 4*($nlorA-1)+4]]
set B3 [tcloutr param 3rea:[expr 4*($nlorB-1)+3]]
set B4 [tcloutr param 3rea:[expr 4*($nlorB-1)+4]]
 
newpa 3rea:[expr 4*($nlorB-1)+3] $A3
newpa 3rea:[expr 4*($nlorA-1)+3] $B3
newpa 3rea:[expr 4*($nlorB-1)+4] $A4
newpa 3rea:[expr 4*($nlorA-1)+4] $B4

puts "Finished switching Lor $nlorA with Lor $nlorB"

# reset the chatter level to that on input
    chatter $chatlevel
}


proc plags {args} {
# Procedure to create a PLAG model with args[0] Lorentzians

# save the chatter level then set to a low chatter
    set chatlevel [scan [tcloutr chatter] "%d"]
    chatter 0

# Argument is the number of Lors in the model
set nlor [lindex $args 0]

puts "Constructing 5pla plag model with $nlor Lors"

set num "("
set den "("

for {set i 1} {$i<=$nlor} {incr i} {
	append num "xlor(LineE$i,Width$i,plag$i)*norm$i+"
	append den "ylor(LineE$i,Width$i,plag$i)*norm$i+"
}

set pe "atan2([string range $den 0 end-1]),[string range $num 0 end-1])) - 3.14159265/4.0"

query yes
mdefine plags $pe : add

puts "Loading the 5pla plag model with $nlor Lors"
model 5:5pla plags
/*
for {set i 1} {$i<=4*$nlor} {incr i} {
	newpar 5pla:$i =3rea:p$i
}
newpar 5pla:$i 1,-1

puts "Finished adding 5pla model with $nlor Lors"

# reset the chatter level to that on input
    chatter $chatlevel
}


proc cohes {args} {
# Procedure to create a COHERENCE model with args[0] Lorentzians

# save the chatter level then set to a low chatter
    set chatlevel [scan [tcloutr chatter] "%d"]
    chatter 0

# Argument is the number of Lors in the model
set nlor [lindex $args 0]

puts "Constructing 6coh coherence model with $nlor Lors"

set re "("
set im "("
set p1 "("
set p2 "("

for {set i 1} {$i<=$nlor} {incr i} {
	append re "xlor(LineE$i,Width$i,plag$i)*norm$i+"
	append im "ylor(LineE$i,Width$i,plag$i)*norm$i+"
	append p1 "Lorentz(LineE$i,Width$i)*nn$i+"
	append p2 "Lorentz(LineE$i,Width$i)*mm$i+"
}

set pe "([string range $re 0 end-1])**2+[string range $im 0 end-1])**2)/([string range $p1 0 end-1])*[string range $p2 0 end-1]))"

query yes
mdefine coherence $pe : add

puts "Loading the 6coh coherence model with $nlor Lors"

model 6:6coh coherence
/*
for {set i 1} {$i<=4*$nlor} {incr i} {
newpar 6coh:$i =3rea:p$i
}
for {set i 1} {$i<=$nlor} {incr i} {
newpar 6coh:[expr 4*$nlor+$i] =1pds:p[expr 3*$i]
}
for {set i 1} {$i<=$nlor} {incr i} {
newpar 6coh:[expr 4*$nlor+$nlor+$i] =2pds:p[expr 3*$i]
}
newpar 6coh:[expr 4*$nlor+2*$nlor+1] 1,-1

puts "Finished adding 6coh coherence model with $nlor Lors"

# reset the chatter level to that on input
    chatter $chatlevel
}


proc LorInfo {args} {
# Procedure to print out Lor args[0] information

# save the chatter level then set to a low chatter
    set chatlevel [scan [tcloutr chatter] "%d"]
    chatter 0

query yes

# Argument is the Lor number
set nlor [lindex $args 0]

set FREQ [lindex [tcloutr param 1pds:[expr 3*($nlor-1)+1]] 0]
set FWHM [lindex [tcloutr param 1pds:[expr 3*($nlor-1)+2]] 0]
set QF [expr $FREQ/$FWHM]

puts "Quality factor = $QF"

set NORM1 [lindex [tcloutr param 1pds:[expr 3*($nlor-1)+3]] 0]
set NORM2 [lindex [tcloutr param 2pds:[expr 3*($nlor-1)+3]] 0]
set NORM3 [lindex [tcloutr param 3rea:[expr 4*($nlor-1)+4]] 0]

error 1. max 1000 1pds:[expr 3*($nlor-1)+3] 2pds:[expr 3*($nlor-1)+3] 3rea:[expr 4*($nlor-1)+4]

set SIGNIFICANCE1 [expr $NORM1 - [lindex [tcloutr error 1pds:[expr 3*($nlor-1)+3]] 0]]
set SIGNIFICANCE1 [expr $NORM1/$SIGNIFICANCE1]
set SIGNIFICANCE2 [expr $NORM2 - [lindex [tcloutr error 2pds:[expr 3*($nlor-1)+3]] 0]]
set SIGNIFICANCE2 [expr $NORM2/$SIGNIFICANCE2]
set SIGNIFICANCE3 [expr $NORM3 - [lindex [tcloutr error 3rea:[expr 4*($nlor-1)+4]] 0]]
set SIGNIFICANCE3 [expr $NORM3/$SIGNIFICANCE3]

puts "Significance in 1PDS = $SIGNIFICANCE1"
puts "Significance in 2PDS = $SIGNIFICANCE2"
puts "Significance in 3REA = $SIGNIFICANCE3"

set CLO [lindex [tcloutr error 3rea:[expr 4*($nlor-1)+4]] 0]
set CHI [lindex [tcloutr error 3rea:[expr 4*($nlor-1)+4]] 1]
set SQRTAB [expr sqrt($NORM1*$NORM2)]

puts "SQRT(A*B) = $SQRTAB"
puts "C = $NORM3 ($CLO , $CHI)"

# reset the chatter level to that on input
    chatter $chatlevel
}
