# PSI Contact Atlas — 6KMW protomer 3, A1_A quinone
# Halomicronema hongdechloris C2206 · WL · Cryo-EM 2.35 Å
#
# Run from the repository root:   pymol downloads/pymol/6KMW_prot3_A1A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/6KMW_prot3_A1A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 6KMW, scene, type=cif
select lib_atoms, scene and ((chain cA and resi 697+698+701+706+730+731+844))

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
set_bond stick_radius, 0.16, scene and ((chain cA and resi 844 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN cA 844 O4 ··· LEU cA 731 N = 2.83 Å (polar candidate)
distance d01_polar, scene and (chain cA and resi 844 and resn PQN and name O4), scene and (chain cA and resi 731 and resn LEU and name N)
# PQN cA 844 O1 ··· MET cA 697 O = 2.96 Å (polar candidate)
distance d02_polar, scene and (chain cA and resi 844 and resn PQN and name O1), scene and (chain cA and resi 697 and resn MET and name O)
# PQN cA 844 O1 ··· SER cA 701 OG = 3.12 Å (polar candidate)
distance d03_polar, scene and (chain cA and resi 844 and resn PQN and name O1), scene and (chain cA and resi 701 and resn SER and name OG)
# PQN cA 844 O1 ··· TRP cA 706 NE1 = 3.31 Å (polar candidate)
distance d04_polar, scene and (chain cA and resi 844 and resn PQN and name O1), scene and (chain cA and resi 706 and resn TRP and name NE1)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain cA and resi 697 and resn MET and name CA), "Met697 cA"
label scene and (chain cA and resi 698 and resn PHE and name CA), "Phe698 cA"
label scene and (chain cA and resi 701 and resn SER and name CA), "Ser701 cA"
label scene and (chain cA and resi 706 and resn TRP and name CA), "Trp706 cA"
label scene and (chain cA and resi 730 and resn ALA and name CA), "Ala730 cA"
label scene and (chain cA and resi 731 and resn LEU and name CA), "Leu731 cA"
label scene and (chain cA and resi 844 and resn PQN and name C1), "A1A"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.937455, 0.318945, 0.139470, -0.122799, -0.071900, 0.989824, 0.325727, -0.945042, -0.028237, 0.000000, -2.138309, -84.183121, 162.860992, 220.134995, 152.539001, 58.283115, 110.083130, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
