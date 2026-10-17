# PSI Contact Atlas — 1JB0 protomer 1, P_A network
# Synechococcus elongatus · Reference · X-ray crystallography 2.5 Å
#
# Run from the repository root:   pymol downloads/pymol/1JB0_prot1_P_A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/1JB0_prot1_P_A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 1JB0, scene, type=cif
select lib_atoms, scene and ((chain A and resi 603+607+680+683+735+739+743+1011+5011))

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
set_bond stick_radius, 0.16, scene and ((chain A and resi 1011 and resn CLA))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CLA A 1011 MG ··· HIS A 680 NE2 = 2.26 Å (Mg ligand)
distance d01_mg, scene and (chain A and resi 1011 and resn CLA and name MG), scene and (chain A and resi 680 and resn HIS and name NE2)
# CLA A 1011 O1A ··· TYR A 735 OH = 2.75 Å (polar candidate)
distance d02_polar, scene and (chain A and resi 1011 and resn CLA and name O1A), scene and (chain A and resi 735 and resn TYR and name OH)
# CLA A 1011 OBD ··· THR A 743 OG1 = 2.98 Å (polar candidate)
distance d03_polar, scene and (chain A and resi 1011 and resn CLA and name OBD), scene and (chain A and resi 743 and resn THR and name OG1)
# CLA A 1011 O2D ··· THR A 743 OG1 = 3.13 Å (polar candidate)
distance d04_polar, scene and (chain A and resi 1011 and resn CLA and name O2D), scene and (chain A and resi 743 and resn THR and name OG1)
# CLA A 1011 O2D ··· TYR A 603 OH = 3.27 Å (polar candidate)
distance d05_polar, scene and (chain A and resi 1011 and resn CLA and name O2D), scene and (chain A and resi 603 and resn TYR and name OH)
# HOH A 5011 O ··· THR A 743 OG1 = 2.70 Å (water polar candidate)
distance d06_water, scene and (chain A and resi 5011 and resn HOH and name O), scene and (chain A and resi 743 and resn THR and name OG1)
# HOH A 5011 O ··· TYR A 603 OH = 2.72 Å (water polar candidate)
distance d07_water, scene and (chain A and resi 5011 and resn HOH and name O), scene and (chain A and resi 603 and resn TYR and name OH)
# HOH A 5011 O ··· SER A 607 OG = 2.89 Å (water polar candidate)
distance d08_water, scene and (chain A and resi 5011 and resn HOH and name O), scene and (chain A and resi 607 and resn SER and name OG)
# HOH A 5011 O ··· GLY A 739 O = 3.26 Å (water polar candidate)
distance d09_water, scene and (chain A and resi 5011 and resn HOH and name O), scene and (chain A and resi 739 and resn GLY and name O)
# CLA A 1011 O2D ··· HOH A 5011 O = 3.28 Å (water polar candidate)
distance d10_water, scene and (chain A and resi 1011 and resn CLA and name O2D), scene and (chain A and resi 5011 and resn HOH and name O)
# CLA A 1011 O1A ··· TRP A 683 NE1 = 3.57 Å (longer context)
distance d11_context, scene and (chain A and resi 1011 and resn CLA and name O1A), scene and (chain A and resi 683 and resn TRP and name NE1)
# CLA A 1011 OBD ··· CLA A 1011 O2D = 3.42 Å (intramolecular)
distance d12_intra, scene and (chain A and resi 1011 and resn CLA and name OBD), scene and (chain A and resi 1011 and resn CLA and name O2D)
set_color cls_mg, [0.09, 0.541, 0.235]
group Mg_ligand, d01_mg
set dash_color, cls_mg, Mg_ligand
set dash_length, 0.3, Mg_ligand
set dash_gap, 0.0, Mg_ligand
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d02_polar d03_polar d04_polar d05_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate
set_color cls_water, [0.043, 0.498, 0.612]
group water_polar_candidate, d06_water d07_water d08_water d09_water d10_water
set dash_color, cls_water, water_polar_candidate
set dash_length, 0.25, water_polar_candidate
set dash_gap, 0.18, water_polar_candidate
set_color cls_context, [0.541, 0.573, 0.612]
group longer_context, d11_context
set dash_color, cls_context, longer_context
set dash_length, 0.08, longer_context
set dash_gap, 0.3, longer_context
set_color cls_intra, [0.478, 0.322, 0.78]
group intramolecular, d12_intra
set dash_color, cls_intra, intramolecular
set dash_length, 0.3, intramolecular
set dash_gap, 0.12, intramolecular

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain A and resi 603 and resn TYR and name CA), "Tyr603 A"
label scene and (chain A and resi 607 and resn SER and name CA), "Ser607 A"
label scene and (chain A and resi 680 and resn HIS and name CA), "His680 A"
label scene and (chain A and resi 683 and resn TRP and name CA), "Trp683 A"
label scene and (chain A and resi 735 and resn TYR and name CA), "Tyr735 A"
label scene and (chain A and resi 739 and resn GLY and name CA), "Gly739 A"
label scene and (chain A and resi 743 and resn THR and name CA), "Thr743 A"
label scene and (chain A and resi 1011 and resn CLA and name MG), "PA"
label scene and (chain A and resi 5011 and resn HOH and name O), "HOH5011 A"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.149695, -0.713718, 0.684249, 0.320319, -0.689731, -0.649359, 0.935407, 0.121972, 0.331867, 0.000000, 3.474982, -127.180267, 99.335999, 121.925003, 87.514000, 107.379562, 146.980972, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
