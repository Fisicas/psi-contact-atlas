# PSI Contact Atlas — 6KMW protomer 3, P_A network
# Halomicronema hongdechloris C2206 · WL · Cryo-EM 2.35 Å
#
# Run from the repository root:   pymol downloads/pymol/6KMW_prot3_P_A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/6KMW_prot3_P_A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 6KMW, scene, type=cif
select lib_atoms, scene and ((chain cA and resi 612+616+689+692+744+748+752+801+912))

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
set_bond stick_radius, 0.16, scene and ((chain cA and resi 801 and resn CL0))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CL0 cA 801 MG ··· HIS cA 689 NE2 = 2.22 Å (Mg ligand)
distance d01_mg, scene and (chain cA and resi 801 and resn CL0 and name MG), scene and (chain cA and resi 689 and resn HIS and name NE2)
# CL0 cA 801 OBD ··· THR cA 752 OG1 = 3.11 Å (polar candidate)
distance d02_polar, scene and (chain cA and resi 801 and resn CL0 and name OBD), scene and (chain cA and resi 752 and resn THR and name OG1)
# CL0 cA 801 O2D ··· TYR cA 612 OH = 3.14 Å (polar candidate)
distance d03_polar, scene and (chain cA and resi 801 and resn CL0 and name O2D), scene and (chain cA and resi 612 and resn TYR and name OH)
# CL0 cA 801 O2D ··· THR cA 752 OG1 = 3.34 Å (polar candidate)
distance d04_polar, scene and (chain cA and resi 801 and resn CL0 and name O2D), scene and (chain cA and resi 752 and resn THR and name OG1)
# CL0 cA 801 O1A ··· TRP cA 692 NE1 = 3.38 Å (polar candidate)
distance d05_polar, scene and (chain cA and resi 801 and resn CL0 and name O1A), scene and (chain cA and resi 692 and resn TRP and name NE1)
# HOH cA 912 O ··· THR cA 752 OG1 = 2.51 Å (water polar candidate)
distance d06_water, scene and (chain cA and resi 912 and resn HOH and name O), scene and (chain cA and resi 752 and resn THR and name OG1)
# HOH cA 912 O ··· TYR cA 612 OH = 3.08 Å (water polar candidate)
distance d07_water, scene and (chain cA and resi 912 and resn HOH and name O), scene and (chain cA and resi 612 and resn TYR and name OH)
# HOH cA 912 O ··· GLY cA 748 O = 3.14 Å (water polar candidate)
distance d08_water, scene and (chain cA and resi 912 and resn HOH and name O), scene and (chain cA and resi 748 and resn GLY and name O)
# HOH cA 912 O ··· SER cA 616 OG = 3.23 Å (water polar candidate)
distance d09_water, scene and (chain cA and resi 912 and resn HOH and name O), scene and (chain cA and resi 616 and resn SER and name OG)
# CL0 cA 801 O2D ··· HOH cA 912 O = 3.30 Å (water polar candidate)
distance d10_water, scene and (chain cA and resi 801 and resn CL0 and name O2D), scene and (chain cA and resi 912 and resn HOH and name O)
# CL0 cA 801 O1A ··· PHE cA 744 CZ = 3.80 Å (packing)
distance d11_packing, scene and (chain cA and resi 801 and resn CL0 and name O1A), scene and (chain cA and resi 744 and resn PHE and name CZ)
# CL0 cA 801 OBD ··· CL0 cA 801 O2D = 3.66 Å (intramolecular)
distance d12_intra, scene and (chain cA and resi 801 and resn CL0 and name OBD), scene and (chain cA and resi 801 and resn CL0 and name O2D)
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
label scene and (chain cA and resi 612 and resn TYR and name CA), "Tyr612 cA"
label scene and (chain cA and resi 616 and resn SER and name CA), "Ser616 cA"
label scene and (chain cA and resi 689 and resn HIS and name CA), "His689 cA"
label scene and (chain cA and resi 692 and resn TRP and name CA), "Trp692 cA"
label scene and (chain cA and resi 744 and resn PHE and name CA), "Phe744 cA"
label scene and (chain cA and resi 748 and resn GLY and name CA), "Gly748 cA"
label scene and (chain cA and resi 752 and resn THR and name CA), "Thr752 cA"
label scene and (chain cA and resi 801 and resn CL0 and name MG), "PA"
label scene and (chain cA and resi 912 and resn HOH and name O), "HOH912 cA"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.161910, -0.974836, -0.153231, 0.260053, 0.191942, -0.946325, 0.951923, 0.113371, 0.284586, 0.000000, 3.448624, -127.180267, 165.729004, 212.945007, 172.727997, 107.578102, 146.782425, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
