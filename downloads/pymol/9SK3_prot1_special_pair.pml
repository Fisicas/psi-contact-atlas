# PSI Contact Atlas — 9SK3 protomer 1, special pair
# Acaryochloris marina NIES-2412 · Chl d / P740 · Cryo-EM 2.63 Å
#
# Run from the repository root:   pymol downloads/pymol/9SK3_prot1_special_pair.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9SK3_prot1_special_pair.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9SK3, scene, type=cif
select lib_atoms, scene and ((chain aA and resi 601+609+652+678+681+733+741+1011+3210) or (chain aB and resi 592+624+654+657+717+720+721+724+1021))

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
set_bond stick_radius, 0.16, scene and ((chain aA and resi 1011 and resn G9R) or (chain aB and resi 1021 and resn CL7))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# CL7 aB 1021 MG ··· HIS aB 654 NE2 = 2.30 Å (Mg ligand)
distance d01_mg, scene and (chain aB and resi 1021 and resn CL7 and name MG), scene and (chain aB and resi 654 and resn HIS and name NE2)
# G9R aA 1011 MG ··· HIS aA 678 NE2 = 2.30 Å (Mg ligand)
distance d02_mg, scene and (chain aA and resi 1011 and resn G9R and name MG), scene and (chain aA and resi 678 and resn HIS and name NE2)
# G9R aA 1011 O1A ··· TYR aA 733 OH = 2.87 Å (polar candidate)
distance d03_polar, scene and (chain aA and resi 1011 and resn G9R and name O1A), scene and (chain aA and resi 733 and resn TYR and name OH)
# G9R aA 1011 OBD ··· SER aA 741 OG = 3.01 Å (polar candidate)
distance d04_polar, scene and (chain aA and resi 1011 and resn G9R and name OBD), scene and (chain aA and resi 741 and resn SER and name OG)
# CL7 aB 1021 O1D ··· TYR aB 721 N = 3.10 Å (polar candidate)
distance d05_polar, scene and (chain aB and resi 1021 and resn CL7 and name O1D), scene and (chain aB and resi 721 and resn TYR and name N)
# G9R aA 1011 O2D ··· TYR aA 601 OH = 3.41 Å (polar candidate)
distance d06_polar, scene and (chain aA and resi 1011 and resn G9R and name O2D), scene and (chain aA and resi 601 and resn TYR and name OH)
# G9R aA 1011 O2D ··· HOH aA 3210 O = 3.40 Å (water polar candidate)
distance d07_water, scene and (chain aA and resi 1011 and resn G9R and name O2D), scene and (chain aA and resi 3210 and resn HOH and name O)
set_color cls_mg, [0.09, 0.541, 0.235]
group Mg_ligand, d01_mg d02_mg
set dash_color, cls_mg, Mg_ligand
set dash_length, 0.3, Mg_ligand
set dash_gap, 0.0, Mg_ligand
set_color cls_polar, [0.114, 0.165, 0.227]
group polar_candidate, d03_polar d04_polar d05_polar d06_polar
set dash_color, cls_polar, polar_candidate
set dash_length, 0.25, polar_candidate
set dash_gap, 0.18, polar_candidate
set_color cls_water, [0.043, 0.498, 0.612]
group water_polar_candidate, d07_water
set dash_color, cls_water, water_polar_candidate
set dash_length, 0.25, water_polar_candidate
set dash_gap, 0.18, water_polar_candidate

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain aA and resi 601 and resn TYR and name CA), "Tyr601 aA"
label scene and (chain aA and resi 609 and resn PHE and name CA), "Phe609 aA"
label scene and (chain aA and resi 652 and resn LEU and name CA), "Leu652 aA"
label scene and (chain aA and resi 678 and resn HIS and name CA), "His678 aA"
label scene and (chain aA and resi 681 and resn TRP and name CA), "Trp681 aA"
label scene and (chain aA and resi 733 and resn TYR and name CA), "Tyr733 aA"
label scene and (chain aA and resi 741 and resn SER and name CA), "Ser741 aA"
label scene and (chain aA and resi 1011 and resn G9R and name MG), "PA"
label scene and (chain aA and resi 3210 and resn HOH and name O), "HOH3210 aA"
label scene and (chain aB and resi 592 and resn PHE and name CA), "Phe592 aB"
label scene and (chain aB and resi 624 and resn LEU and name CA), "Leu624 aB"
label scene and (chain aB and resi 654 and resn HIS and name CA), "His654 aB"
label scene and (chain aB and resi 657 and resn TRP and name CA), "Trp657 aB"
label scene and (chain aB and resi 717 and resn TYR and name CA), "Tyr717 aB"
label scene and (chain aB and resi 720 and resn THR and name CA), "Thr720 aB"
label scene and (chain aB and resi 721 and resn TYR and name CA), "Tyr721 aB"
label scene and (chain aB and resi 724 and resn PHE and name CA), "Phe724 aB"
label scene and (chain aB and resi 1021 and resn CL7 and name MG), "PB"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.323421, -0.914877, 0.241657, 0.428980, -0.369391, -0.824334, 0.843431, -0.162941, 0.511933, 0.000000, -1.666912, -123.455902, 334.402008, 262.855011, 300.940002, 104.088623, 142.823181, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
