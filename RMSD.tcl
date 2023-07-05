# Prints the RMSD of the protein atoms between each timestep
# and the first timestep for the given molecule id (default: top)
proc print_rmsd_through_time {{mol top}} {
                
	set outfile [open RMSD_A7Y_ligand_1ms.out w]
	# use frame 0 for the reference
        set reference [atomselect $mol "protein and name CA" frame 0]
        # the frame being compared
        set compare [atomselect $mol "protein and name CA"]

        set num_steps [molinfo $mol get numframes]
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
