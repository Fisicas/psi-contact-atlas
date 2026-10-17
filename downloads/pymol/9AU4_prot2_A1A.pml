# PSI Contact Atlas — 9AU4 protomer 2, A1_A quinone
# Synechocystis sp. PCC 6803 · MenB variant · Cryo-EM 2.03 Å
#
# Run from the repository root:   pymol downloads/pymol/9AU4_prot2_A1A.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9AU4_prot2_A1A.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9AU4, scene, type=cif
select lib_atoms, scene and ((chain G and resi 684+685+688+693+717+718+840))

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
set_bond stick_radius, 0.16, scene and ((chain G and resi 840 and resn A1AGD))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# A1AGD G 840 O2 ··· MET G 684 O = 2.74 Å (polar candidate)
distance d01_polar, scene and (chain G and resi 840 and resn A1AGD and name O2), scene and (chain G and resi 684 and resn MET and name O)
# A1AGD G 840 O2 ··· SER G 688 OG = 2.81 Å (polar candidate)
distance d02_polar, scene and (chain G and resi 840 and resn A1AGD and name O2), scene and (chain G and resi 688 and resn SER and name OG)
# A1AGD G 840 O1 ··· LEU G 718 N = 3.06 Å (polar candidate)
distance d03_polar, scene and (chain G and resi 840 and resn A1AGD and name O1), scene and (chain G and resi 718 and resn LEU and name N)
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d01_polar d02_polar d03_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain G and resi 684 and resn MET and name CA), "Met684 G"
label scene and (chain G and resi 685 and resn PHE and name CA), "Phe685 G"
label scene and (chain G and resi 688 and resn SER and name CA), "Ser688 G"
label scene and (chain G and resi 693 and resn TRP and name CA), "Trp693 G"
label scene and (chain G and resi 717 and resn ALA and name CA), "Ala717 G"
label scene and (chain G and resi 718 and resn LEU and name CA), "Leu718 G"
label scene and (chain G and resi 840 and resn A1AGD and name C1), "A1A"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.467781, -0.189623, 0.863264, -0.829240, -0.243824, -0.502903, 0.305846, -0.951101, -0.043186, 0.000000, -1.848438, -79.572083, 189.281998, 104.044998, 125.347000, 54.816849, 104.327309, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
