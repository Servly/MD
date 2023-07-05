mol load pdb 1UBQ.pdb 
set protein [atomselect top protein]
$protein set segname A
$protein writepdb segA.pdb
package require psfgen
topology par_all36m_prot.prm
topology top_all36_prot.rtf
pdbalias residue HID HSD   
pdbalias residue HIP HSP
pdbalias residue HIS HSE
pdbalias atom ILE CD1 CD
pdbalias atom HOH O OH2
pdbalias residue HOH TIP3
foreach S {A} {
segment $S {
pdb seg$S.pdb
}
coordpdb seg$S.pdb $S
regenerate angles dihedrals
}
guesscoord
writepdb 1UBQ_ready.pdb
writepsf 1UBQ_ready.psf
package require solvate
solvate 1UBQ_ready.psf 1UBQ_ready.pdb -t 12 -o 1UBQ_ready_wb
package require autoionize
autoionize -psf 1UBQ_ready_wb.psf -pdb 1UBQ_ready_wb.pdb -neutralize -o ionized
exit
