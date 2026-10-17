# PSI Contact Atlas — 9EYS protomer 1, A1_A quinone
# Chroococcidiopsis thermalis PCC 7203 · FRL · Cryo-EM 2.01 Å
#
# Run from the repository root:   pymol downloads/pymol/9EYS_prot1_A1A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9EYS_prot1_A1A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9EYS, scene, type=cif
select lib_atoms, scene and ((chain A and resi 715+716+719+724+748+749+843))

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
set_bond stick_radius, 0.16, scene and ((chain A and resi 843 and resn PQN))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# PQN A 843 O4 ··· LEU A 749 N = 2.85 Å (polar candidate)
distance d01_polar, scene and (chain A and resi 843 and resn PQN and name O4), scene and (chain A and resi 749 and resn LEU and name N)
# PQN A 843 O1 ··· SER A 719 OG = 3.24 Å (polar candidate)
distance d02_polar, scene and (chain A and resi 843 and resn PQN and name O1), scene and (chain A and resi 719 and resn SER and name OG)
# PQN A 843 O1 ··· TRP A 724 NE1 = 3.29 Å (polar candidate)
distance d03_polar, scene and (chain A and resi 843 and resn PQN and name O1), scene and (chain A and resi 724 and resn TRP and name NE1)
# PQN A 843 O1 ··· MET A 715 O = 3.47 Å (polar candidate)
distance d04_polar, scene and (chain A and resi 843 and resn PQN and name O1), scene and (chain A and resi 715 and resn MET and name O)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar d04_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain A and resi 715 and resn MET and name CA), "Met715 A"
label scene and (chain A and resi 716 and resn PHE and name CA), "Phe716 A"
label scene and (chain A and resi 719 and resn SER and name CA), "Ser719 A"
label scene and (chain A and resi 724 and resn TRP and name CA), "Trp724 A"
label scene and (chain A and resi 748 and resn ALA and name CA), "Ala748 A"
label scene and (chain A and resi 749 and resn LEU and name CA), "Leu749 A"
label scene and (chain A and resi 843 and resn PQN and name C1), "A1A"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.510651, 0.098265, -0.854155, -0.846933, 0.113660, 0.519409, 0.148123, 0.988648, 0.025183, 0.000000, -0.982823, -77.526611, 329.595001, 241.061005, 282.695007, 53.279202, 101.774017, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
