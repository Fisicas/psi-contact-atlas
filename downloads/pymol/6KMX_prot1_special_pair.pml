# PSI Contact Atlas — 6KMX protomer 1, special pair
# Halomicronema hongdechloris C2206 · FRL · Cryo-EM 2.41 Å
#
# Run from the repository root:   pymol downloads/pymol/6KMX_prot1_special_pair.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/6KMX_prot1_special_pair.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 6KMX, scene, type=cif
select lib_atoms, scene and ((chain aA and resi 632+640+709+764+772+801+918) or (chain aB and resi 602+664+667+722+726+729+730+733+801))

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
set_bond stick_radius, 0.16, scene and ((chain aA and resi 801 and resn CL0) or (chain aB and resi 801 and resn CLA))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CL0 aA 801 MG ··· HIS aA 709 NE2 = 2.22 Å (Mg ligand)
distance d01_mg, scene and (chain aA and resi 801 and resn CL0 and name MG), scene and (chain aA and resi 709 and resn HIS and name NE2)
# CLA aB 801 MG ··· HIS aB 664 NE2 = 2.23 Å (Mg ligand)
distance d02_mg, scene and (chain aB and resi 801 and resn CLA and name MG), scene and (chain aB and resi 664 and resn HIS and name NE2)
# CL0 aA 801 O1A ··· TYR aA 764 OH = 2.92 Å (polar candidate)
distance d03_polar, scene and (chain aA and resi 801 and resn CL0 and name O1A), scene and (chain aA and resi 764 and resn TYR and name OH)
# CLA aB 801 O1D ··· TYR aB 730 N = 3.06 Å (polar candidate)
distance d04_polar, scene and (chain aB and resi 801 and resn CLA and name O1D), scene and (chain aB and resi 730 and resn TYR and name N)
# CL0 aA 801 O2D ··· THR aA 772 OG1 = 3.11 Å (polar candidate)
distance d05_polar, scene and (chain aA and resi 801 and resn CL0 and name O2D), scene and (chain aA and resi 772 and resn THR and name OG1)
# CL0 aA 801 OBD ··· THR aA 772 OG1 = 3.25 Å (polar candidate)
distance d06_polar, scene and (chain aA and resi 801 and resn CL0 and name OBD), scene and (chain aA and resi 772 and resn THR and name OG1)
# CL0 aA 801 O2D ··· TYR aA 632 OH = 3.30 Å (polar candidate)
distance d07_polar, scene and (chain aA and resi 801 and resn CL0 and name O2D), scene and (chain aA and resi 632 and resn TYR and name OH)
# CL0 aA 801 O2D ··· HOH aA 918 O = 3.48 Å (water polar candidate)
distance d08_water, scene and (chain aA and resi 801 and resn CL0 and name O2D), scene and (chain aA and resi 918 and resn HOH and name O)
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
label scene and (chain aA and resi 632 and resn TYR and name CA), "Tyr632 aA"
label scene and (chain aA and resi 640 and resn PHE and name CA), "Phe640 aA"
label scene and (chain aA and resi 709 and resn HIS and name CA), "His709 aA"
label scene and (chain aA and resi 764 and resn TYR and name CA), "Tyr764 aA"
label scene and (chain aA and resi 772 and resn THR and name CA), "Thr772 aA"
label scene and (chain aA and resi 918 and resn HOH and name O), "HOH918 aA"
label scene and (chain aA and resi 801 and resn CL0 and name MG), "PA"
label scene and (chain aB and resi 602 and resn PHE and name CA), "Phe602 aB"
label scene and (chain aB and resi 664 and resn HIS and name CA), "His664 aB"
label scene and (chain aB and resi 667 and resn TRP and name CA), "Trp667 aB"
label scene and (chain aB and resi 722 and resn PHE and name CA), "Phe722 aB"
label scene and (chain aB and resi 726 and resn TYR and name CA), "Tyr726 aB"
label scene and (chain aB and resi 729 and resn THR and name CA), "Thr729 aB"
label scene and (chain aB and resi 730 and resn TYR and name CA), "Tyr730 aB"
label scene and (chain aB and resi 733 and resn PHE and name CA), "Phe733 aB"
label scene and (chain aB and resi 801 and resn CLA and name MG), "PB"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.150402, 0.337968, 0.929062, 0.170552, -0.934532, 0.312348, 0.973802, 0.111476, -0.198197, 0.000000, -1.977554, -145.678574, 104.669998, 133.436996, 178.166000, 123.725113, 167.632034, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
