mol new ionized.psf waitfor all
mol addfile ubq_wb_eq.dcd waitfor all
set outfile [open RMSD_eq.out w]
# use frame 0 for the reference
set reference [atomselect top "protein and name CA" frame 0]
# the frame being compared
set compare [atomselect top "protein and name CA"]
set protein [atomselect top "protein"]
set num_steps [molinfo top get numframes]
for {set frame 0} {$frame < $num_steps} {incr frame} {
	# get the correct frame
	$compare frame $frame

	# compute the transformation
	set trans_mat [measure fit $compare $reference]
	# do the alignment
	$compare move $trans_mat
	# compute the RMSD
	set rmsd [measure rmsd $compare $reference]
	# print the RMSD
	puts $outfile "$frame: $rmsd"
	}
close $outfile
}
animate write pdb step1_eq_aligned.pdb beg 0 end -1 sel $protein waitfor all

 for {set i 1} {$i < 99} {incr i} { 
         [atomselect top protein frame $i] writepdb step1_eq_aligned-$i.pdb 
 } 
