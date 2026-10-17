# PSI Contact Atlas — 9SK3 protomer 3, special pair
# Acaryochloris marina NIES-2412 · Chl d / P740 · Cryo-EM 2.63 Å
#
# Run from the repository root:   pymol downloads/pymol/9SK3_prot3_special_pair.pml
# Distances are Euclidean heavy-atom separations (Å). Short N/O···O pairs are hydrogen-bond CANDIDATES:
# hydrogens, protonation and angles are not modelled. Chain IDs are case-sensitive author IDs.

reinitialize
# chain IDs such as 'a' and 'A' are different chains. Use author chain/residue numbering as the library does.
set ignore_case, 0
set cif_use_auth, 1
load downloads/cif/9SK3_prot3_special_pair.cif, scene
# To start from the full deposited entry instead, replace the line above with:
#   fetch 9SK3, scene, type=cif
select lib_atoms, scene and ((chain cB and resi 592+624+654+657+717+720+721+724+1021) or (chain cA and resi 601+609+652+678+681+733+741+1011+3210))

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
set_bond stick_radius, 0.16, scene and ((chain cB and resi 1021 and resn CL7) or (chain cA and resi 1011 and resn G9R))

# --- measured pairs (the comment above each line gives the library value, PyMOL recomputes it)
set dash_radius, 0.035
set label_distance_digits, 2
set label_size, 18
set label_color, black
# G9R cA 1011 MG ··· HIS cA 678 NE2 = 2.30 Å (Mg ligand)
distance d01_mg, scene and (chain cA and resi 1011 and resn G9R and name MG), scene and (chain cA and resi 678 and resn HIS and name NE2)
# CL7 cB 1021 MG ··· HIS cB 654 NE2 = 2.30 Å (Mg ligand)
distance d02_mg, scene and (chain cB and resi 1021 and resn CL7 and name MG), scene and (chain cB and resi 654 and resn HIS and name NE2)
# G9R cA 1011 O1A ··· TYR cA 733 OH = 2.80 Å (polar candidate)
distance d03_polar, scene and (chain cA and resi 1011 and resn G9R and name O1A), scene and (chain cA and resi 733 and resn TYR and name OH)
# G9R cA 1011 OBD ··· SER cA 741 OG = 3.08 Å (polar candidate)
distance d04_polar, scene and (chain cA and resi 1011 and resn G9R and name OBD), scene and (chain cA and resi 741 and resn SER and name OG)
# CL7 cB 1021 O1D ··· TYR cB 721 N = 3.16 Å (polar candidate)
distance d05_polar, scene and (chain cB and resi 1021 and resn CL7 and name O1D), scene and (chain cB and resi 721 and resn TYR and name N)
# G9R cA 1011 O2D ··· TYR cA 601 OH = 3.41 Å (polar candidate)
distance d06_polar, scene and (chain cA and resi 1011 and resn G9R and name O2D), scene and (chain cA and resi 601 and resn TYR and name OH)
# CL7 cB 1021 O2A ··· TYR cB 717 OH = 3.43 Å (polar candidate)
distance d07_polar, scene and (chain cB and resi 1021 and resn CL7 and name O2A), scene and (chain cB and resi 717 and resn TYR and name OH)
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

# --- labels (residues at the library anchor atoms, roles as plain text)
set label_font_id, 7
set label_size, 16
set float_labels, 1
label scene and (chain cB and resi 1021 and resn CL7 and name MG), "PB"
label scene and (chain cB and resi 592 and resn PHE and name CA), "Phe592 cB"
label scene and (chain cB and resi 624 and resn LEU and name CA), "Leu624 cB"
label scene and (chain cB and resi 654 and resn HIS and name CA), "His654 cB"
label scene and (chain cB and resi 657 and resn TRP and name CA), "Trp657 cB"
label scene and (chain cB and resi 717 and resn TYR and name CA), "Tyr717 cB"
label scene and (chain cB and resi 720 and resn THR and name CA), "Thr720 cB"
label scene and (chain cB and resi 721 and resn TYR and name CA), "Tyr721 cB"
label scene and (chain cB and resi 724 and resn PHE and name CA), "Phe724 cB"
label scene and (chain cA and resi 1011 and resn G9R and name MG), "PA"
label scene and (chain cA and resi 601 and resn TYR and name CA), "Tyr601 cA"
label scene and (chain cA and resi 609 and resn PHE and name CA), "Phe609 cA"
label scene and (chain cA and resi 652 and resn LEU and name CA), "Leu652 cA"
label scene and (chain cA and resi 678 and resn HIS and name CA), "His678 cA"
label scene and (chain cA and resi 681 and resn TRP and name CA), "Trp681 cA"
label scene and (chain cA and resi 733 and resn TYR and name CA), "Tyr733 cA"
label scene and (chain cA and resi 741 and resn SER and name CA), "Ser741 cA"
label scene and (chain cA and resi 3210 and resn HOH and name O), "HOH3210 cA"

# --- the reviewed starting orientation used by the library (orthoscopic)
set_view (-0.538248, 0.137613, 0.831475, -0.064618, 0.976937, -0.203517, -0.840305, -0.163271, -0.516942, 0.000000, -1.659562, -123.262657, 261.718994, 329.971008, 300.933990, 103.917870, 142.607452, 20.000000)
zoom lib_atoms, 2, complete=1
deselect
