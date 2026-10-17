# PSI Contact Atlas — 9AU4 protomer 3, special pair
# Synechocystis sp. PCC 6803 · MenB variant · Cryo-EM 2.03 Å
#
# Run from the repository root:   pymol downloads/pymol/9AU4_prot3_special_pair.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9AU4_prot3_special_pair.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9AU4, scene, type=cif
select lib_atoms, scene and ((chain a and resi 599+603+607+676+731+735+739+742+801+907) or (chain b and resi 589+651+654+710+714+717+718+721+2103+2239))

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
set_bond stick_radius, 0.16, scene and ((chain a and resi 801 and resn CLA) or (chain b and resi 2103 and resn CLA))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CLA a 801 MG ··· HIS a 676 NE2 = 2.75 Å (Mg ligand)
distance d01_mg, scene and (chain a and resi 801 and resn CLA and name MG), scene and (chain a and resi 676 and resn HIS and name NE2)
# CLA b 2103 MG ··· HIS b 651 NE2 = 2.80 Å (Mg ligand)
distance d02_mg, scene and (chain b and resi 2103 and resn CLA and name MG), scene and (chain b and resi 651 and resn HIS and name NE2)
# CLA a 801 O2D ··· THR a 739 OG1 = 2.71 Å (polar candidate)
distance d03_polar, scene and (chain a and resi 801 and resn CLA and name O2D), scene and (chain a and resi 739 and resn THR and name OG1)
# CLA a 801 O1A ··· TYR a 731 OH = 2.84 Å (polar candidate)
distance d04_polar, scene and (chain a and resi 801 and resn CLA and name O1A), scene and (chain a and resi 731 and resn TYR and name OH)
# CLA b 2103 O1D ··· TYR b 718 N = 2.98 Å (polar candidate)
distance d05_polar, scene and (chain b and resi 2103 and resn CLA and name O1D), scene and (chain b and resi 718 and resn TYR and name N)
# CLA a 801 OBD ··· THR a 739 OG1 = 3.19 Å (polar candidate)
distance d06_polar, scene and (chain a and resi 801 and resn CLA and name OBD), scene and (chain a and resi 739 and resn THR and name OG1)
# CLA b 2103 O1A ··· TRP b 654 NE1 = 3.41 Å (polar candidate)
distance d07_polar, scene and (chain b and resi 2103 and resn CLA and name O1A), scene and (chain b and resi 654 and resn TRP and name NE1)
# CLA a 801 O1D ··· HOH a 907 O = 3.92 Å (longer context)
distance d08_context, scene and (chain a and resi 801 and resn CLA and name O1D), scene and (chain a and resi 907 and resn HOH and name O)
# CLA b 2103 O2D ··· HOH b 2239 O = 4.98 Å (longer context)
distance d09_context, scene and (chain b and resi 2103 and resn CLA and name O2D), scene and (chain b and resi 2239 and resn HOH and name O)
set_color cls_mg, [0.09, 0.541, 0.235]
group Mg_ligand, d01_mg d02_mg
set dash_color, cls_mg, Mg_ligand
set dash_length, 0.3, Mg_ligand
set dash_gap, 0.0, Mg_ligand
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d03_polar d04_polar d05_polar d06_polar d07_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate
set_color cls_context, [0.541, 0.573, 0.612]
group longer_context, d08_context d09_context
set dash_color, cls_context, longer_context
set dash_length, 0.08, longer_context
set dash_gap, 0.3, longer_context

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain a and resi 907 and resn HOH and name O), "HOH907 a"
label scene and (chain a and resi 599 and resn TYR and name CA), "Tyr599 a"
label scene and (chain a and resi 603 and resn SER and name CA), "Ser603 a"
label scene and (chain a and resi 607 and resn PHE and name CA), "Phe607 a"
label scene and (chain a and resi 676 and resn HIS and name CA), "His676 a"
label scene and (chain a and resi 731 and resn TYR and name CA), "Tyr731 a"
label scene and (chain a and resi 735 and resn GLY and name CA), "Gly735 a"
label scene and (chain a and resi 739 and resn THR and name CA), "Thr739 a"
label scene and (chain a and resi 742 and resn PHE and name CA), "Phe742 a"
label scene and (chain a and resi 801 and resn CLA and name MG), "PA"
label scene and (chain b and resi 589 and resn PHE and name CA), "Phe589 b"
label scene and (chain b and resi 651 and resn HIS and name CA), "His651 b"
label scene and (chain b and resi 654 and resn TRP and name CA), "Trp654 b"
label scene and (chain b and resi 710 and resn PHE and name CA), "Phe710 b"
label scene and (chain b and resi 714 and resn TYR and name CA), "Tyr714 b"
label scene and (chain b and resi 717 and resn THR and name CA), "Thr717 b"
label scene and (chain b and resi 718 and resn TYR and name CA), "Tyr718 b"
label scene and (chain b and resi 721 and resn PHE and name CA), "Phe721 b"
label scene and (chain b and resi 2103 and resn CLA and name MG), "PB"
label scene and (chain b and resi 2239 and resn HOH and name O), "HOH2239 b"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.011385, -0.998247, -0.058074, -0.625764, 0.038186, -0.779077, 0.779929, 0.045210, -0.624233, 0.000000, -1.870266, -140.928513, 133.972000, 190.326004, 146.115005, 119.527840, 162.329178, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
