"""P_A 13^1-keto oxygen (OBD) to the side-chain hydroxyl at the 1JB0 Thr743 position, protomer 1 of six entries.

In PyMOL:  run tools/pymol_compare_example.py
Atom identities are native (component:author chain:author residue:atom); the partner residue differs
between entries (Thr OG1 in most, Ser OG in the chlorophyll d entry 7COY), which is why each pair is
listed explicitly. Generated from the library's compare data; 'library' is the value the site shows.
"""
from pymol import cmd

CIF_DIR = None   # None: fetch from the PDB (needs internet). Or a folder containing e.g. 1JB0.cif

PAIRS = [  # (PDB, P_A atom, partner atom, library value in Å)
    ('1JB0', 'CLA:A:1011:OBD', 'THR:A:743:OG1', 2.98),
    ('6KMW', 'CL0:aA:801:OBD', 'THR:aA:752:OG1', 3.12),
    ('6KMX', 'CL0:aA:801:OBD', 'THR:aA:772:OG1', 3.25),
    ('9EYS', 'CL0:A:801:OBD', 'THR:A:770:OG1', 2.87),
    ('9YL7', 'CL0:A:802:OBD', 'THR:A:739:OG1', 2.89),
    ('7COY', 'G9R:aA:3101:OBD', 'SER:aA:741:OG', 2.76),
]


def atom(obj, ident):
    comp, chain, resi, name = ident.split(':')
    return f'{obj} and chain {chain} and resi {resi} and resn {comp} and name {name}'


cmd.set('ignore_case', 0)      # author chain IDs are case-sensitive
for pdb, a, b, library in PAIRS:
    if pdb not in cmd.get_names():
        if CIF_DIR:
            cmd.load(f'{CIF_DIR}/{pdb}.cif', pdb)
        else:
            cmd.fetch(pdb, type='cif', quiet=1)
    d = cmd.get_distance(atom(pdb, a), atom(pdb, b))
    print(f'{pdb}  {a:>18} ... {b:<16} PyMOL {d:.2f} A   library {library:.2f} A')
