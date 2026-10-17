# PSI Contact Atlas — 9I9L protomer 2, special pair
# Chroococcidiopsis thermalis PCC 7203 · FRL · Cryo-EM 1.89 Å
#
# Run from the repository root:   pymol downloads/pymol/9I9L_prot2_special_pair.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9I9L_prot2_special_pair.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9I9L, scene, type=cif
select lib_atoms, scene and ((chain N and resi 630+638+707+762+770+773+801+907) or (chain O and resi 599+661+664+723+726+727+730+801))

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
set_bond stick_radius, 0.16, scene and ((chain N and resi 801 and resn CL0) or (chain O and resi 801 and resn CLA))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CL0 N 801 MG ··· HIS N 707 NE2 = 2.37 Å (Mg ligand)
distance d01_mg, scene and (chain N and resi 801 and resn CL0 and name MG), scene and (chain N and resi 707 and resn HIS and name NE2)
# CLA O 801 MG ··· HIS O 661 NE2 = 2.53 Å (Mg ligand)
distance d02_mg, scene and (chain O and resi 801 and resn CLA and name MG), scene and (chain O and resi 661 and resn HIS and name NE2)
# CL0 N 801 OBD ··· THR N 770 OG1 = 2.89 Å (polar candidate)
distance d03_polar, scene and (chain N and resi 801 and resn CL0 and name OBD), scene and (chain N and resi 770 and resn THR and name OG1)
# CLA O 801 O1D ··· TYR O 727 N = 2.91 Å (polar candidate)
distance d04_polar, scene and (chain O and resi 801 and resn CLA and name O1D), scene and (chain O and resi 727 and resn TYR and name N)
# CL0 N 801 O1A ··· TYR N 762 OH = 2.94 Å (polar candidate)
distance d05_polar, scene and (chain N and resi 801 and resn CL0 and name O1A), scene and (chain N and resi 762 and resn TYR and name OH)
# CL0 N 801 O2D ··· TYR N 630 OH = 3.15 Å (polar candidate)
distance d06_polar, scene and (chain N and resi 801 and resn CL0 and name O2D), scene and (chain N and resi 630 and resn TYR and name OH)
# CL0 N 801 O2D ··· THR N 770 OG1 = 3.42 Å (polar candidate)
distance d07_polar, scene and (chain N and resi 801 and resn CL0 and name O2D), scene and (chain N and resi 770 and resn THR and name OG1)
# CL0 N 801 O2D ··· HOH N 907 O = 3.28 Å (water polar candidate)
distance d08_water, scene and (chain N and resi 801 and resn CL0 and name O2D), scene and (chain N and resi 907 and resn HOH and name O)
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
set_color cls_water, [0.043, 0.498, 0.612]
group water_polar_candidate, d08_water
set dash_color, cls_water, water_polar_candidate
set dash_length, 0.25, water_polar_candidate
set dash_gap, 0.18, water_polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain N and resi 907 and resn HOH and name O), "HOH907 N"
label scene and (chain N and resi 630 and resn TYR and name CA), "Tyr630 N"
label scene and (chain N and resi 638 and resn PHE and name CA), "Phe638 N"
label scene and (chain N and resi 707 and resn HIS and name CA), "His707 N"
label scene and (chain N and resi 762 and resn TYR and name CA), "Tyr762 N"
label scene and (chain N and resi 770 and resn THR and name CA), "Thr770 N"
label scene and (chain N and resi 773 and resn PHE and name CA), "Phe773 N"
label scene and (chain N and resi 801 and resn CL0 and name MG), "PA"
label scene and (chain O and resi 599 and resn PHE and name CA), "Phe599 O"
label scene and (chain O and resi 661 and resn HIS and name CA), "His661 O"
label scene and (chain O and resi 664 and resn TRP and name CA), "Trp664 O"
label scene and (chain O and resi 723 and resn TYR and name CA), "Tyr723 O"
label scene and (chain O and resi 726 and resn THR and name CA), "Thr726 O"
label scene and (chain O and resi 727 and resn TYR and name CA), "Tyr727 O"
label scene and (chain O and resi 730 and resn PHE and name CA), "Phe730 O"
label scene and (chain O and resi 801 and resn CLA and name MG), "PB"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.090956, -0.377410, 0.921569, -0.119723, -0.922837, -0.366113, 0.988632, -0.077033, -0.129122, 0.000000, -2.071138, -122.921875, 286.432007, 211.240997, 218.518997, 103.616745, 142.227005, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
