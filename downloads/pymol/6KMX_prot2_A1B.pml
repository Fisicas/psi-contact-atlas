# PSI Contact Atlas — 6KMX protomer 2, A1_B quinone
# Halomicronema hongdechloris C2206 · FRL · Cryo-EM 2.41 Å
#
# Run from the repository root:   pymol downloads/pymol/6KMX_prot2_A1B.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/6KMX_prot2_A1B.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 6KMX, scene, type=cif
select lib_atoms, scene and ((chain bB and resi 672+673+676+681+708+709+841))

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
set_bond stick_radius, 0.16, scene and ((chain bB and resi 841 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN bB 841 O4 ··· LEU bB 709 N = 2.92 Å (polar candidate)
distance d01_polar, scene and (chain bB and resi 841 and resn PQN and name O4), scene and (chain bB and resi 709 and resn LEU and name N)
# PQN bB 841 O1 ··· MET bB 672 O = 2.98 Å (polar candidate)
distance d02_polar, scene and (chain bB and resi 841 and resn PQN and name O1), scene and (chain bB and resi 672 and resn MET and name O)
# PQN bB 841 O1 ··· THR bB 676 OG1 = 3.01 Å (polar candidate)
distance d03_polar, scene and (chain bB and resi 841 and resn PQN and name O1), scene and (chain bB and resi 676 and resn THR and name OG1)
# PQN bB 841 O1 ··· TRP bB 681 NE1 = 3.39 Å (polar candidate)
distance d04_polar, scene and (chain bB and resi 841 and resn PQN and name O1), scene and (chain bB and resi 681 and resn TRP and name NE1)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain bB and resi 841 and resn PQN and name C1), "A1B"
label scene and (chain bB and resi 672 and resn MET and name CA), "Met672 bB"
label scene and (chain bB and resi 673 and resn PHE and name CA), "Phe673 bB"
label scene and (chain bB and resi 676 and resn THR and name CA), "Thr676 bB"
label scene and (chain bB and resi 681 and resn TRP and name CA), "Trp681 bB"
label scene and (chain bB and resi 708 and resn ALA and name CA), "Ala708 bB"
label scene and (chain bB and resi 709 and resn LEU and name CA), "Leu709 bB"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.547303, -0.017070, 0.836760, -0.836656, -0.014614, -0.547533, 0.021575, -0.999747, -0.006284, 0.000000, -1.807921, -53.659260, 193.479996, 130.085007, 158.158005, 35.337360, 71.981155, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
