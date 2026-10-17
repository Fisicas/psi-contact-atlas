# PSI Contact Atlas — 6KMW protomer 2, special pair
# Halomicronema hongdechloris C2206 · WL · Cryo-EM 2.35 Å
#
# Run from the repository root:   pymol downloads/pymol/6KMW_prot2_special_pair.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/6KMW_prot2_special_pair.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 6KMW, scene, type=cif
select lib_atoms, scene and ((chain bA and resi 612+620+689+692+752+755+801+916) or (chain bB and resi 600+662+665+725+728+729+732+803))

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
set_bond stick_radius, 0.16, scene and ((chain bA and resi 801 and resn CL0) or (chain bB and resi 803 and resn CLA))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CL0 bA 801 MG ··· HIS bA 689 NE2 = 2.22 Å (Mg ligand)
distance d01_mg, scene and (chain bA and resi 801 and resn CL0 and name MG), scene and (chain bA and resi 689 and resn HIS and name NE2)
# CLA bB 803 MG ··· HIS bB 662 NE2 = 2.27 Å (Mg ligand)
distance d02_mg, scene and (chain bB and resi 803 and resn CLA and name MG), scene and (chain bB and resi 662 and resn HIS and name NE2)
# CLA bB 803 O1D ··· TYR bB 729 N = 3.08 Å (polar candidate)
distance d03_polar, scene and (chain bB and resi 803 and resn CLA and name O1D), scene and (chain bB and resi 729 and resn TYR and name N)
# CL0 bA 801 OBD ··· THR bA 752 OG1 = 3.11 Å (polar candidate)
distance d04_polar, scene and (chain bA and resi 801 and resn CL0 and name OBD), scene and (chain bA and resi 752 and resn THR and name OG1)
# CL0 bA 801 O2D ··· TYR bA 612 OH = 3.14 Å (polar candidate)
distance d05_polar, scene and (chain bA and resi 801 and resn CL0 and name O2D), scene and (chain bA and resi 612 and resn TYR and name OH)
# CL0 bA 801 O2D ··· THR bA 752 OG1 = 3.34 Å (polar candidate)
distance d06_polar, scene and (chain bA and resi 801 and resn CL0 and name O2D), scene and (chain bA and resi 752 and resn THR and name OG1)
# CL0 bA 801 O1A ··· TRP bA 692 NE1 = 3.38 Å (polar candidate)
distance d07_polar, scene and (chain bA and resi 801 and resn CL0 and name O1A), scene and (chain bA and resi 692 and resn TRP and name NE1)
# CL0 bA 801 O2D ··· HOH bA 916 O = 3.44 Å (water polar candidate)
distance d08_water, scene and (chain bA and resi 801 and resn CL0 and name O2D), scene and (chain bA and resi 916 and resn HOH and name O)
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
label scene and (chain bA and resi 916 and resn HOH and name O), "HOH916 bA"
label scene and (chain bA and resi 612 and resn TYR and name CA), "Tyr612 bA"
label scene and (chain bA and resi 620 and resn PHE and name CA), "Phe620 bA"
label scene and (chain bA and resi 689 and resn HIS and name CA), "His689 bA"
label scene and (chain bA and resi 692 and resn TRP and name CA), "Trp692 bA"
label scene and (chain bA and resi 752 and resn THR and name CA), "Thr752 bA"
label scene and (chain bA and resi 755 and resn PHE and name CA), "Phe755 bA"
label scene and (chain bA and resi 801 and resn CL0 and name MG), "PA"
label scene and (chain bB and resi 600 and resn PHE and name CA), "Phe600 bB"
label scene and (chain bB and resi 662 and resn HIS and name CA), "His662 bB"
label scene and (chain bB and resi 665 and resn TRP and name CA), "Trp665 bB"
label scene and (chain bB and resi 725 and resn TYR and name CA), "Tyr725 bB"
label scene and (chain bB and resi 728 and resn THR and name CA), "Thr728 bB"
label scene and (chain bB and resi 729 and resn TYR and name CA), "Tyr729 bB"
label scene and (chain bB and resi 732 and resn PHE and name CA), "Phe732 bB"
label scene and (chain bB and resi 803 and resn CLA and name MG), "PB"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.092659, 0.663500, -0.742417, 0.017669, 0.746602, 0.665036, 0.995541, 0.048504, -0.080902, 0.000000, -1.887565, -126.866638, 200.815002, 120.615997, 172.807999, 107.102432, 146.630844, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
