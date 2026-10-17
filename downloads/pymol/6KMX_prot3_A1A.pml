# PSI Contact Atlas — 6KMX protomer 3, A1_A quinone
# Halomicronema hongdechloris C2206 · FRL · Cryo-EM 2.41 Å
#
# Run from the repository root:   pymol downloads/pymol/6KMX_prot3_A1A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/6KMX_prot3_A1A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 6KMX, scene, type=cif
select lib_atoms, scene and ((chain cA and resi 717+718+721+726+750+751+845))

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
set_bond stick_radius, 0.16, scene and ((chain cA and resi 845 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN cA 845 O4 ··· LEU cA 751 N = 2.83 Å (polar candidate)
distance d01_polar, scene and (chain cA and resi 845 and resn PQN and name O4), scene and (chain cA and resi 751 and resn LEU and name N)
# PQN cA 845 O1 ··· MET cA 717 O = 2.96 Å (polar candidate)
distance d02_polar, scene and (chain cA and resi 845 and resn PQN and name O1), scene and (chain cA and resi 717 and resn MET and name O)
# PQN cA 845 O1 ··· SER cA 721 OG = 3.25 Å (polar candidate)
distance d03_polar, scene and (chain cA and resi 845 and resn PQN and name O1), scene and (chain cA and resi 721 and resn SER and name OG)
# PQN cA 845 O1 ··· TRP cA 726 NE1 = 3.38 Å (polar candidate)
distance d04_polar, scene and (chain cA and resi 845 and resn PQN and name O1), scene and (chain cA and resi 726 and resn TRP and name NE1)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain cA and resi 845 and resn PQN and name C1), "A1A"
label scene and (chain cA and resi 717 and resn MET and name CA), "Met717 cA"
label scene and (chain cA and resi 718 and resn PHE and name CA), "Phe718 cA"
label scene and (chain cA and resi 721 and resn SER and name CA), "Ser721 cA"
label scene and (chain cA and resi 726 and resn TRP and name CA), "Trp726 cA"
label scene and (chain cA and resi 750 and resn ALA and name CA), "Ala750 cA"
label scene and (chain cA and resi 751 and resn LEU and name CA), "Leu751 cA"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.998233, 0.019925, 0.055983, -0.055844, -0.007464, 0.998412, 0.020311, -0.999774, -0.006338, 0.000000, -1.946255, -83.466515, 159.102005, 220.610992, 157.957993, 57.744415, 109.188606, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
