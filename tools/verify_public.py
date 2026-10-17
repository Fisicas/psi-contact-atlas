"""Recompute every number the PSI distance-contact library displays, from deposited PDB files.

    python verify_public.py --cif-dir path/to/mmcif            # use local copies (PDBID.cif)
    python verify_public.py --cif-dir cif_cache --download     # fetch missing files from files.rcsb.org

Needs Python 3.9+ and gemmi (pip install gemmi). Checks:
  * every scene atom coordinate (data/views/*.js) against the deposited file;
  * every displayed contact distance, and the CSV value at 0.01 Å;
  * every compare-matrix cell (data/atlas.js).
PDB entries can be revised after this library was built; data/sources.json lists the SHA-256 of the
files used, and a different hash is reported (not treated as an error) before values are compared.
"""
import argparse, csv, hashlib, json, math, sys, urllib.request
from pathlib import Path

import gemmi

HERE = Path(__file__).resolve().parent.parent


def load_js(path, prefix):
    text = path.read_text(encoding='utf-8')
    return json.loads(text[text.index('=', text.index(prefix)) + 1:].rstrip().rstrip(';'))


class Coords:
    def __init__(self, cif_dir, download):
        self.dir, self.download, self.cache, self.hashes = Path(cif_dir), download, {}, {}

    def path(self, pdb):
        p = self.dir / f'{pdb}.cif'
        if not p.exists():
            if not self.download:
                raise SystemExit(f'missing {p}; pass --download to fetch it from RCSB')
            self.dir.mkdir(parents=True, exist_ok=True)
            urllib.request.urlretrieve(f'https://files.rcsb.org/download/{pdb}.cif', p)
        return p

    def index(self, pdb):
        if pdb not in self.cache:
            p = self.path(pdb)
            self.hashes[pdb] = hashlib.sha256(p.read_bytes()).hexdigest()
            st = gemmi.read_structure(str(p))
            idx = {}
            for ch in st[0]:
                for r in ch:
                    rid = str(r.seqid.num) + (r.seqid.icode.strip() or '')
                    for a in r:
                        k = (r.name, ch.name, rid, a.name)
                        if k not in idx or a.occ > idx[k][1]:
                            idx[k] = ((a.pos.x, a.pos.y, a.pos.z), a.occ)
            self.cache[pdb] = idx
        return self.cache[pdb]

    def xyz(self, pdb, ident):
        comp, chain, res, atom = ident.split(':')
        return self.index(pdb)[(comp, chain, res, atom)][0]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--cif-dir', default=str(HERE / 'cif_cache'))
    ap.add_argument('--download', action='store_true')
    a = ap.parse_args()
    C = Coords(a.cif_dir, a.download)
    fails, n_atoms, n_contacts, n_cells = [], 0, 0, 0
    rows = {}
    with open(HERE / 'downloads' / 'all_contacts.csv', encoding='utf-8') as fh:
        for r in csv.DictReader(fh):
            rows[(r['view'], r['atom_1'], r['atom_2'])] = float(r['distance_A'])
    for f in sorted((HERE / 'data' / 'views').glob('*.js')):
        sc = load_js(f, 'PSI_VIEWS[')
        ids = []
        for at in sc['atoms']:
            r = sc['residues'][at[2]]
            ident = f"{r['comp']}:{r['chain']}:{r['num']}:{at[0]}"
            ids.append(ident)
            p = C.xyz(sc['pdb'], ident)
            if max(abs(p[k] - at[3 + k]) for k in range(3)) > 6e-4:
                fails.append(f"{sc['key']}: {ident} coordinate differs")
            n_atoms += 1
        for c in sc['contacts']:
            d = math.dist(C.xyz(sc['pdb'], ids[c['i']]), C.xyz(sc['pdb'], ids[c['j']]))
            if abs(d - c['d']) > 1e-4:
                fails.append(f"{sc['key']}: {ids[c['i']]}···{ids[c['j']]} shown {c['d']:.4f}, recomputed {d:.4f}")
            ref = rows.get((sc['key'], ids[c['i']], ids[c['j']]))
            if ref is None or f'{ref:.2f}' != f"{c['d']:.2f}":
                fails.append(f"{sc['key']}: CSV disagrees for {ids[c['i']]}···{ids[c['j']]}")
            n_contacts += 1
    atlas = load_js(HERE / 'data' / 'atlas.js', 'PSI_ATLAS')
    for part, rws in atlas['compare'].items():
        for row in rws:
            for c in row['cells']:
                if 'd' in c:
                    d = math.dist(C.xyz(c['pdb'], c['a']), C.xyz(c['pdb'], c['b']))
                    if abs(d - c['d']) > 1e-4:
                        fails.append(f"compare {part} {c['pdb']} p{c['protomer']}: shown {c['d']:.4f}, recomputed {d:.4f}")
                    n_cells += 1
    sources = json.loads((HERE / 'data' / 'sources.json').read_text(encoding='utf-8'))
    revised = [p for p, h in C.hashes.items() if sources.get(p, {}).get('sha256') != h]
    print(json.dumps(dict(status='PASS' if not fails else 'FAIL', scene_atoms=n_atoms, contacts=n_contacts,
                          compare_cells=n_cells, files_differing_from_build=revised), indent=1))
    for f in fails[:40]:
        print('  ', f)
    sys.exit(1 if fails else 0)


if __name__ == '__main__':
    main()
