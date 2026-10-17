# PSI Contact Atlas — 9AU4 protomer 3, A1_B quinone
# Synechocystis sp. PCC 6803 · MenB variant · Cryo-EM 2.03 Å
#
# Run from the repository root:   pymol downloads/pymol/9AU4_prot3_A1B.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9AU4_prot3_A1B.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9AU4, scene, type=cif
select lib_atoms, scene and ((chain b and resi 659+660+663+668+696+697+2153))

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
set_bond stick_radius, 0.16, scene and ((chain b and resi 2153 and resn A1AGD))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# A1AGD b 2153 O2 ··· SER b 663 OG = 3.06 Å (polar candidate)
distance d01_polar, scene and (chain b and resi 2153 and resn A1AGD and name O2), scene and (chain b and resi 663 and resn SER and name OG)
# A1AGD b 2153 O2 ··· TRP b 668 NE1 = 3.18 Å (polar candidate)
distance d02_polar, scene and (chain b and resi 2153 and resn A1AGD and name O2), scene and (chain b and resi 668 and resn TRP and name NE1)
# A1AGD b 2153 O1 ··· LEU b 697 N = 3.18 Å (polar candidate)
distance d03_polar, scene and (chain b and resi 2153 and resn A1AGD and name O1), scene and (chain b and resi 697 and resn LEU and name N)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain b and resi 659 and resn MET and name CA), "Met659 b"
label scene and (chain b and resi 660 and resn PHE and name CA), "Phe660 b"
label scene and (chain b and resi 663 and resn SER and name CA), "Ser663 b"
label scene and (chain b and resi 668 and resn TRP and name CA), "Trp668 b"
label scene and (chain b and resi 696 and resn ALA and name CA), "Ala696 b"
label scene and (chain b and resi 697 and resn LEU and name CA), "Leu697 b"
label scene and (chain b and resi 2153 and resn A1AGD and name C1), "A1B"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.951990, 0.306107, 0.003741, 0.009781, -0.042628, 0.999043, 0.305973, -0.951042, -0.043575, 0.000000, -0.540304, -65.954002, 133.983002, 178.434998, 126.194000, 44.579708, 87.328300, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
