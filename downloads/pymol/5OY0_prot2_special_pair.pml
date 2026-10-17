# PSI Contact Atlas — 5OY0 protomer 2, special pair
# Synechocystis sp. PCC 6803 · WT (paper) · X-ray crystallography 2.501 Å
#
# Run from the repository root:   pymol downloads/pymol/5OY0_prot2_special_pair.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/5OY0_prot2_special_pair.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 5OY0, scene, type=cif
select lib_atoms, scene and ((chain A and resi 599+607+676+679+731+739+742+1011+8111) or (chain B and resi 651+654+714+717+718+721+1021))

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
set_bond stick_radius, 0.16, scene and ((chain A and resi 1011 and resn CLA) or (chain B and resi 1021 and resn CLA))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CLA A 1011 MG ··· HIS A 676 NE2 = 2.81 Å (Mg ligand)
distance d01_mg, scene and (chain A and resi 1011 and resn CLA and name MG), scene and (chain A and resi 676 and resn HIS and name NE2)
# CLA B 1021 MG ··· HIS B 651 NE2 = 2.89 Å (Mg ligand)
distance d02_mg, scene and (chain B and resi 1021 and resn CLA and name MG), scene and (chain B and resi 651 and resn HIS and name NE2)
# CLA A 1011 O1A ··· TYR A 731 OH = 2.59 Å (polar candidate)
distance d03_polar, scene and (chain A and resi 1011 and resn CLA and name O1A), scene and (chain A and resi 731 and resn TYR and name OH)
# CLA A 1011 O2D ··· THR A 739 OG1 = 2.92 Å (polar candidate)
distance d04_polar, scene and (chain A and resi 1011 and resn CLA and name O2D), scene and (chain A and resi 739 and resn THR and name OG1)
# CLA A 1011 OBD ··· THR A 739 OG1 = 3.08 Å (polar candidate)
distance d05_polar, scene and (chain A and resi 1011 and resn CLA and name OBD), scene and (chain A and resi 739 and resn THR and name OG1)
# CLA B 1021 O1D ··· TYR B 718 N = 3.12 Å (polar candidate)
distance d06_polar, scene and (chain B and resi 1021 and resn CLA and name O1D), scene and (chain B and resi 718 and resn TYR and name N)
# CLA B 1021 O2A ··· TYR B 714 OH = 3.33 Å (polar candidate)
distance d07_polar, scene and (chain B and resi 1021 and resn CLA and name O2A), scene and (chain B and resi 714 and resn TYR and name OH)
# CLA A 1011 O2D ··· HOH A 8111 O = 4.03 Å (longer context)
distance d08_context, scene and (chain A and resi 1011 and resn CLA and name O2D), scene and (chain A and resi 8111 and resn HOH and name O)
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
group longer_context, d08_context
set dash_color, cls_context, longer_context
set dash_length, 0.08, longer_context
set dash_gap, 0.3, longer_context

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain A and resi 599 and resn TYR and name CA), "Tyr599 A"
label scene and (chain A and resi 607 and resn PHE and name CA), "Phe607 A"
label scene and (chain A and resi 676 and resn HIS and name CA), "His676 A"
label scene and (chain A and resi 679 and resn PHE and name CA), "Phe679 A"
label scene and (chain A and resi 731 and resn TYR and name CA), "Tyr731 A"
label scene and (chain A and resi 739 and resn THR and name CA), "Thr739 A"
label scene and (chain A and resi 742 and resn PHE and name CA), "Phe742 A"
label scene and (chain A and resi 1011 and resn CLA and name MG), "PA"
label scene and (chain A and resi 8111 and resn HOH and name O), "HOH8111 A"
label scene and (chain B and resi 651 and resn HIS and name CA), "His651 B"
label scene and (chain B and resi 654 and resn TRP and name CA), "Trp654 B"
label scene and (chain B and resi 714 and resn TYR and name CA), "Tyr714 B"
label scene and (chain B and resi 717 and resn THR and name CA), "Thr717 B"
label scene and (chain B and resi 718 and resn TYR and name CA), "Tyr718 B"
label scene and (chain B and resi 721 and resn PHE and name CA), "Phe721 B"
label scene and (chain B and resi 1021 and resn CLA and name MG), "PB"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.329795, 0.940337, -0.083676, 0.856587, -0.260803, 0.445242, 0.396855, -0.218514, -0.891492, 0.000000, -2.073315, -128.687576, 136.550995, -80.652000, -25.659000, 108.711449, 148.663696, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
