# PSI Contact Atlas — 9SK3 protomer 2, special pair
# Acaryochloris marina NIES-2412 · Chl d / P740 · Cryo-EM 2.63 Å
#
# Run from the repository root:   pymol downloads/pymol/9SK3_prot2_special_pair.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9SK3_prot2_special_pair.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9SK3, scene, type=cif
select lib_atoms, scene and ((chain bA and resi 601+609+652+678+681+733+741+1011+3210) or (chain bB and resi 592+624+654+657+717+720+721+724+1021))

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
set_bond stick_radius, 0.16, scene and ((chain bA and resi 1011 and resn G9R) or (chain bB and resi 1021 and resn CL7))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CL7 bB 1021 MG ··· HIS bB 654 NE2 = 2.30 Å (Mg ligand)
distance d01_mg, scene and (chain bB and resi 1021 and resn CL7 and name MG), scene and (chain bB and resi 654 and resn HIS and name NE2)
# G9R bA 1011 MG ··· HIS bA 678 NE2 = 2.30 Å (Mg ligand)
distance d02_mg, scene and (chain bA and resi 1011 and resn G9R and name MG), scene and (chain bA and resi 678 and resn HIS and name NE2)
# G9R bA 1011 O1A ··· TYR bA 733 OH = 2.84 Å (polar candidate)
distance d03_polar, scene and (chain bA and resi 1011 and resn G9R and name O1A), scene and (chain bA and resi 733 and resn TYR and name OH)
# G9R bA 1011 OBD ··· SER bA 741 OG = 2.91 Å (polar candidate)
distance d04_polar, scene and (chain bA and resi 1011 and resn G9R and name OBD), scene and (chain bA and resi 741 and resn SER and name OG)
# CL7 bB 1021 O1D ··· TYR bB 721 N = 3.12 Å (polar candidate)
distance d05_polar, scene and (chain bB and resi 1021 and resn CL7 and name O1D), scene and (chain bB and resi 721 and resn TYR and name N)
# CL7 bB 1021 O2A ··· TYR bB 717 OH = 3.39 Å (polar candidate)
distance d06_polar, scene and (chain bB and resi 1021 and resn CL7 and name O2A), scene and (chain bB and resi 717 and resn TYR and name OH)
# G9R bA 1011 O2D ··· TYR bA 601 OH = 3.39 Å (polar candidate)
distance d07_polar, scene and (chain bA and resi 1011 and resn G9R and name O2D), scene and (chain bA and resi 601 and resn TYR and name OH)
# G9R bA 1011 O2D ··· HOH bA 3210 O = 3.47 Å (water polar candidate)
distance d08_water, scene and (chain bA and resi 1011 and resn G9R and name O2D), scene and (chain bA and resi 3210 and resn HOH and name O)
set_color cls_mg, [0.09, 0.541, 0.235]
group Mg_ligand, d01_mg d02_mg
set dash_color, cls_mg, Mg_ligand
set dash_length, 0.3, Mg_ligand
set dash_gap, 0.0, Mg_ligand
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d03_polar d04_polar d05_polar d06_polar d07_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate
set_color cls_water, [0.043, 0.498, 0.612]
group water_polar_candidate, d08_water
set dash_color, cls_water, water_polar_candidate
set dash_length, 0.25, water_polar_candidate
set dash_gap, 0.18, water_polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain bA and resi 1011 and resn G9R and name MG), "PA"
label scene and (chain bA and resi 601 and resn TYR and name CA), "Tyr601 bA"
label scene and (chain bA and resi 609 and resn PHE and name CA), "Phe609 bA"
label scene and (chain bA and resi 652 and resn LEU and name CA), "Leu652 bA"
label scene and (chain bA and resi 678 and resn HIS and name CA), "His678 bA"
label scene and (chain bA and resi 681 and resn TRP and name CA), "Trp681 bA"
label scene and (chain bA and resi 733 and resn TYR and name CA), "Tyr733 bA"
label scene and (chain bA and resi 741 and resn SER and name CA), "Ser741 bA"
label scene and (chain bA and resi 3210 and resn HOH and name O), "HOH3210 bA"
label scene and (chain bB and resi 1021 and resn CL7 and name MG), "PB"
label scene and (chain bB and resi 592 and resn PHE and name CA), "Phe592 bB"
label scene and (chain bB and resi 624 and resn LEU and name CA), "Leu624 bB"
label scene and (chain bB and resi 654 and resn HIS and name CA), "His654 bB"
label scene and (chain bB and resi 657 and resn TRP and name CA), "Trp657 bB"
label scene and (chain bB and resi 717 and resn TYR and name CA), "Tyr717 bB"
label scene and (chain bB and resi 720 and resn THR and name CA), "Thr720 bB"
label scene and (chain bB and resi 721 and resn TYR and name CA), "Tyr721 bB"
label scene and (chain bB and resi 724 and resn PHE and name CA), "Phe724 bB"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.214996, 0.776735, 0.591996, -0.497127, -0.608802, 0.618244, 0.840620, -0.161377, 0.517026, 0.000000, -1.676848, -123.621124, 356.148987, 359.407990, 300.950989, 104.234612, 143.007629, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
