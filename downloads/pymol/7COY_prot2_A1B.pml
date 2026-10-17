# PSI Contact Atlas — 7COY protomer 2, A1_B quinone
# Acaryochloris marina MBIC11017 · Chl d / P740 · Cryo-EM 2.5 Å
#
# Run from the repository root:   pymol downloads/pymol/7COY_prot2_A1B.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/7COY_prot2_A1B.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 7COY, scene, type=cif
select lib_atoms, scene and ((chain bB and resi 665+666+669+674+702+703+828))

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
set_bond stick_radius, 0.16, scene and ((chain bB and resi 828 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN bB 828 O4 ··· LEU bB 703 N = 2.70 Å (polar candidate)
distance d01_polar, scene and (chain bB and resi 828 and resn PQN and name O4), scene and (chain bB and resi 703 and resn LEU and name N)
# PQN bB 828 O1 ··· SER bB 669 OG = 3.02 Å (polar candidate)
distance d02_polar, scene and (chain bB and resi 828 and resn PQN and name O1), scene and (chain bB and resi 669 and resn SER and name OG)
# PQN bB 828 O1 ··· TRP bB 674 NE1 = 3.29 Å (polar candidate)
distance d03_polar, scene and (chain bB and resi 828 and resn PQN and name O1), scene and (chain bB and resi 674 and resn TRP and name NE1)
# PQN bB 828 O1 ··· LEU bB 665 O = 3.47 Å (polar candidate)
distance d04_polar, scene and (chain bB and resi 828 and resn PQN and name O1), scene and (chain bB and resi 665 and resn LEU and name O)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain bB and resi 665 and resn LEU and name CA), "Leu665 bB"
label scene and (chain bB and resi 666 and resn PHE and name CA), "Phe666 bB"
label scene and (chain bB and resi 669 and resn SER and name CA), "Ser669 bB"
label scene and (chain bB and resi 674 and resn TRP and name CA), "Trp674 bB"
label scene and (chain bB and resi 702 and resn ALA and name CA), "Ala702 bB"
label scene and (chain bB and resi 703 and resn LEU and name CA), "Leu703 bB"
label scene and (chain bB and resi 828 and resn PQN and name C1), "A1B"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.283790, 0.020906, -0.958658, -0.958881, 0.009433, -0.283651, 0.003113, 0.999737, 0.022723, 0.000000, -1.562830, -78.283897, 220.811005, 191.436996, 183.688995, 53.848484, 102.719322, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
