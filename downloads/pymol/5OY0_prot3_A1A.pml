# PSI Contact Atlas — 5OY0 protomer 3, A1_A quinone
# Synechocystis sp. PCC 6803 · WT (paper) · X-ray crystallography 2.501 Å
#
# Run from the repository root:   pymol downloads/pymol/5OY0_prot3_A1A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/5OY0_prot3_A1A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 5OY0, scene, type=cif
select lib_atoms, scene and ((chain a and resi 684+685+688+693+717+718+2001))

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
set_bond stick_radius, 0.16, scene and ((chain a and resi 2001 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN a 2001 O4 ··· LEU a 718 N = 2.73 Å (polar candidate)
distance d01_polar, scene and (chain a and resi 2001 and resn PQN and name O4), scene and (chain a and resi 718 and resn LEU and name N)
# PQN a 2001 O1 ··· TRP a 693 NE1 = 3.31 Å (polar candidate)
distance d02_polar, scene and (chain a and resi 2001 and resn PQN and name O1), scene and (chain a and resi 693 and resn TRP and name NE1)
# PQN a 2001 O1 ··· MET a 684 O = 3.47 Å (polar candidate)
distance d03_polar, scene and (chain a and resi 2001 and resn PQN and name O1), scene and (chain a and resi 684 and resn MET and name O)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain a and resi 684 and resn MET and name CA), "Met684 a"
label scene and (chain a and resi 685 and resn PHE and name CA), "Phe685 a"
label scene and (chain a and resi 688 and resn SER and name CA), "Ser688 a"
label scene and (chain a and resi 693 and resn TRP and name CA), "Trp693 a"
label scene and (chain a and resi 717 and resn ALA and name CA), "Ala717 a"
label scene and (chain a and resi 718 and resn LEU and name CA), "Leu718 a"
label scene and (chain a and resi 2001 and resn PQN and name C1), "A1A"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.627899, 0.232651, -0.742709, -0.216338, 0.968842, 0.120591, 0.747624, 0.084957, 0.658666, 0.000000, -1.352268, -73.749237, 102.413002, -61.231998, 70.852997, 50.439632, 97.058838, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
