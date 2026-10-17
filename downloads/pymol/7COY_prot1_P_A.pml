# PSI Contact Atlas — 7COY protomer 1, P_A network
# Acaryochloris marina MBIC11017 · Chl d / P740 · Cryo-EM 2.5 Å
#
# Run from the repository root:   pymol downloads/pymol/7COY_prot1_P_A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/7COY_prot1_P_A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 7COY, scene, type=cif
select lib_atoms, scene and ((chain aA and resi 601+605+678+681+733+737+741+3101+3210))

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
set_bond stick_radius, 0.16, scene and ((chain aA and resi 3101 and resn G9R))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# G9R aA 3101 MG ··· HIS aA 678 NE2 = 2.06 Å (Mg ligand)
distance d01_mg, scene and (chain aA and resi 3101 and resn G9R and name MG), scene and (chain aA and resi 678 and resn HIS and name NE2)
# G9R aA 3101 O1A ··· TYR aA 733 OH = 2.54 Å (polar candidate)
distance d02_polar, scene and (chain aA and resi 3101 and resn G9R and name O1A), scene and (chain aA and resi 733 and resn TYR and name OH)
# G9R aA 3101 OBD ··· SER aA 741 OG = 2.76 Å (polar candidate)
distance d03_polar, scene and (chain aA and resi 3101 and resn G9R and name OBD), scene and (chain aA and resi 741 and resn SER and name OG)
# G9R aA 3101 O2D ··· TYR aA 601 OH = 3.02 Å (polar candidate)
distance d04_polar, scene and (chain aA and resi 3101 and resn G9R and name O2D), scene and (chain aA and resi 601 and resn TYR and name OH)
# G9R aA 3101 O2D ··· SER aA 741 OG = 3.39 Å (polar candidate)
distance d05_polar, scene and (chain aA and resi 3101 and resn G9R and name O2D), scene and (chain aA and resi 741 and resn SER and name OG)
# HOH aA 3210 O ··· SER aA 741 OG = 2.84 Å (water polar candidate)
distance d06_water, scene and (chain aA and resi 3210 and resn HOH and name O), scene and (chain aA and resi 741 and resn SER and name OG)
# HOH aA 3210 O ··· SER aA 605 OG = 3.07 Å (water polar candidate)
distance d07_water, scene and (chain aA and resi 3210 and resn HOH and name O), scene and (chain aA and resi 605 and resn SER and name OG)
# HOH aA 3210 O ··· GLY aA 737 O = 3.30 Å (water polar candidate)
distance d08_water, scene and (chain aA and resi 3210 and resn HOH and name O), scene and (chain aA and resi 737 and resn GLY and name O)
# G9R aA 3101 O2D ··· HOH aA 3210 O = 3.32 Å (water polar candidate)
distance d09_water, scene and (chain aA and resi 3101 and resn G9R and name O2D), scene and (chain aA and resi 3210 and resn HOH and name O)
# HOH aA 3210 O ··· TYR aA 601 OH = 3.35 Å (water polar candidate)
distance d10_water, scene and (chain aA and resi 3210 and resn HOH and name O), scene and (chain aA and resi 601 and resn TYR and name OH)
# G9R aA 3101 O1A ··· TRP aA 681 NE1 = 3.55 Å (longer context)
distance d11_context, scene and (chain aA and resi 3101 and resn G9R and name O1A), scene and (chain aA and resi 681 and resn TRP and name NE1)
# G9R aA 3101 OBD ··· G9R aA 3101 O2D = 3.65 Å (intramolecular)
distance d12_intra, scene and (chain aA and resi 3101 and resn G9R and name OBD), scene and (chain aA and resi 3101 and resn G9R and name O2D)
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
label scene and (chain aA and resi 601 and resn TYR and name CA), "Tyr601 aA"
label scene and (chain aA and resi 605 and resn SER and name CA), "Ser605 aA"
label scene and (chain aA and resi 678 and resn HIS and name CA), "His678 aA"
label scene and (chain aA and resi 681 and resn TRP and name CA), "Trp681 aA"
label scene and (chain aA and resi 733 and resn TYR and name CA), "Tyr733 aA"
label scene and (chain aA and resi 737 and resn GLY and name CA), "Gly737 aA"
label scene and (chain aA and resi 741 and resn SER and name CA), "Ser741 aA"
label scene and (chain aA and resi 3101 and resn G9R and name MG), "PA"
label scene and (chain aA and resi 3210 and resn HOH and name O), "HOH3210 aA"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.241605, 0.664255, 0.707384, 0.124276, 0.744158, -0.656341, -0.962384, -0.070664, -0.262344, 0.000000, 3.444105, -127.180267, 137.421005, 216.472000, 163.906998, 107.561630, 146.798904, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
