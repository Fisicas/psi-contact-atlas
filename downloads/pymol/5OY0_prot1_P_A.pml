# PSI Contact Atlas — 5OY0 protomer 1, P_A network
# Synechocystis sp. PCC 6803 · WT (paper) · X-ray crystallography 2.501 Å
#
# Run from the repository root:   pymol downloads/pymol/5OY0_prot1_P_A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/5OY0_prot1_P_A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 5OY0, scene, type=cif
select lib_atoms, scene and ((chain 1 and resi 599+603+676+679+731+735+739+1011))

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
set_bond stick_radius, 0.16, scene and ((chain 1 and resi 1011 and resn CLA))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CLA 1 1011 MG ··· HIS 1 676 NE2 = 2.94 Å (Mg ligand)
distance d01_mg, scene and (chain 1 and resi 1011 and resn CLA and name MG), scene and (chain 1 and resi 676 and resn HIS and name NE2)
# CLA 1 1011 O1A ··· TYR 1 731 OH = 2.62 Å (polar candidate)
distance d02_polar, scene and (chain 1 and resi 1011 and resn CLA and name O1A), scene and (chain 1 and resi 731 and resn TYR and name OH)
# CLA 1 1011 O2D ··· TYR 1 599 OH = 3.36 Å (polar candidate)
distance d03_polar, scene and (chain 1 and resi 1011 and resn CLA and name O2D), scene and (chain 1 and resi 599 and resn TYR and name OH)
# CLA 1 1011 OBD ··· THR 1 739 OG1 = 4.00 Å (longer context)
distance d04_context, scene and (chain 1 and resi 1011 and resn CLA and name OBD), scene and (chain 1 and resi 739 and resn THR and name OG1)
# CLA 1 1011 O2D ··· THR 1 739 OG1 = 5.21 Å (longer context)
distance d05_context, scene and (chain 1 and resi 1011 and resn CLA and name O2D), scene and (chain 1 and resi 739 and resn THR and name OG1)
# CLA 1 1011 O1A ··· PHE 1 679 CE1 = 3.91 Å (packing)
distance d06_packing, scene and (chain 1 and resi 1011 and resn CLA and name O1A), scene and (chain 1 and resi 679 and resn PHE and name CE1)
# CLA 1 1011 OBD ··· CLA 1 1011 O2D = 3.79 Å (intramolecular)
distance d07_intra, scene and (chain 1 and resi 1011 and resn CLA and name OBD), scene and (chain 1 and resi 1011 and resn CLA and name O2D)
set_color cls_mg, [0.09, 0.541, 0.235]
group Mg_ligand, d01_mg
set dash_color, cls_mg, Mg_ligand
set dash_length, 0.3, Mg_ligand
set dash_gap, 0.0, Mg_ligand
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d02_polar d03_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate
set_color cls_context, [0.541, 0.573, 0.612]
group longer_context, d04_context d05_context
set dash_color, cls_context, longer_context
set dash_length, 0.08, longer_context
set dash_gap, 0.3, longer_context
set_color cls_packing, [0.69, 0.404, 0.059]
group packing, d06_packing
set dash_color, cls_packing, packing
set dash_length, 0.08, packing
set dash_gap, 0.3, packing
set_color cls_intra, [0.478, 0.322, 0.78]
group intramolecular, d07_intra
set dash_color, cls_intra, intramolecular
set dash_length, 0.3, intramolecular
set dash_gap, 0.12, intramolecular

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain 1 and resi 599 and resn TYR and name CA), "Tyr599 1"
label scene and (chain 1 and resi 603 and resn SER and name CA), "Ser603 1"
label scene and (chain 1 and resi 676 and resn HIS and name CA), "His676 1"
label scene and (chain 1 and resi 679 and resn PHE and name CA), "Phe679 1"
label scene and (chain 1 and resi 731 and resn TYR and name CA), "Tyr731 1"
label scene and (chain 1 and resi 735 and resn GLY and name CA), "Gly735 1"
label scene and (chain 1 and resi 739 and resn THR and name CA), "Thr739 1"
label scene and (chain 1 and resi 1011 and resn CLA and name MG), "PA"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.160547, -0.298613, -0.940774, -0.983774, -0.125745, -0.127972, -0.080083, 0.946054, -0.313956, 0.000000, 3.415273, -127.180267, 202.720993, -97.734001, 47.722000, 108.032280, 146.328247, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
