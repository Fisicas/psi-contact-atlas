# PSI Contact Atlas — 9SK3 protomer 1, A1_A quinone
# Acaryochloris marina NIES-2412 · Chl d / P740 · Cryo-EM 2.63 Å
#
# Run from the repository root:   pymol downloads/pymol/9SK3_prot1_A1A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9SK3_prot1_A1A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9SK3, scene, type=cif
select lib_atoms, scene and ((chain aA and resi 686+687+690+695+719+720+2001))

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
set_bond stick_radius, 0.16, scene and ((chain aA and resi 2001 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN aA 2001 O4 ··· MET aA 720 N = 2.89 Å (polar candidate)
distance d01_polar, scene and (chain aA and resi 2001 and resn PQN and name O4), scene and (chain aA and resi 720 and resn MET and name N)
# PQN aA 2001 O1 ··· TRP aA 695 NE1 = 3.28 Å (polar candidate)
distance d02_polar, scene and (chain aA and resi 2001 and resn PQN and name O1), scene and (chain aA and resi 695 and resn TRP and name NE1)
# PQN aA 2001 O1 ··· SER aA 690 OG = 3.31 Å (polar candidate)
distance d03_polar, scene and (chain aA and resi 2001 and resn PQN and name O1), scene and (chain aA and resi 690 and resn SER and name OG)
# PQN aA 2001 O1 ··· MET aA 686 O = 3.38 Å (polar candidate)
distance d04_polar, scene and (chain aA and resi 2001 and resn PQN and name O1), scene and (chain aA and resi 686 and resn MET and name O)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain aA and resi 686 and resn MET and name CA), "Met686 aA"
label scene and (chain aA and resi 687 and resn PHE and name CA), "Phe687 aA"
label scene and (chain aA and resi 690 and resn SER and name CA), "Ser690 aA"
label scene and (chain aA and resi 695 and resn TRP and name CA), "Trp695 aA"
label scene and (chain aA and resi 719 and resn ALA and name CA), "Ala719 aA"
label scene and (chain aA and resi 720 and resn MET and name CA), "Met720 aA"
label scene and (chain aA and resi 2001 and resn PQN and name C1), "A1A"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.961347, -0.033593, 0.273285, 0.272487, -0.026485, -0.961795, 0.039547, 0.999085, -0.016307, 0.000000, -1.547709, -76.777672, 333.123993, 254.681000, 321.359985, 52.716202, 100.839134, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
