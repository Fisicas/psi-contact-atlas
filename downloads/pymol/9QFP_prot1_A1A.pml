# PSI Contact Atlas — 9QFP protomer 1, A1_A quinone
# Thermosynechococcus vestitus BP-1 · PsaL absent from model · Cryo-EM 1.74 Å
#
# Run from the repository root:   pymol downloads/pymol/9QFP_prot1_A1A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9QFP_prot1_A1A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9QFP, scene, type=cif
select lib_atoms, scene and ((chain A and resi 688+689+692+697+721+722+837))

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
set_bond stick_radius, 0.16, scene and ((chain A and resi 837 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN A 837 O4 ··· LEU A 722 N = 2.92 Å (polar candidate)
distance d01_polar, scene and (chain A and resi 837 and resn PQN and name O4), scene and (chain A and resi 722 and resn LEU and name N)
# PQN A 837 O1 ··· SER A 692 OG = 3.16 Å (polar candidate)
distance d02_polar, scene and (chain A and resi 837 and resn PQN and name O1), scene and (chain A and resi 692 and resn SER and name OG)
# PQN A 837 O1 ··· MET A 688 O = 3.23 Å (polar candidate)
distance d03_polar, scene and (chain A and resi 837 and resn PQN and name O1), scene and (chain A and resi 688 and resn MET and name O)
# PQN A 837 O1 ··· TRP A 697 NE1 = 3.28 Å (polar candidate)
distance d04_polar, scene and (chain A and resi 837 and resn PQN and name O1), scene and (chain A and resi 697 and resn TRP and name NE1)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain A and resi 688 and resn MET and name CA), "Met688 A"
label scene and (chain A and resi 689 and resn PHE and name CA), "Phe689 A"
label scene and (chain A and resi 692 and resn SER and name CA), "Ser692 A"
label scene and (chain A and resi 697 and resn TRP and name CA), "Trp697 A"
label scene and (chain A and resi 721 and resn ALA and name CA), "Ala721 A"
label scene and (chain A and resi 722 and resn LEU and name CA), "Leu722 A"
label scene and (chain A and resi 837 and resn PQN and name C1), "A1A"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.306388, 0.950944, 0.042799, -0.034000, -0.055865, 0.997859, 0.951299, 0.304277, 0.049448, 0.000000, -2.016743, -84.298332, 173.125000, 173.087997, 164.550995, 58.369720, 110.226944, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
