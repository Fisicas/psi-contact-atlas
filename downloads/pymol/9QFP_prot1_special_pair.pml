# PSI Contact Atlas — 9QFP protomer 1, special pair
# Thermosynechococcus vestitus BP-1 · PsaL absent from model · Cryo-EM 1.74 Å
#
# Run from the repository root:   pymol downloads/pymol/9QFP_prot1_special_pair.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9QFP_prot1_special_pair.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9QFP, scene, type=cif
select lib_atoms, scene and ((chain A and resi 603+607+611+680+683+735+739+743+746+847+1061) or (chain B and resi 599+661+664+724+727+728+731+834+952))

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
set_bond stick_radius, 0.16, scene and ((chain A and resi 847 and resn CL0) or (chain B and resi 834 and resn CLA))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CLA B 834 MG ··· HIS B 661 NE2 = 2.19 Å (Mg ligand)
distance d01_mg, scene and (chain B and resi 834 and resn CLA and name MG), scene and (chain B and resi 661 and resn HIS and name NE2)
# CL0 A 847 MG ··· HIS A 680 NE2 = 2.21 Å (Mg ligand)
distance d02_mg, scene and (chain A and resi 847 and resn CL0 and name MG), scene and (chain A and resi 680 and resn HIS and name NE2)
# CL0 A 847 O1A ··· TYR A 735 OH = 2.60 Å (polar candidate)
distance d03_polar, scene and (chain A and resi 847 and resn CL0 and name O1A), scene and (chain A and resi 735 and resn TYR and name OH)
# CL0 A 847 OBD ··· THR A 743 OG1 = 2.75 Å (polar candidate)
distance d04_polar, scene and (chain A and resi 847 and resn CL0 and name OBD), scene and (chain A and resi 743 and resn THR and name OG1)
# CL0 A 847 O2D ··· TYR A 603 OH = 3.19 Å (polar candidate)
distance d05_polar, scene and (chain A and resi 847 and resn CL0 and name O2D), scene and (chain A and resi 603 and resn TYR and name OH)
# CLA B 834 O1D ··· TYR B 728 N = 3.21 Å (polar candidate)
distance d06_polar, scene and (chain B and resi 834 and resn CLA and name O1D), scene and (chain B and resi 728 and resn TYR and name N)
# CL0 A 847 O2D ··· THR A 743 OG1 = 3.29 Å (polar candidate)
distance d07_polar, scene and (chain A and resi 847 and resn CL0 and name O2D), scene and (chain A and resi 743 and resn THR and name OG1)
# CL0 A 847 O2D ··· HOH A 1061 O = 3.16 Å (water polar candidate)
distance d08_water, scene and (chain A and resi 847 and resn CL0 and name O2D), scene and (chain A and resi 1061 and resn HOH and name O)
# CLA B 834 O2D ··· HOH B 952 O = 4.90 Å (longer context)
distance d09_context, scene and (chain B and resi 834 and resn CLA and name O2D), scene and (chain B and resi 952 and resn HOH and name O)
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
set_color cls_context, [0.541, 0.573, 0.612]
group longer_context, d09_context
set dash_color, cls_context, longer_context
set dash_length, 0.08, longer_context
set dash_gap, 0.3, longer_context

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain A and resi 603 and resn TYR and name CA), "Tyr603 A"
label scene and (chain A and resi 607 and resn SER and name CA), "Ser607 A"
label scene and (chain A and resi 611 and resn PHE and name CA), "Phe611 A"
label scene and (chain A and resi 680 and resn HIS and name CA), "His680 A"
label scene and (chain A and resi 683 and resn TRP and name CA), "Trp683 A"
label scene and (chain A and resi 735 and resn TYR and name CA), "Tyr735 A"
label scene and (chain A and resi 739 and resn GLY and name CA), "Gly739 A"
label scene and (chain A and resi 743 and resn THR and name CA), "Thr743 A"
label scene and (chain A and resi 746 and resn PHE and name CA), "Phe746 A"
label scene and (chain A and resi 847 and resn CL0 and name MG), "PA"
label scene and (chain A and resi 1061 and resn HOH and name O), "HOH1061 A"
label scene and (chain B and resi 599 and resn PHE and name CA), "Phe599 B"
label scene and (chain B and resi 661 and resn HIS and name CA), "His661 B"
label scene and (chain B and resi 664 and resn TRP and name CA), "Trp664 B"
label scene and (chain B and resi 724 and resn TYR and name CA), "Tyr724 B"
label scene and (chain B and resi 727 and resn THR and name CA), "Thr727 B"
label scene and (chain B and resi 728 and resn TYR and name CA), "Tyr728 B"
label scene and (chain B and resi 731 and resn PHE and name CA), "Phe731 B"
label scene and (chain B and resi 834 and resn CLA and name MG), "PB"
label scene and (chain B and resi 952 and resn HOH and name O), "HOH952 B"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.949166, -0.109633, -0.295067, 0.286222, 0.089515, -0.953973, 0.131000, -0.989933, -0.053585, 0.000000, -2.120137, -127.581741, 152.714005, 166.542999, 167.977997, 107.734314, 147.429169, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
