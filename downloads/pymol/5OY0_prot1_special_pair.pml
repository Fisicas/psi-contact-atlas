# PSI Contact Atlas — 5OY0 protomer 1, special pair
# Synechocystis sp. PCC 6803 · WT (paper) · X-ray crystallography 2.501 Å
#
# Run from the repository root:   pymol downloads/pymol/5OY0_prot1_special_pair.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/5OY0_prot1_special_pair.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 5OY0, scene, type=cif
select lib_atoms, scene and ((chain 2 and resi 651+654+714+717+718+721+1021) or (chain 1 and resi 599+607+676+731+735+738+739+742+1011))

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
set_bond stick_radius, 0.16, scene and ((chain 2 and resi 1021 and resn CLA) or (chain 1 and resi 1011 and resn CLA))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CLA 1 1011 MG ··· HIS 1 676 NE2 = 2.94 Å (Mg ligand)
distance d01_mg, scene and (chain 1 and resi 1011 and resn CLA and name MG), scene and (chain 1 and resi 676 and resn HIS and name NE2)
# CLA 2 1021 MG ··· HIS 2 651 NE2 = 2.97 Å (Mg ligand)
distance d02_mg, scene and (chain 2 and resi 1021 and resn CLA and name MG), scene and (chain 2 and resi 651 and resn HIS and name NE2)
# CLA 1 1011 O1A ··· TYR 1 731 OH = 2.62 Å (polar candidate)
distance d03_polar, scene and (chain 1 and resi 1011 and resn CLA and name O1A), scene and (chain 1 and resi 731 and resn TYR and name OH)
# CLA 2 1021 O2A ··· TYR 2 714 OH = 3.05 Å (polar candidate)
distance d04_polar, scene and (chain 2 and resi 1021 and resn CLA and name O2A), scene and (chain 2 and resi 714 and resn TYR and name OH)
# CLA 1 1011 O2A ··· TYR 1 599 OH = 3.10 Å (polar candidate)
distance d05_polar, scene and (chain 1 and resi 1011 and resn CLA and name O2A), scene and (chain 1 and resi 599 and resn TYR and name OH)
# CLA 2 1021 O1D ··· TYR 2 718 N = 3.17 Å (polar candidate)
distance d06_polar, scene and (chain 2 and resi 1021 and resn CLA and name O1D), scene and (chain 2 and resi 718 and resn TYR and name N)
# CLA 1 1011 O1D ··· GLY 1 735 O = 3.17 Å (polar candidate)
distance d07_polar, scene and (chain 1 and resi 1011 and resn CLA and name O1D), scene and (chain 1 and resi 735 and resn GLY and name O)
# CLA 1 1011 O2D ··· TYR 1 599 OH = 3.36 Å (polar candidate)
distance d08_polar, scene and (chain 1 and resi 1011 and resn CLA and name O2D), scene and (chain 1 and resi 599 and resn TYR and name OH)
# CLA 1 1011 O1D ··· THR 1 739 N = 3.40 Å (polar candidate)
distance d09_polar, scene and (chain 1 and resi 1011 and resn CLA and name O1D), scene and (chain 1 and resi 739 and resn THR and name N)
set_color cls_mg, [0.09, 0.541, 0.235]
group Mg_ligand, d01_mg d02_mg
set dash_color, cls_mg, Mg_ligand
set dash_length, 0.3, Mg_ligand
set dash_gap, 0.0, Mg_ligand
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d03_polar d04_polar d05_polar d06_polar d07_polar d08_polar d09_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain 2 and resi 1021 and resn CLA and name MG), "PB"
label scene and (chain 2 and resi 651 and resn HIS and name CA), "His651 2"
label scene and (chain 2 and resi 654 and resn TRP and name CA), "Trp654 2"
label scene and (chain 2 and resi 714 and resn TYR and name CA), "Tyr714 2"
label scene and (chain 2 and resi 717 and resn THR and name CA), "Thr717 2"
label scene and (chain 2 and resi 718 and resn TYR and name CA), "Tyr718 2"
label scene and (chain 2 and resi 721 and resn PHE and name CA), "Phe721 2"
label scene and (chain 1 and resi 599 and resn TYR and name CA), "Tyr599 1"
label scene and (chain 1 and resi 607 and resn PHE and name CA), "Phe607 1"
label scene and (chain 1 and resi 676 and resn HIS and name CA), "His676 1"
label scene and (chain 1 and resi 731 and resn TYR and name CA), "Tyr731 1"
label scene and (chain 1 and resi 735 and resn GLY and name CA), "Gly735 1"
label scene and (chain 1 and resi 738 and resn THR and name CA), "Thr738 1"
label scene and (chain 1 and resi 739 and resn THR and name CA), "Thr739 1"
label scene and (chain 1 and resi 742 and resn PHE and name CA), "Phe742 1"
label scene and (chain 1 and resi 1011 and resn CLA and name MG), "PA"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.144457, -0.375806, 0.915370, 0.981542, -0.062744, -0.180659, 0.125327, 0.924572, 0.359805, 0.000000, -2.090225, -130.798355, 202.720993, -97.734001, 47.722000, 110.576591, 151.020111, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
