# PSI Contact Atlas — 9SK3 protomer 2, A1_B quinone
# Acaryochloris marina NIES-2412 · Chl d / P740 · Cryo-EM 2.63 Å
#
# Run from the repository root:   pymol downloads/pymol/9SK3_prot2_A1B.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9SK3_prot2_A1B.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9SK3, scene, type=cif
select lib_atoms, scene and ((chain bB and resi 662+663+666+671+699+700+2002))

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
set_bond stick_radius, 0.16, scene and ((chain bB and resi 2002 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN bB 2002 O4 ··· LEU bB 700 N = 2.97 Å (polar candidate)
distance d01_polar, scene and (chain bB and resi 2002 and resn PQN and name O4), scene and (chain bB and resi 700 and resn LEU and name N)
# PQN bB 2002 O1 ··· SER bB 666 OG = 3.10 Å (polar candidate)
distance d02_polar, scene and (chain bB and resi 2002 and resn PQN and name O1), scene and (chain bB and resi 666 and resn SER and name OG)
# PQN bB 2002 O1 ··· TRP bB 671 NE1 = 3.43 Å (polar candidate)
distance d03_polar, scene and (chain bB and resi 2002 and resn PQN and name O1), scene and (chain bB and resi 671 and resn TRP and name NE1)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain bB and resi 662 and resn LEU and name CA), "Leu662 bB"
label scene and (chain bB and resi 663 and resn PHE and name CA), "Phe663 bB"
label scene and (chain bB and resi 666 and resn SER and name CA), "Ser666 bB"
label scene and (chain bB and resi 671 and resn TRP and name CA), "Trp671 bB"
label scene and (chain bB and resi 699 and resn ALA and name CA), "Ala699 bB"
label scene and (chain bB and resi 700 and resn LEU and name CA), "Leu700 bB"
label scene and (chain bB and resi 2002 and resn PQN and name C1), "A1B"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (0.716508, 0.039747, -0.696445, -0.696464, -0.015650, -0.717421, -0.039414, 0.999087, 0.016469, 0.000000, -1.691108, -79.659294, 348.483002, 350.985992, 321.247986, 54.882408, 104.436172, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
