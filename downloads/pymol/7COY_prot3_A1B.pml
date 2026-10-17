# PSI Contact Atlas — 7COY protomer 3, A1_B quinone
# Acaryochloris marina MBIC11017 · Chl d / P740 · Cryo-EM 2.5 Å
#
# Run from the repository root:   pymol downloads/pymol/7COY_prot3_A1B.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/7COY_prot3_A1B.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 7COY, scene, type=cif
select lib_atoms, scene and ((chain cB and resi 665+666+669+674+702+703+828))

# --- style: white background, grey carbon, element colours (library palette)
bg_color white
set orthoscopic, 1
set stick_radius, 0.13
set sphere_scale, 0.25
hide everything
show sticks, lib_atoms
show spheres, lib_atoms and (elem Mg or resn HOH)
set_color lib_C, [0.5, 0.5, 0.5]
color lib_C, lib_atoms and elem C
set_color lib_N, [0.15, 0.3, 0.9]
color lib_N, lib_atoms and elem N
set_color lib_O, [1.0, 0.12, 0.12]
color lib_O, lib_atoms and elem O
set_color lib_S, [0.95, 0.8, 0.1]
color lib_S, lib_atoms and elem S
set_color lib_Mg, [0.1, 0.75, 0.25]
color lib_Mg, lib_atoms and elem MG
# cofactor(s) slightly thicker
set_bond stick_radius, 0.16, scene and ((chain cB and resi 828 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN cB 828 O4 ··· LEU cB 703 N = 2.71 Å (polar candidate)
distance d01_polar, scene and (chain cB and resi 828 and resn PQN and name O4), scene and (chain cB and resi 703 and resn LEU and name N)
# PQN cB 828 O1 ··· SER cB 669 OG = 3.02 Å (polar candidate)
distance d02_polar, scene and (chain cB and resi 828 and resn PQN and name O1), scene and (chain cB and resi 669 and resn SER and name OG)
# PQN cB 828 O1 ··· TRP cB 674 NE1 = 3.29 Å (polar candidate)
distance d03_polar, scene and (chain cB and resi 828 and resn PQN and name O1), scene and (chain cB and resi 674 and resn TRP and name NE1)
# PQN cB 828 O1 ··· LEU cB 665 O = 3.48 Å (polar candidate)
distance d04_polar, scene and (chain cB and resi 828 and resn PQN and name O1), scene and (chain cB and resi 665 and resn LEU and name O)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain cB and resi 828 and resn PQN and name C1), "A1B"
label scene and (chain cB and resi 665 and resn LEU and name CA), "Leu665 cB"
label scene and (chain cB and resi 666 and resn PHE and name CA), "Phe666 cB"
label scene and (chain cB and resi 669 and resn SER and name CA), "Ser669 cB"
label scene and (chain cB and resi 674 and resn TRP and name CA), "Trp674 cB"
label scene and (chain cB and resi 702 and resn ALA and name CA), "Ala702 cB"
label scene and (chain cB and resi 703 and resn LEU and name CA), "Leu703 cB"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.972684, -0.004593, 0.232090, 0.232134, -0.022125, 0.972432, 0.000668, 0.999745, 0.022587, 0.000000, -1.613411, -78.218079, 168.410995, 134.712997, 183.643997, 53.799000, 102.637154, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
