# PSI Contact Atlas — 6KMW protomer 2, P_A network
# Halomicronema hongdechloris C2206 · WL · Cryo-EM 2.35 Å
#
# Run from the repository root:   pymol downloads/pymol/6KMW_prot2_P_A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/6KMW_prot2_P_A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 6KMW, scene, type=cif
select lib_atoms, scene and ((chain bA and resi 612+616+689+692+744+748+752+801+916))

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
set_bond stick_radius, 0.16, scene and ((chain bA and resi 801 and resn CL0))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CL0 bA 801 MG ··· HIS bA 689 NE2 = 2.22 Å (Mg ligand)
distance d01_mg, scene and (chain bA and resi 801 and resn CL0 and name MG), scene and (chain bA and resi 689 and resn HIS and name NE2)
# CL0 bA 801 OBD ··· THR bA 752 OG1 = 3.11 Å (polar candidate)
distance d02_polar, scene and (chain bA and resi 801 and resn CL0 and name OBD), scene and (chain bA and resi 752 and resn THR and name OG1)
# CL0 bA 801 O2D ··· TYR bA 612 OH = 3.14 Å (polar candidate)
distance d03_polar, scene and (chain bA and resi 801 and resn CL0 and name O2D), scene and (chain bA and resi 612 and resn TYR and name OH)
# CL0 bA 801 O2D ··· THR bA 752 OG1 = 3.34 Å (polar candidate)
distance d04_polar, scene and (chain bA and resi 801 and resn CL0 and name O2D), scene and (chain bA and resi 752 and resn THR and name OG1)
# CL0 bA 801 O1A ··· TRP bA 692 NE1 = 3.38 Å (polar candidate)
distance d05_polar, scene and (chain bA and resi 801 and resn CL0 and name O1A), scene and (chain bA and resi 692 and resn TRP and name NE1)
# HOH bA 916 O ··· THR bA 752 OG1 = 2.55 Å (water polar candidate)
distance d06_water, scene and (chain bA and resi 916 and resn HOH and name O), scene and (chain bA and resi 752 and resn THR and name OG1)
# HOH bA 916 O ··· GLY bA 748 O = 3.13 Å (water polar candidate)
distance d07_water, scene and (chain bA and resi 916 and resn HOH and name O), scene and (chain bA and resi 748 and resn GLY and name O)
# HOH bA 916 O ··· TYR bA 612 OH = 3.14 Å (water polar candidate)
distance d08_water, scene and (chain bA and resi 916 and resn HOH and name O), scene and (chain bA and resi 612 and resn TYR and name OH)
# HOH bA 916 O ··· SER bA 616 OG = 3.26 Å (water polar candidate)
distance d09_water, scene and (chain bA and resi 916 and resn HOH and name O), scene and (chain bA and resi 616 and resn SER and name OG)
# CL0 bA 801 O2D ··· HOH bA 916 O = 3.44 Å (water polar candidate)
distance d10_water, scene and (chain bA and resi 801 and resn CL0 and name O2D), scene and (chain bA and resi 916 and resn HOH and name O)
# CL0 bA 801 O1A ··· PHE bA 744 CZ = 3.80 Å (packing)
distance d11_packing, scene and (chain bA and resi 801 and resn CL0 and name O1A), scene and (chain bA and resi 744 and resn PHE and name CZ)
# CL0 bA 801 OBD ··· CL0 bA 801 O2D = 3.66 Å (intramolecular)
distance d12_intra, scene and (chain bA and resi 801 and resn CL0 and name OBD), scene and (chain bA and resi 801 and resn CL0 and name O2D)
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
label scene and (chain bA and resi 612 and resn TYR and name CA), "Tyr612 bA"
label scene and (chain bA and resi 616 and resn SER and name CA), "Ser616 bA"
label scene and (chain bA and resi 689 and resn HIS and name CA), "His689 bA"
label scene and (chain bA and resi 692 and resn TRP and name CA), "Trp692 bA"
label scene and (chain bA and resi 744 and resn PHE and name CA), "Phe744 bA"
label scene and (chain bA and resi 748 and resn GLY and name CA), "Gly748 bA"
label scene and (chain bA and resi 752 and resn THR and name CA), "Thr752 bA"
label scene and (chain bA and resi 801 and resn CL0 and name MG), "PA"
label scene and (chain bA and resi 916 and resn HOH and name O), "HOH916 bA"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.143942, 0.653436, -0.743171, -0.268650, 0.748591, 0.606167, 0.952422, 0.112400, 0.283299, 0.000000, 3.448222, -127.180267, 200.815002, 120.615997, 172.807999, 107.578979, 146.781555, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
