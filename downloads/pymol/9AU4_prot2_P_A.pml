# PSI Contact Atlas — 9AU4 protomer 2, P_A network
# Synechocystis sp. PCC 6803 · MenB variant · Cryo-EM 2.03 Å
#
# Run from the repository root:   pymol downloads/pymol/9AU4_prot2_P_A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9AU4_prot2_P_A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9AU4, scene, type=cif
select lib_atoms, scene and ((chain G and resi 599+603+676+731+735+739+801+907))

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
set_bond stick_radius, 0.16, scene and ((chain G and resi 801 and resn CLA))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CLA G 801 MG ··· HIS G 676 NE2 = 2.75 Å (Mg ligand)
distance d01_mg, scene and (chain G and resi 801 and resn CLA and name MG), scene and (chain G and resi 676 and resn HIS and name NE2)
# CLA G 801 O2D ··· THR G 739 OG1 = 2.71 Å (polar candidate)
distance d02_polar, scene and (chain G and resi 801 and resn CLA and name O2D), scene and (chain G and resi 739 and resn THR and name OG1)
# CLA G 801 O1A ··· TYR G 731 OH = 2.84 Å (polar candidate)
distance d03_polar, scene and (chain G and resi 801 and resn CLA and name O1A), scene and (chain G and resi 731 and resn TYR and name OH)
# CLA G 801 OBD ··· THR G 739 OG1 = 3.19 Å (polar candidate)
distance d04_polar, scene and (chain G and resi 801 and resn CLA and name OBD), scene and (chain G and resi 739 and resn THR and name OG1)
# HOH G 907 O ··· THR G 739 OG1 = 3.00 Å (water polar candidate)
distance d05_water, scene and (chain G and resi 907 and resn HOH and name O), scene and (chain G and resi 739 and resn THR and name OG1)
# CLA G 801 O2D ··· HOH G 907 O = 3.95 Å (longer context)
distance d06_context, scene and (chain G and resi 801 and resn CLA and name O2D), scene and (chain G and resi 907 and resn HOH and name O)
# CLA G 801 O2D ··· TYR G 599 OH = 4.51 Å (longer context)
distance d07_context, scene and (chain G and resi 801 and resn CLA and name O2D), scene and (chain G and resi 599 and resn TYR and name OH)
# HOH G 907 O ··· TYR G 599 OH = 4.60 Å (longer context)
distance d08_context, scene and (chain G and resi 907 and resn HOH and name O), scene and (chain G and resi 599 and resn TYR and name OH)
# CLA G 801 OBD ··· CLA G 801 O2D = 3.34 Å (intramolecular)
distance d09_intra, scene and (chain G and resi 801 and resn CLA and name OBD), scene and (chain G and resi 801 and resn CLA and name O2D)
set_color cls_mg, [0.09, 0.541, 0.235]
group Mg_ligand, d01_mg
set dash_color, cls_mg, Mg_ligand
set dash_length, 0.3, Mg_ligand
set dash_gap, 0.0, Mg_ligand
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate
set_color cls_water, [0.043, 0.498, 0.612]
group water_polar_candidate, d05_water
set dash_color, cls_water, water_polar_candidate
set dash_length, 0.25, water_polar_candidate
set dash_gap, 0.18, water_polar_candidate
set_color cls_context, [0.541, 0.573, 0.612]
group longer_context, d06_context d07_context d08_context
set dash_color, cls_context, longer_context
set dash_length, 0.08, longer_context
set dash_gap, 0.3, longer_context
set_color cls_intra, [0.478, 0.322, 0.78]
group intramolecular, d09_intra
set dash_color, cls_intra, intramolecular
set dash_length, 0.3, intramolecular
set dash_gap, 0.12, intramolecular

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain G and resi 599 and resn TYR and name CA), "Tyr599 G"
label scene and (chain G and resi 603 and resn SER and name CA), "Ser603 G"
label scene and (chain G and resi 676 and resn HIS and name CA), "His676 G"
label scene and (chain G and resi 731 and resn TYR and name CA), "Tyr731 G"
label scene and (chain G and resi 735 and resn GLY and name CA), "Gly735 G"
label scene and (chain G and resi 739 and resn THR and name CA), "Thr739 G"
label scene and (chain G and resi 801 and resn CLA and name MG), "PA"
label scene and (chain G and resi 907 and resn HOH and name O), "HOH907 G"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.209186, 0.584153, -0.784223, -0.266035, 0.805714, 0.529198, 0.940992, 0.097930, 0.323949, 0.000000, 3.493248, -127.180267, 182.231995, 103.781998, 146.123001, 107.743057, 146.617477, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
