# PSI Contact Atlas — 6KMW protomer 3, A1_B quinone
# Halomicronema hongdechloris C2206 · WL · Cryo-EM 2.35 Å
#
# Run from the repository root:   pymol downloads/pymol/6KMW_prot3_A1B.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/6KMW_prot3_A1B.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 6KMW, scene, type=cif
select lib_atoms, scene and ((chain cB and resi 670+671+674+679+707+708+842))

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
set_bond stick_radius, 0.16, scene and ((chain cB and resi 842 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN cB 842 O4 ··· LEU cB 708 N = 2.91 Å (polar candidate)
distance d01_polar, scene and (chain cB and resi 842 and resn PQN and name O4), scene and (chain cB and resi 708 and resn LEU and name N)
# PQN cB 842 O1 ··· MET cB 670 O = 3.09 Å (polar candidate)
distance d02_polar, scene and (chain cB and resi 842 and resn PQN and name O1), scene and (chain cB and resi 670 and resn MET and name O)
# PQN cB 842 O1 ··· SER cB 674 OG = 3.12 Å (polar candidate)
distance d03_polar, scene and (chain cB and resi 842 and resn PQN and name O1), scene and (chain cB and resi 674 and resn SER and name OG)
# PQN cB 842 O1 ··· TRP cB 679 NE1 = 3.32 Å (polar candidate)
distance d04_polar, scene and (chain cB and resi 842 and resn PQN and name O1), scene and (chain cB and resi 679 and resn TRP and name NE1)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain cB and resi 842 and resn PQN and name C1), "A1B"
label scene and (chain cB and resi 670 and resn MET and name CA), "Met670 cB"
label scene and (chain cB and resi 671 and resn PHE and name CA), "Phe671 cB"
label scene and (chain cB and resi 674 and resn SER and name CA), "Ser674 cB"
label scene and (chain cB and resi 679 and resn TRP and name CA), "Trp679 cB"
label scene and (chain cB and resi 707 and resn ALA and name CA), "Ala707 cB"
label scene and (chain cB and resi 708 and resn LEU and name CA), "Leu708 cB"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.937455, 0.318945, 0.139470, -0.122799, -0.071900, 0.989824, 0.325727, -0.945042, -0.028237, 0.000000, -0.454381, -65.003708, 164.020996, 201.554001, 152.714996, 43.865341, 86.142075, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
