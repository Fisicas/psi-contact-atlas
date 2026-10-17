# PSI Contact Atlas — 9EYS protomer 3, P_A network
# Chroococcidiopsis thermalis PCC 7203 · FRL · Cryo-EM 2.01 Å
#
# Run from the repository root:   pymol downloads/pymol/9EYS_prot3_P_A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9EYS_prot3_P_A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9EYS, scene, type=cif
select lib_atoms, scene and ((chain a and resi 630+634+707+710+762+766+770+801+908))

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
set_bond stick_radius, 0.16, scene and ((chain a and resi 801 and resn CL0))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CL0 a 801 MG ··· HIS a 707 NE2 = 2.34 Å (Mg ligand)
distance d01_mg, scene and (chain a and resi 801 and resn CL0 and name MG), scene and (chain a and resi 707 and resn HIS and name NE2)
# CL0 a 801 OBD ··· THR a 770 OG1 = 2.85 Å (polar candidate)
distance d02_polar, scene and (chain a and resi 801 and resn CL0 and name OBD), scene and (chain a and resi 770 and resn THR and name OG1)
# CL0 a 801 O1A ··· TYR a 762 OH = 2.92 Å (polar candidate)
distance d03_polar, scene and (chain a and resi 801 and resn CL0 and name O1A), scene and (chain a and resi 762 and resn TYR and name OH)
# CL0 a 801 O2D ··· TYR a 630 OH = 3.13 Å (polar candidate)
distance d04_polar, scene and (chain a and resi 801 and resn CL0 and name O2D), scene and (chain a and resi 630 and resn TYR and name OH)
# CL0 a 801 O2D ··· THR a 770 OG1 = 3.34 Å (polar candidate)
distance d05_polar, scene and (chain a and resi 801 and resn CL0 and name O2D), scene and (chain a and resi 770 and resn THR and name OG1)
# HOH a 908 O ··· THR a 770 OG1 = 2.76 Å (water polar candidate)
distance d06_water, scene and (chain a and resi 908 and resn HOH and name O), scene and (chain a and resi 770 and resn THR and name OG1)
# HOH a 908 O ··· SER a 634 OG = 2.85 Å (water polar candidate)
distance d07_water, scene and (chain a and resi 908 and resn HOH and name O), scene and (chain a and resi 634 and resn SER and name OG)
# HOH a 908 O ··· TYR a 630 OH = 2.94 Å (water polar candidate)
distance d08_water, scene and (chain a and resi 908 and resn HOH and name O), scene and (chain a and resi 630 and resn TYR and name OH)
# CL0 a 801 O2D ··· HOH a 908 O = 3.16 Å (water polar candidate)
distance d09_water, scene and (chain a and resi 801 and resn CL0 and name O2D), scene and (chain a and resi 908 and resn HOH and name O)
# HOH a 908 O ··· GLY a 766 O = 3.39 Å (water polar candidate)
distance d10_water, scene and (chain a and resi 908 and resn HOH and name O), scene and (chain a and resi 766 and resn GLY and name O)
# CL0 a 801 O1A ··· PHE a 710 CE1 = 4.39 Å (packing)
distance d11_packing, scene and (chain a and resi 801 and resn CL0 and name O1A), scene and (chain a and resi 710 and resn PHE and name CE1)
# CL0 a 801 OBD ··· CL0 a 801 O2D = 3.67 Å (intramolecular)
distance d12_intra, scene and (chain a and resi 801 and resn CL0 and name OBD), scene and (chain a and resi 801 and resn CL0 and name O2D)
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
set_color cls_packing, [0.69, 0.404, 0.059]
group packing, d11_packing
set dash_color, cls_packing, packing
set dash_length, 0.08, packing
set dash_gap, 0.3, packing
set_color cls_intra, [0.478, 0.322, 0.78]
group intramolecular, d12_intra
set dash_color, cls_intra, intramolecular
set dash_length, 0.3, intramolecular
set dash_gap, 0.12, intramolecular

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain a and resi 630 and resn TYR and name CA), "Tyr630 a"
label scene and (chain a and resi 634 and resn SER and name CA), "Ser634 a"
label scene and (chain a and resi 707 and resn HIS and name CA), "His707 a"
label scene and (chain a and resi 710 and resn PHE and name CA), "Phe710 a"
label scene and (chain a and resi 762 and resn TYR and name CA), "Tyr762 a"
label scene and (chain a and resi 766 and resn GLY and name CA), "Gly766 a"
label scene and (chain a and resi 770 and resn THR and name CA), "Thr770 a"
label scene and (chain a and resi 801 and resn CL0 and name MG), "PA"
label scene and (chain a and resi 908 and resn HOH and name O), "HOH908 a"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.175588, -0.523909, 0.833479, -0.244829, 0.843273, 0.478487, -0.953534, -0.120043, -0.276337, 0.000000, 3.326262, -127.180267, 227.510269, 247.899704, 262.587189, 107.903564, 146.456970, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
