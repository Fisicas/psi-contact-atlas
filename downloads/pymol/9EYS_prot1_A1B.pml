# PSI Contact Atlas — 9EYS protomer 1, A1_B quinone
# Chroococcidiopsis thermalis PCC 7203 · FRL · Cryo-EM 2.01 Å
#
# Run from the repository root:   pymol downloads/pymol/9EYS_prot1_A1B.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9EYS_prot1_A1B.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9EYS, scene, type=cif
select lib_atoms, scene and ((chain B and resi 669+670+673+678+705+706+840))

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
set_bond stick_radius, 0.16, scene and ((chain B and resi 840 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN B 840 O4 ··· LEU B 706 N = 2.98 Å (polar candidate)
distance d01_polar, scene and (chain B and resi 840 and resn PQN and name O4), scene and (chain B and resi 706 and resn LEU and name N)
# PQN B 840 O1 ··· MET B 669 O = 3.08 Å (polar candidate)
distance d02_polar, scene and (chain B and resi 840 and resn PQN and name O1), scene and (chain B and resi 669 and resn MET and name O)
# PQN B 840 O1 ··· THR B 673 OG1 = 3.22 Å (polar candidate)
distance d03_polar, scene and (chain B and resi 840 and resn PQN and name O1), scene and (chain B and resi 673 and resn THR and name OG1)
# PQN B 840 O1 ··· TRP B 678 NE1 = 3.33 Å (polar candidate)
distance d04_polar, scene and (chain B and resi 840 and resn PQN and name O1), scene and (chain B and resi 678 and resn TRP and name NE1)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain B and resi 669 and resn MET and name CA), "Met669 B"
label scene and (chain B and resi 670 and resn PHE and name CA), "Phe670 B"
label scene and (chain B and resi 673 and resn THR and name CA), "Thr673 B"
label scene and (chain B and resi 678 and resn TRP and name CA), "Trp678 B"
label scene and (chain B and resi 705 and resn ALA and name CA), "Ala705 B"
label scene and (chain B and resi 706 and resn LEU and name CA), "Leu706 B"
label scene and (chain B and resi 840 and resn PQN and name C1), "A1B"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.510651, 0.098265, -0.854155, -0.846933, 0.113660, 0.519409, 0.148123, 0.988648, 0.025183, 0.000000, -1.207737, -67.454132, 315.346008, 253.565994, 282.574005, 45.707401, 89.200859, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
