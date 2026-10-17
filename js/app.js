/* PSI Contact Atlas — static, file:// compatible, no dependencies. */
'use strict';
(function () {
  const A = window.PSI_ATLAS;
  const { ContactViewer, CLASS_STYLE } = window.PSIViewer;
  const $ = (s, r = document) => r.querySelector(s);
  const app = $('#app');
  const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  /* scientific typography: P_A → P<sub>A</sub>, A1_A → A<sub>1A</sub>, B_iso, Å² */
  const sci = s => esc(s).replace(/\bP_([AB])\b/g, 'P<sub>$1</sub>').replace(/\bA1_([AB])\b/g, 'A<sub>1$1</sub>')
    .replace(/\bA1([AB])\b(?![-\w])/g, 'A<sub>1$1</sub>').replace(/B_iso/g, 'B<sub>iso</sub>').replace(/Å²/g, 'Å<sup>2</sup>')
    .replace(/\bChl a′/g, 'Chl <i>a</i>′').replace(/\bChl a\b/g, 'Chl <i>a</i>').replace(/\bChl d′/g, 'Chl <i>d</i>′').replace(/\bChl d\b/g, 'Chl <i>d</i>');
  const PART = Object.fromEntries(A.parts.map(p => [p.key, p]));
  const PART_BY_ROUTE = Object.fromEntries(A.parts.map(p => [p.route, p]));
  const PART_BLURB = {
    special_pair: 'P_A/P_B chlorophylls with axial ligands, keto/ester partners and nearby water.',
    P_A: 'The P_A pigment alone with its Thr/Ser–Tyr–water network, at a common physical scale.',
    A1A: 'A-branch quinone headgroup: Leu/Met backbone N and the Trp/Ser side of the pocket.',
    A1B: 'B-branch quinone headgroup with the homologous PsaB partners.',
  };
  const S = Object.fromEntries(A.structures.map(s => [s.pdb, s]));
  const viewerPool = new Set();
  const commonExtent = {};
  for (const s of A.structures) for (const p of s.protomers) for (const v of p.views) {
    const e = commonExtent[v.part] || [0, 0];
    commonExtent[v.part] = [Math.max(e[0], v.roi[0]), Math.max(e[1], v.roi[1])];
  }

  /* ---------- lazy scene loading (script tags work from file://) ---------- */
  const loading = {};
  function loadScene(key) {
    if (window.PSI_VIEWS?.[key]) return Promise.resolve(window.PSI_VIEWS[key]);
    if (!loading[key]) loading[key] = new Promise((res, rej) => {
      const sc = document.createElement('script'); sc.src = `data/views/${key}.js`; sc.async = true;
      sc.onload = () => window.PSI_VIEWS?.[key] ? res(window.PSI_VIEWS[key]) : rej(new Error('scene missing'));
      sc.onerror = () => rej(new Error('Could not load ' + sc.src)); document.head.appendChild(sc);
    });
    return loading[key];
  }

  /* ---------- small helpers ---------- */
  const methodShort = m => m.startsWith('X-ray') ? 'X-ray' : 'Cryo-EM';
  const condKind = c => /FRL/.test(c) ? 'frl' : /Chl d/.test(c) ? 'chld' : /MenB|PQ-9|DMPBQ/.test(c) ? 'quinone' : 'ref';
  const isXray = s => (s.technique?.method || s.method).toUpperCase().startsWith('X-RAY');
  const titleCaseWords = t => String(t || '').toLowerCase().replace(/\b([a-z])/g, m => m.toUpperCase()).replace(/\bTfs\b/, 'TFS').replace(/\bFei\b/, 'FEI').replace(/\bJeol\b/, 'JEOL').replace(/\b(Ii|Iii|Iv)\b/g, m => m.toUpperCase()).replace(/Bioquantum/, 'BioQuantum').replace(/(\d)k X (\d)k/i, '$1k × $2k');
  const fmtInt = n => n ? Number(n).toLocaleString('en-US') : '';
  const STILL = /[?&]still=1/.test(location.search);   // static start (screenshots, printing)
  const MOTION = () => STILL || matchMedia('(prefers-reduced-motion: reduce)').matches ? 'off' : 'spin';
  const tag = (text, kind = '') => `<span class="tag ${kind}">${sci(text)}</span>`;
  const roleTag = r => `<span class="role ${r.startsWith('P') ? 'pig' : 'qui'}">${sci(r)}</span>`;
  const viewKey = (pdb, n, part) => `${pdb}_prot${n}_${part}`;
  const routeView = key => `#/view/${key}`;
  function parseKey(key) { const m = /^(\w{4})_prot(\d+)_(.+)$/.exec(key); return m ? { pdb: m[1], n: +m[2], part: m[3] } : null; }
  function chainTitle(p) { return `PsaA ${p.psaA} · PsaB ${p.psaB}`; }
  const PUBLIC = !!window.PSI_PUBLIC;
  function title(t) { document.title = t ? `${t} · PSI Contact Atlas` : 'PSI Contact Atlas'; }
  function cleanup() { for (const v of viewerPool) v.destroy(); viewerPool.clear(); }
  function cofactorName(c) { return c ? c.name : 'not established'; }
  function shortOrg(o) { const p = o.split(' '); return p.length > 1 ? `${p[0][0]}. ${p.slice(1).join(' ')}` : o; }

  /* ---------- router ---------- */
  function route() {
    cleanup();
    const h = location.hash.replace(/^#\/?/, '');
    const [page, a, b] = h.split('/');
    document.querySelectorAll('.nav a').forEach(x => x.removeAttribute('aria-current'));
    const nav = page === 'compare' ? 'compare' : page === 'methods' ? 'methods' : 'library';
    $(`.nav a[data-nav="${nav}"]`)?.setAttribute('aria-current', 'page');
    try {
      if (page === 'structure' && S[a]) renderStructure(a, +(b || 1));
      else if (page === 'view' && parseKey(a) && S[parseKey(a).pdb]) renderView(a);
      else if (page === 'compare') renderCompare(PART_BY_ROUTE[a]?.key || 'P_A');
      else if (page === 'methods') renderMethods();
      else renderHome();
    } catch (err) { app.innerHTML = `<div class="wrap"><p class="error">Page error: ${esc(err.message)}</p></div>`; console.error(err); }
    if (page === 'structures') requestAnimationFrame(() => $('#structures')?.scrollIntoView({ block: 'start' }));
    else if (!history.state?.keepScroll) window.scrollTo(0, 0);
    app.focus({ preventScroll: true });
  }
  window.addEventListener('hashchange', route);

  /* ================= HOME ================= */
  function renderHome() {
    title('');
    const c = A.counts;
    const xray = A.structures.filter(isXray), em = A.structures.filter(s => !isXray(s));
    const conds = [['all', 'All conditions'], ['frl', 'Far-red light'], ['chld', 'Chl <i>d</i> / P740'], ['quinone', 'Quinone variants'], ['ref', 'Reference &amp; other']];
    const focusTables = /[?&]focus=structures/.test(location.search);   // capture option: tables without the hero
    const methods = [['all', 'All methods'], ['xray', `X-ray (${xray.length})`], ['em', `Cryo-EM (${em.length})`]];
    app.innerHTML = `
    <section class="hero wrap"${focusTables ? ' hidden' : ''}>
      <div class="hero-text">
        <p class="kicker">Photosystem I · deposited structures · native coordinates</p>
        <h1>How the P<sub>A</sub> and A<sub>1</sub> pockets differ across PSI structures</h1>
        <p class="lede">Heavy-atom separations around the special pair, the isolated P<sub>A</sub> network and both quinone sites, for every deposited protomer of ${c.structures} entries. Rotate any scene, follow a number to its atom pair, or compare one contact across all ${c.protomers} protomers.</p>
        <div class="hero-actions"><a class="btn primary" href="#/compare/pa-network">Compare P<sub>A</sub> networks</a><a class="btn" href="#/compare/a1a">Compare A<sub>1A</sub> sites</a><a class="btn ghost" href="#/methods">How values were checked</a></div>
        <dl class="stats">
          <div><dt>Structures</dt><dd>${c.structures}</dd></div><div><dt>Protomers</dt><dd>${c.protomers}</dd></div>
          <div><dt>Scenes</dt><dd>${c.views}</dd></div><div><dt>Measured pairs</dt><dd>${c.contacts}</dd></div>
        </dl>
      </div>
      <figure class="hero-fig"><div class="hero-host" id="hero-host"></div>
        <figcaption><a id="hero-link" href="#/view/9YL7_prot1_A1A"></a><button id="hero-next" class="link" type="button">next scene</button></figcaption></figure>
    </section>
    <section class="wrap" id="structures">
      <div class="section-head"><h2>Structures by experimental method</h2>
        <label class="search"><span class="sr">Search</span><input id="q" type="search" placeholder="Search PDB, organism, quinone…" autocomplete="off"></label></div>
      <div class="filter-rows">
        <div class="filters" role="group" aria-label="Filter by method"><span class="flabel">Method</span>${methods.map(([k, l], i) => `<button class="chip" data-m="${k}" aria-pressed="${i === 0}">${l}</button>`).join('')}</div>
        <div class="filters" role="group" aria-label="Filter by condition"><span class="flabel">Condition</span>${conds.map(([k, l], i) => `<button class="chip" data-f="${k}" aria-pressed="${i === 0}">${l}</button>`).join('')}</div>
      </div>
      <div id="groups"></div>
      <p class="fine">Method fields are read from each deposited mmCIF; a blank or “—” means the field is not recorded there. Deposited component identities sit next to interpreted pigment names (a deposited CLA at P<sub>A</sub> is not reassigned to Chl <i>a</i>′). Protomers within an entry are not independent replicates.</p>
    </section>
    <section class="wrap">
      <div class="section-head"><h2>Compare one environment across every protomer</h2></div>
      <div class="part-cards">${A.parts.map(p => `<a class="part-card" href="#/compare/${p.route}"><span class="pc-title">${sci(p.label)}</span><span class="pc-text">${sci(PART_BLURB[p.key])}</span><span class="pc-meta">${A.compare[p.key].length} homologous contacts × ${c.protomers} protomers →</span></a>`).join('')}</div>
    </section>`;

    // live hero molecule, cycling through representative scenes
    const heroKeys = ['9YL7_prot1_A1A', '1JB0_prot1_P_A', '7COY_prot1_special_pair', '9AU4_prot1_A1B'];
    let hi = 0, heroViewer = null;
    const showHero = () => {
      const key = heroKeys[hi % heroKeys.length], k = parseKey(key), st = S[k.pdb];
      loadScene(key).then(sc => {
        const host = $('#hero-host'); if (!host) return;
        if (heroViewer) { heroViewer.destroy(); viewerPool.delete(heroViewer); }
        host.innerHTML = '';
        heroViewer = new ContactViewer(host, sc, { compact: true, interactive: false, motion: MOTION(), scaleMode: 'common' });
        viewerPool.add(heroViewer);
        const link = $('#hero-link');
        link.innerHTML = `${k.pdb} · ${sci(PART[k.part].label)} · <i>${esc(shortOrg(st.organism))}</i> · ${esc(st.condition)} <span aria-hidden="true">→</span>`;
        link.href = routeView(key);
      });
    };
    showHero();
    $('#hero-next').addEventListener('click', () => { hi++; showHero(); });
    $('#hero-host').addEventListener('click', () => { location.hash = $('#hero-link').getAttribute('href'); });

    let cond = 'all', meth = 'all';
    const td = (label, html, cls = '') => `<td${cls ? ` class="${cls}"` : ''}><span class="ml" aria-hidden="true">${label}</span>${html}</td>`;
    const common = s => {
      const cf = s.protomers[0].cofactors;
      return td('Entry', `<a class="pdb" href="#/structure/${s.pdb}">${s.pdb}</a>`) +
        td('Organism', `<i>${esc(s.organism)}</i><small>${esc(s.context)}</small>`) +
        td('Condition', tag(s.condition, condKind(s.condition))) +
        td('P<sub>A</sub> / P<sub>B</sub>', `${sci(cofactorName(cf.P_A))}<small>${sci(cofactorName(cf.P_B))}</small>`) +
        td('A<sub>1A</sub> / A<sub>1B</sub>', `${sci(cofactorName(cf.A1_A))}<small>${sci(cofactorName(cf.A1_B))}</small>`);
    };
    const head = extra => `<thead><tr><th>Entry</th><th>Organism</th><th>Condition</th><th>P<sub>A</sub> / P<sub>B</sub></th><th>A<sub>1A</sub> / A<sub>1B</sub></th>${extra.map(h => `<th>${h}</th>`).join('')}<th class="num">Prot.</th><th><span class="sr">Open</span></th></tr></thead>`;
    const tail = s => td('Protomers', s.protomers.length, 'num') + `<td class="go"><a href="#/structure/${s.pdb}" aria-label="Open ${s.pdb}">→</a></td>`;
    const group = (name, blurb, list, extraHead, extraCells) => list.length ? `
      <section class="method-group"><header><h3>${name} <span class="count">${list.length} ${list.length === 1 ? 'entry' : 'entries'}</span></h3><p>${blurb}</p></header>
      <div class="table-scroll"><table class="structures">${head(extraHead)}<tbody>${list.map(s => `<tr data-href="#/structure/${s.pdb}">${common(s)}${extraCells(s)}${tail(s)}</tr>`).join('')}</tbody></table></div></section>` : '';
    const xrayCells = s => {
      const t = s.technique || {};
      return td('Resolution', `${esc(t.resolution_A || s.resolution)} Å`, 'num') + td('Space group', esc(t.space_group || '—')) +
        td('Phasing', esc(t.phasing || '—')) + td('R<sub>work</sub> / R<sub>free</sub>', t.R_work ? `${(+t.R_work).toFixed(3)} / ${(+t.R_free).toFixed(3)}` : '—', 'num') +
        td('Data', [t.temperature_K ? t.temperature_K + ' K' : '', t.source || ''].filter(Boolean).join(' · ') || '—');
    };
    const emCells = s => {
      const t = s.technique || {};
      return td('Resolution', `${esc(t.resolution_A || s.resolution)} Å`, 'num') + td('Symmetry', esc(t.point_symmetry || '—')) +
        td('Particles', fmtInt(t.particles) || '—', 'num') +
        td('Microscope · detector', `${esc(titleCaseWords(t.microscope))}<small>${esc(titleCaseWords(t.detector))}</small>`) +
        td('Map', t.emdb ? `<a href="https://www.ebi.ac.uk/emdb/${esc(t.emdb)}">${esc(t.emdb)}</a>` : '—');
    };
    const draw = () => {
      const q = $('#q').value.trim().toLowerCase();
      const keep = s => (cond === 'all' || condKind(s.condition) === cond) &&
        JSON.stringify([s.pdb, s.organism, s.condition, s.method, s.technique, s.protomers[0].cofactors]).toLowerCase().includes(q);
      const byRes = (a, b) => parseFloat(a.resolution) - parseFloat(b.resolution);
      const xs = meth === 'em' ? [] : xray.filter(keep).sort(byRes), es = meth === 'xray' ? [] : em.filter(keep).sort(byRes);
      $('#groups').innerHTML = (group('X-ray crystallography',
        'Diffraction from crystals; atomic model refined against structure factors. Resolution is d<sub>min</sub>; R<sub>work</sub>/R<sub>free</sub>, phasing and data temperature as deposited.',
        xs, ['Resolution', 'Space group', 'Phasing', 'R<sub>work</sub> / R<sub>free</sub>', 'Data'], xrayCells) +
        group('Single-particle cryo-EM',
        'Particle images averaged into a 3D Coulomb-potential map; resolution by the FSC 0.143 criterion. “Symmetry” is the point symmetry recorded for the reconstruction (— if not recorded). Protomers built into a symmetrised map are not independent measurements, even when their refined models differ slightly.',
        es, ['Resolution', 'Symmetry', 'Particles', 'Microscope · detector', 'Map'], emCells)) ||
        '<p class="empty">No structure matches these filters.</p>';
      $('#groups').querySelectorAll('tr[data-href]').forEach(tr => tr.addEventListener('click', e => { if (!e.target.closest('a')) location.hash = tr.dataset.href; }));
    };
    app.querySelectorAll('.chip[data-f]').forEach(b => b.addEventListener('click', () => { cond = b.dataset.f; app.querySelectorAll('.chip[data-f]').forEach(x => x.setAttribute('aria-pressed', String(x === b))); draw(); }));
    app.querySelectorAll('.chip[data-m]').forEach(b => b.addEventListener('click', () => { meth = b.dataset.m; app.querySelectorAll('.chip[data-m]').forEach(x => x.setAttribute('aria-pressed', String(x === b))); draw(); }));
    $('#q').addEventListener('input', draw);
    draw();
  }

  /* ================= STRUCTURE ================= */
  function renderStructure(pdb, n) {
    const s = S[pdb], p = s.protomers.find(x => x.number === n) || s.protomers[0];
    title(`${pdb} protomer ${p.number}`);
    const cf = p.cofactors;
    app.innerHTML = `
    <div class="wrap">
      <nav class="crumbs" aria-label="Breadcrumb"><a href="#/">Library</a><span>/</span><span>${pdb}</span></nav>
      <header class="entry-head">
        <div><h1>${pdb} <span class="muted">· <i>${esc(s.organism)}</i></span></h1>
          <p class="facts">${tag(s.condition, condKind(s.condition))} ${esc(s.method)} · ${esc(s.resolution)} Å · ${esc(s.context)} · PDB v${esc(s.version)}</p>
          <p class="facts small">${techLine(s)}</p></div>
        <div class="protomer-tabs" role="tablist" aria-label="Protomer">${s.protomers.map(x => `<a role="tab" href="#/structure/${pdb}/${x.number}" aria-selected="${x.number === p.number}">Protomer ${x.number}<small>${esc(chainTitle(x))}</small></a>`).join('')}</div>
      </header>
      <p class="desc">${sci(s.description)}</p>
      ${s.notes.map(t => `<p class="note">${sci(t)}</p>`).join('')}
      <div class="cofactor-strip">${['P_A', 'P_B', 'A1_A', 'A1_B'].map(r => { const x = cf[r]; return `<div>${roleTag(r)}<b>${sci(cofactorName(x))}</b><small>${x ? esc(x.identity) + ' · label ' + esc(x.label_asym) : ''}${x?.atoms_note ? ' · ' + sci(x.atoms_note) : ''}</small></div>`; }).join('')}</div>
      <div class="scene-grid">${A.parts.map(pt => {
        const v = p.views.find(x => x.part === pt.key);
        return `<article class="scene-card" data-key="${v.key}">
          <a class="scene-link" href="${routeView(v.key)}" aria-label="Open ${pdb} protomer ${p.number} ${pt.label}"><span class="sr">Open</span></a>
          <header><h2>${sci(pt.label)}</h2><span class="muted">${v.contacts} pairs${v.shortest ? ` · shortest polar ${v.shortest.toFixed(2)} Å` : ''}</span></header>
          <div class="mini-host" aria-hidden="false"></div>
          <footer><a href="${routeView(v.key)}">Open scene & table →</a><a href="#/compare/${pt.route}">Compare</a></footer></article>`;
      }).join('')}</div>
      <div class="two-col">
        <section><h2>Model lineage</h2><ul class="lineage">${s.lineage.map(x => `<li>${linkPDB(x.text)}${x.doi ? ` <a href="https://doi.org/${esc(x.doi)}">evidence</a>${x.locator ? ' · ' + esc(x.locator) : ''}` : ''}</li>`).join('')}</ul>
          <p class="fine">Display alignment to 1JB0 is a camera convention, not model ancestry.</p></section>
        <section><h2>Citations</h2>${citations(s)}</section>
      </div>
    </div>`;
    const motion = MOTION();
    app.querySelectorAll('.scene-card').forEach(card => {
      const key = card.dataset.key, host = $('.mini-host', card);
      host.innerHTML = '<p class="loading">Loading scene…</p>';
      loadScene(key).then(sc => {
        host.innerHTML = '';
        viewerPool.add(new ContactViewer(host, sc, { compact: true, interactive: false, motion, commonExtent: commonExtent[sc.part], residueLabels: true }));
      }).catch(e => host.innerHTML = `<p class="error">${esc(e.message)}</p>`);
    });
  }
  function techLine(s) {
    const t = s.technique || {};
    if (isXray(s)) return [t.space_group && `space group ${esc(t.space_group)}`, t.phasing && `${esc(t.phasing)} phasing`,
      t.R_work && `R<sub>work</sub>/R<sub>free</sub> ${(+t.R_work).toFixed(3)}/${(+t.R_free).toFixed(3)}`, t.temperature_K && `${esc(t.temperature_K)} K`, t.source && esc(t.source)].filter(Boolean).join(' · ');
    return [t.resolution_method && esc(t.resolution_method.toLowerCase().replace('fsc', 'FSC')), `point symmetry ${esc(t.point_symmetry || 'not recorded')}`,
      t.particles && `${fmtInt(t.particles)} particles`, t.microscope && esc(titleCaseWords(t.microscope)) + (t.voltage_kV ? ` ${esc(t.voltage_kV)} kV` : ''),
      t.detector && esc(titleCaseWords(t.detector)), t.emdb && `<a href="https://www.ebi.ac.uk/emdb/${esc(t.emdb)}">${esc(t.emdb)}</a>`].filter(Boolean).join(' · ');
  }
  const linkPDB = t => esc(t).replace(/\b([0-9][A-Z0-9]{3})\b/g, m => S[m] ? `<a href="#/structure/${m}">${m}</a>` : `<a href="https://www.rcsb.org/structure/${m}">${m}</a>`);
  function citations(s) {
    return `<div class="cite"><b>PDB ${s.pdb}</b> · ${esc((s.deposition_authors || []).slice(0, 3).join(', '))}${(s.deposition_authors || []).length > 3 ? ' et al.' : ''}
      <br><a href="${esc(s.pdb_url)}">RCSB record</a> · <a href="https://doi.org/${esc(s.pdb_doi)}">doi:${esc(s.pdb_doi)}</a><small>Deposited ${esc(s.deposition_date)} · analysed v${esc(s.version)} (${esc(s.source_version_revision_date)})</small></div>` +
      s.citations.map(c => `<div class="cite"><b>${sci(c.title)}</b><br>${esc(c.author_short)} (${esc(c.year)}) · <a href="https://doi.org/${esc(c.doi)}">doi:${esc(c.doi)}</a><small>DOI and title verified ${esc(c.verified_date)}</small></div>`).join('') +
      (s.citations.length ? '' : '<p class="fine">No primary paper DOI is established on the official record (“to be published”).</p>') +
      (s.template_citations?.length ? `<p class="fine">Template literature: ${s.template_citations.map(c => `<a href="https://doi.org/${esc(c.doi)}">${esc(c.pdb)}</a>`).join(', ')}</p>` : '');
  }

  /* ================= VIEW ================= */
  function renderView(key) {
    const k = parseKey(key), s = S[k.pdb], p = s.protomers.find(x => x.number === k.n), pt = PART[k.part];
    if (!p || !pt) return renderHome();
    title(`${k.pdb} p${k.n} ${pt.label.replace(/_/g, '')}`);
    const idx = A.parts.findIndex(x => x.key === k.part);
    const prevPart = A.parts[(idx + 3) % 4], nextPart = A.parts[(idx + 1) % 4];
    // same environment in neighbouring protomers / structures
    const seq = A.structures.flatMap(x => x.protomers.map(q => viewKey(x.pdb, q.number, k.part)));
    const si = seq.indexOf(key), prevSame = seq[(si - 1 + seq.length) % seq.length], nextSame = seq[(si + 1) % seq.length];
    app.innerHTML = `
    <div class="view-page">
      <div class="view-top wrap-wide">
        <nav class="crumbs" aria-label="Breadcrumb"><a href="#/">Library</a><span>/</span><a href="#/structure/${k.pdb}/${k.n}">${k.pdb} · protomer ${k.n}</a><span>/</span><span>${sci(pt.label)}</span></nav>
        <div class="view-title"><h1>${k.pdb} <span class="muted">p${k.n}</span> · ${sci(pt.label)}</h1>
          <div class="part-switch" role="tablist" aria-label="Environment">${A.parts.map(x => `<a role="tab" href="${routeView(viewKey(k.pdb, k.n, x.key))}" aria-selected="${x.key === k.part}">${sci(x.label.replace(' network', '').replace(' quinone', ''))}</a>`).join('')}</div>
          <div class="stepper"><a href="${routeView(prevSame)}" title="Previous protomer, same environment ( [ )">← ${esc(prevSame.split('_prot').join(' p').split('_')[0])}</a><a href="${routeView(nextSame)}" title="Next protomer, same environment ( ] )">${esc(nextSame.split('_prot').join(' p').split('_')[0])} →</a></div></div>
        <p class="facts"><i>${esc(s.organism)}</i> · ${tag(s.condition, condKind(s.condition))} ${methodShort(s.method)} ${esc(s.resolution)} Å · ${esc(chainTitle(p))}</p>
      </div>
      <div class="view-body wrap-wide">
        <section class="stage-col">
          <div class="toolbar" role="toolbar" aria-label="Scene controls">
            <div class="seg" role="group" aria-label="Motion"><button data-m="spin">Spin</button><button data-m="rock">Rock</button><button data-m="off">Hold</button></div>
            <div class="seg" role="group" aria-label="Scale"><button data-s="common" title="One Å-per-pixel for all 28 ${esc(pt.label.replace(/_/g, ''))} scenes; the largest measured region stays in frame through a full spin">Common scale</button><button data-s="whole" title="Fit this scene so every deposited atom stays in frame through a full spin">Whole molecule</button></div>
            <div class="seg" role="group" aria-label="Labels"><button data-l="residueLabels" aria-pressed="true">Residues</button><button data-l="distanceLabels" aria-pressed="true">Distances</button></div>
            <span class="grow"></span>
            <button id="reset" title="Return to the accepted still orientation (R)">Reset</button>
            <button id="png" title="Download a 2560-px PNG of the current view">PNG</button>
            <button id="gifbtn" aria-expanded="false" aria-controls="gif-panel" title="Make an animated GIF of one full turn from the current view">GIF</button>
            <button id="fs" title="Fullscreen">⤢</button>
          </div>
          <div class="gif-panel" id="gif-panel" hidden>
            <p class="gp-title"><b>Animated GIF</b> · one full turn from the current view, made in your browser. Uses the current scale and label settings; labels ride with their atoms and fade where they overlap.</p>
            <div class="gp-row"><span class="gp-label">Width</span><div class="seg" role="group" aria-label="GIF width"><button data-gw="480" aria-pressed="true">480 px</button><button data-gw="800">800 px</button><button data-gw="1200">1200 px</button></div><span class="gp-hint" id="gp-size">≈ 1–3 MB</span></div>
            <div class="gp-row"><span class="gp-label">Turn</span><div class="seg" role="group" aria-label="Time for one full turn"><button data-gt="6">6 s</button><button data-gt="10" aria-pressed="true">10 s</button><button data-gt="15">15 s</button></div></div>
            <div class="gp-row"><button id="gif-go" class="go-btn">Make GIF</button><button id="gif-cancel" hidden>Cancel</button><progress id="gif-prog" max="1" value="0" hidden></progress><span class="gp-hint" id="gif-status" role="status"></span></div>
          </div>
          <div class="stage" id="stage"><p class="loading">Loading scene…</p></div>
          <p class="scale-note" id="scale-note"></p>
          <div class="legend" id="legend"></div>
          <p class="hint">Drag to rotate · right-drag or Shift-drag to pan · Ctrl + wheel (or click, then wheel) to zoom · double-click to reset · hover a line or a row to link them. Keyboard: arrows rotate, +/− zoom, R reset, [ ] previous/next protomer.</p>
        </section>
        <aside class="data-col">
          <h2>Measured atom pairs <span class="muted" id="ncount"></span></h2>
          <div class="table-scroll tall"><table class="contacts" id="ctable"><thead><tr><th><span class="sr">Class</span></th><th>Atom 1</th><th>Atom 2</th><th class="num">Å</th></tr></thead><tbody></tbody></table></div>
          <p class="fine">Euclidean heavy-atom separations from full-precision deposited coordinates; 0.01 Å display precision is not a coordinate uncertainty. Short polar separations are hydrogen-bond <em>candidates</em> — hydrogen positions, protonation and angles are not modelled.</p>
          <div id="view-notes"></div>
          <details class="more"><summary>Scene identity & cofactors</summary><div id="scene-facts"></div></details>
          <details class="more"><summary>Downloads & archive</summary><div id="downloads"></div></details>
          <p class="compare-link"><a href="#/compare/${pt.route}">Compare these contacts across all ${A.counts.protomers} protomers →</a></p>
        </aside>
      </div>
    </div>`;
    const keyNav = e => {
      if (e.target.matches('input,textarea,select')) return;
      if (e.key === '[') location.hash = routeView(prevSame); else if (e.key === ']') location.hash = routeView(nextSame);
    };
    document.addEventListener('keydown', keyNav);
    viewerPool.add({ destroy: () => document.removeEventListener('keydown', keyNav) });
    loadScene(key).then(sc => buildViewPage(sc, s, p, pt)).catch(e => { $('#stage').innerHTML = `<p class="error">${esc(e.message)}</p>`; });
  }

  function buildViewPage(sc, s, p, pt) {
    const stage = $('#stage'); stage.innerHTML = '';
    stage.style.aspectRatio = sc.part.startsWith('A1') ? '16 / 10' : '1 / 1';
    const reduce = MOTION() === 'off';
    const shown = new Set(Object.keys(CLASS_STYLE));
    const tbody = $('#ctable tbody');
    let viewer;
    const atomLabel = i => { const a = sc.atoms[i], r = sc.residues[a[2]]; return { r, a }; };
    const fmtEnd = i => {
      const { r, a } = atomLabel(i);
      const name = r.kind === 'protein' ? `${r.label}` : r.kind === 'water' ? `HOH${r.num}` : `${r.comp} ${r.num}`;
      return `<span class="res">${esc(name)}<small>${esc(r.chain)}</small></span> <span class="atm">${esc(a[0])}</span>${r.role ? ' ' + roleTag(r.role) : ''}`;
    };
    const order = sc.contacts.map((c, i) => i).sort((a, b) => {
      const rank = { mg: 0, polar: 1, water: 2, intra: 4, context: 3, packing: 5 };
      return rank[sc.contacts[a].cls] - rank[sc.contacts[b].cls] || sc.contacts[a].d - sc.contacts[b].d;
    });
    tbody.innerHTML = order.map(i => {
      const c = sc.contacts[i], st = CLASS_STYLE[c.cls];
      return `<tr data-i="${i}" data-cls="${c.cls}" tabindex="0"><td><svg class="swatch" viewBox="0 0 28 8" aria-label="${esc(st.label)}"><line x1="1" y1="4" x2="27" y2="4" stroke="${st.color}" stroke-width="2.2" stroke-dasharray="${st.dash.join(' ')}"/></svg></td>
        <td>${fmtEnd(c.i)}</td><td>${fmtEnd(c.j)}</td><td class="num d">${c.d.toFixed(2)}</td></tr>
        <tr class="detail" data-for="${i}" hidden><td></td><td colspan="3"><b>${esc(st.label)}.</b> ${esc(A.classes[c.cls])}.<br><span class="muted">Earlier curated annotation: ${esc(c.src)}</span><br><span class="muted">Full value ${c.d.toFixed(5)} Å</span></td></tr>`;
    }).join('');
    $('#ncount').textContent = `(${sc.contacts.length})`;
    const rowFor = i => tbody.querySelector(`tr[data-i="${i}"]`);
    const onHover = k => {
      tbody.querySelectorAll('tr.hl').forEach(r => r.classList.remove('hl'));
      if (k >= 0) { const r = rowFor(k); r?.classList.add('hl'); r?.scrollIntoView({ block: 'nearest' }); }
    };
    viewer = new ContactViewer(stage, sc, { motion: reduce ? 'off' : 'spin', commonExtent: commonExtent[sc.part], scaleMode: 'common', classes: shown, onHover });
    const scaleNote = () => {
      const mode = viewer.opts.scaleMode, s = viewer.s ? viewer.s.toFixed(1) : '';
      $('#scale-note').innerHTML = mode === 'whole'
        ? `<b>Whole molecule</b> · fitted to this scene (${s} px/Å): every deposited atom stays in frame through a full spin.`
        : `<b>Common scale</b> · ${s} px/Å, identical for all ${A.counts.protomers} ${sci(pt.label.replace(' network', '').replace(' quinone', ''))} scenes at this window size; the measured region stays in frame through a full spin${sc.part.startsWith('A1') ? ', the phytyl tail may not' : ''}.`;
    };
    requestAnimationFrame(() => requestAnimationFrame(scaleNote));
    new ResizeObserver(() => requestAnimationFrame(scaleNote)).observe(stage);
    viewerPool.add(viewer);
    tbody.addEventListener('mouseover', e => { const tr = e.target.closest('tr[data-i]'); if (tr) viewer.setHighlight(+tr.dataset.i); });
    tbody.addEventListener('focusin', e => { const tr = e.target.closest('tr[data-i]'); if (tr) viewer.setHighlight(+tr.dataset.i); });
    tbody.addEventListener('mouseleave', () => viewer.setHighlight(-1));
    tbody.addEventListener('click', e => { const tr = e.target.closest('tr[data-i]'); if (!tr) return; const d = tbody.querySelector(`tr[data-for="${tr.dataset.i}"]`); d.hidden = !d.hidden; tr.classList.toggle('open', !d.hidden); });
    tbody.addEventListener('keydown', e => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); e.target.closest('tr[data-i]')?.click(); } });

    // toolbar
    const setPressed = (sel, attr, val) => app.querySelectorAll(sel).forEach(b => b.setAttribute('aria-pressed', String(b.dataset[attr] === val)));
    setPressed('[data-m]', 'm', viewer.opts.motion); setPressed('[data-s]', 's', 'common');
    app.querySelectorAll('[data-m]').forEach(b => b.addEventListener('click', () => { viewer.opts.respectReduced = false; viewer.setMotion(b.dataset.m); setPressed('[data-m]', 'm', b.dataset.m); }));
    stage.addEventListener('motionchange', e => setPressed('[data-m]', 'm', e.detail));
    app.querySelectorAll('[data-s]').forEach(b => b.addEventListener('click', () => { viewer.setScaleMode(b.dataset.s); setPressed('[data-s]', 's', b.dataset.s); requestAnimationFrame(() => requestAnimationFrame(scaleNote)); }));
    app.querySelectorAll('[data-l]').forEach(b => b.addEventListener('click', () => { const on = b.getAttribute('aria-pressed') !== 'true'; b.setAttribute('aria-pressed', String(on)); viewer.setOption(b.dataset.l, on); }));
    $('#reset').addEventListener('click', () => viewer.reset());
    $('#png').addEventListener('click', () => viewer.exportPNG(2560, `${sc.key}_contacts.png`,
      `${sc.pdb} · protomer ${sc.protomer} · ${PART[sc.part].label.replace(/_/g, '')} · heavy-atom separations in Å from deposited coordinates · PSI Contact Atlas`));
    // animated GIF of one full turn
    const gp = $('#gif-panel'), gifBtn = $('#gifbtn');
    let gw = 480, gt = 10, gifBusy = false, gifCancel = false;
    const SIZE_HINT = { 480: '≈ 1–4 MB', 800: '≈ 3–10 MB', 1200: '≈ 6–25 MB, slower to make' };
    const openGif = open => { gp.hidden = !open; gifBtn.setAttribute('aria-expanded', String(open)); gifBtn.setAttribute('aria-pressed', String(open)); };
    gifBtn.addEventListener('click', () => openGif(gp.hidden));
    gp.querySelectorAll('[data-gw]').forEach(b => b.addEventListener('click', () => { gw = +b.dataset.gw; gp.querySelectorAll('[data-gw]').forEach(x => x.setAttribute('aria-pressed', String(x === b))); $('#gp-size').textContent = SIZE_HINT[gw]; }));
    gp.querySelectorAll('[data-gt]').forEach(b => b.addEventListener('click', () => { gt = +b.dataset.gt; gp.querySelectorAll('[data-gt]').forEach(x => x.setAttribute('aria-pressed', String(x === b))); }));
    $('#gp-size').textContent = SIZE_HINT[gw];
    $('#downloads').addEventListener('click', e => {
      const b = e.target.closest('[data-open]'); if (!b) return;
      if (b.dataset.open === 'png') $('#png').click();
      else { openGif(true); $('.stage-col').scrollIntoView({ behavior: 'smooth', block: 'start' }); }
    });
    $('#gif-cancel').addEventListener('click', () => { gifCancel = true; });
    $('#gif-go').addEventListener('click', async () => {
      if (gifBusy) return;
      gifBusy = true; gifCancel = false;
      const prog = $('#gif-prog'), status = $('#gif-status');
      $('#gif-go').disabled = true; $('#gif-cancel').hidden = false; prog.hidden = false; prog.value = 0; status.textContent = 'Rendering…';
      const delayCs = 8, frames = Math.round(gt * 100 / delayCs);
      const label = PART[sc.part].label.replace(/_/g, '');
      try {
        const blob = await viewer.renderSpinGIF({ width: gw, frames, delayCs,
          caption: `${sc.pdb} · protomer ${sc.protomer} · ${label} · heavy-atom separations in Å · PSI Contact Atlas`,
          onProgress: f => { prog.value = f; status.textContent = `${Math.round(f * 100)} %`; }, isCancelled: () => gifCancel });
        if (!blob) { status.textContent = 'Cancelled.'; return; }
        const a = document.createElement('a'); a.href = URL.createObjectURL(blob); a.download = `${sc.key}_spin_${gw}px_${gt}s.gif`; a.click();
        setTimeout(() => URL.revokeObjectURL(a.href), 10000);
        status.textContent = `Saved ${a.download} (${(blob.size / 1e6).toFixed(1)} MB, ${frames} frames).`;
      } catch (err) { status.textContent = 'Could not make the GIF: ' + err.message; console.error(err); }
      finally { gifBusy = false; $('#gif-go').disabled = false; $('#gif-cancel').hidden = true; prog.hidden = true; }
    });
    $('#fs').addEventListener('click', () => { const el = $('.stage-col'); document.fullscreenElement ? document.exitFullscreen() : el.requestFullscreen?.(); });

    // legend with class toggles
    const counts = {}; sc.contacts.forEach(c => counts[c.cls] = (counts[c.cls] || 0) + 1);
    $('#legend').innerHTML = Object.entries(CLASS_STYLE).filter(([c]) => counts[c]).map(([c, st]) =>
      `<button class="lg" data-c="${c}" aria-pressed="true" title="${esc(A.classes[c])}"><svg viewBox="0 0 28 8" aria-hidden="true"><line x1="1" y1="4" x2="27" y2="4" stroke="${st.color}" stroke-width="2.4" stroke-dasharray="${st.dash.join(' ')}"/></svg>${esc(st.label)} <span class="muted">${counts[c]}</span></button>`).join('') +
      `<span class="lg-el"><i style="background:#808080"></i>C <i style="background:#264de6"></i>N <i style="background:#ff1f1f"></i>O <i style="background:#1abf40"></i>Mg <i style="background:#f2cc1a"></i>S · thicker sticks = cofactor</span>`;
    $('#legend').addEventListener('click', e => {
      const b = e.target.closest('.lg'); if (!b) return;
      const on = b.getAttribute('aria-pressed') !== 'true'; b.setAttribute('aria-pressed', String(on));
      on ? shown.add(b.dataset.c) : shown.delete(b.dataset.c);
      tbody.querySelectorAll(`tr[data-cls="${b.dataset.c}"]`).forEach(r => r.classList.toggle('off', !on));
      viewer.kick();
    });

    // notes specific to this view
    const notes = [...sc.notes];
    if (sc.water_rule && /P_A|special/.test(sc.part)) notes.push(`Water display rule: ${sc.water_rule}.`);
    const missing = Object.entries(p.cofactors).filter(([r, x]) => x?.atoms_note && sc.residues.some(rr => rr.role === r));
    for (const [r, x] of missing) notes.push(`${r}: ${x.atoms_note}`);
    if (sc.part === 'P_A' || sc.part === 'special_pair') notes.push(s.pdb === '1JB0' ? 'HOH5011 is the reference water whose aligned position defines the site-water column in the compare view.' : p.site_water ? `Water at the 1JB0 HOH5011 position: ${p.site_water.replace(/:O$/, '')} (${p.site_water_offset_A} Å from the aligned site; ${p.site_water_source}). A positional assignment, not proof of a conserved molecule.` : 'No deposited water lies within 3 Å of the aligned 1JB0 HOH5011 position in this protomer.');
    $('#view-notes').innerHTML = notes.map(n => `<p class="note">${sci(n)}</p>`).join('');

    const nRes = sc.residues.filter(r => r.kind === 'protein').length, nW = sc.residues.filter(r => r.kind === 'water').length;
    $('#scene-facts').innerHTML = `<dl class="kv">
      <dt>Scene</dt><dd>${sc.atoms.length} deposited heavy atoms · ${nRes} protein residues · ${nW} water${nW === 1 ? '' : 's'} · hydrogens not modelled</dd>
      <dt>Start orientation</dt><dd>reviewed PyMOL still, frame ${sc.camera.still_frame} (${sc.camera.still_angle_deg}° about the camera y axis), reconstructed from the recorded PyMOL view</dd>
      <dt>Pivot atom</dt><dd><code>${esc(sc.pivot_atom)}</code></dd>
      <dt>Chains</dt><dd>${esc(chainTitle(p))} (author IDs, case-sensitive)</dd></dl>
      <table class="mini-table"><thead><tr><th>Role</th><th>Assignment</th><th>Deposited</th><th>Label chain</th></tr></thead><tbody>${['P_A', 'P_B', 'A1_A', 'A1_B'].map(r => { const x = p.cofactors[r]; return `<tr><td>${roleTag(r)}</td><td>${sci(cofactorName(x))}</td><td><code>${esc(x?.identity)}</code></td><td>${esc(x?.label_asym)}</td></tr>`; }).join('')}</tbody></table>`;
    $('#downloads').innerHTML = `<ul class="dl">
      <li><button class="link inline" data-open="png">PNG still of the current view (2560 px)</button> · <button class="link inline" data-open="gif">Animated GIF, 480–1200 px</button></li>
      <li><a href="${esc(sc.downloads.contacts)}" download>Contacts CSV (full precision, class and earlier annotation)</a></li>
      <li><a href="${esc(sc.downloads.cif)}" download>Scene mmCIF (native identities)</a></li>
      ${sc.downloads.pymol ? `<li><a href="${esc(sc.downloads.pymol)}" download>PyMOL script (same atoms, pairs and view; run from the repository root)</a></li>` : ''}
      <li><a href="data/views/${esc(sc.key)}.js">Scene data used by this viewer</a></li></ul>
      ${PUBLIC ? '' : `<p class="fine">Local archive from the earlier PyMOL ray-traced build (not in the public bundle):</p>
      <ul class="dl"><li><a href="${esc(sc.v02.still)}" target="_blank" rel="noopener">2560-px PyMOL still</a></li><li><a href="${esc(sc.v02.mp4)}" target="_blank" rel="noopener">MP4 loop</a> · <a href="${esc(sc.v02.gif)}" download>GIF</a></li>
      <li><a href="${esc(sc.v02.session)}" download>PyMOL session</a></li><li><a href="${esc(sc.v02.molstar)}" target="_blank" rel="noopener">Mol* full-model window (WebGL)</a></li></ul>`}`;
  }

  /* ================= COMPARE ================= */
  function renderCompare(partKey) {
    const pt = PART[partKey], rows = A.compare[partKey];
    title(`Compare ${pt.label.replace(/_/g, '')}`);
    const cols = rows.map((r, ci) => ({ r, ci }));
    const colHead = r => {
      const left = r.from_water ? 'Site water' : `${r.cof_role} ${r.cof_atom}`;
      const right = r.partner === 'site-water' ? 'site water' : `${titleCase(r.ref_comp)}${r.ref_pos} ${r.partner_atom === 'hydroxyl O' ? 'OH' : r.partner_atom}`;
      return { left, right, sub: r.partner === 'site-water' ? '1JB0 HOH5011 position' : `${r.subunit} · 1JB0 numbering` };
    };
    const prots = A.structures.flatMap(s => s.protomers.map(p => ({ s, p })));
    const vals = rows.flatMap(r => r.cells.map(c => c.d).filter(d => d != null));
    app.innerHTML = `
    <div class="wrap-wide">
      <nav class="crumbs" aria-label="Breadcrumb"><a href="#/">Library</a><span>/</span><span>Compare</span></nav>
      <header class="compare-head"><div><h1>Compare: ${sci(pt.label)}</h1>
        <p class="lede small">Each column is one homologous atom pair; each row one deposited protomer. Every cell is recomputed from that protomer’s deposited coordinates, so a blank means the atom is not present (different residue, not modelled, or no site water), never “not measured”.</p></div>
        <div class="part-switch" role="tablist" aria-label="Environment">${A.parts.map(x => `<a role="tab" href="#/compare/${x.route}" aria-selected="${x.key === partKey}">${sci(x.label.replace(' network', '').replace(' quinone', ''))}</a>`).join('')}</div></header>
      <div class="scale-legend" aria-hidden="true"><span>2.4 Å</span><i class="ramp"></i><span>3.5 Å</span><i class="beyond"></i><span>&gt; 3.5 Å context</span><span class="blank">Phe</span><span>residue differs (no such atom)</span><span class="blank">n.m.</span><span>atom not modelled</span><span class="blank">—</span><span>no site water</span><span class="mg-key"><i></i> Mg–ligand column</span></div>
      <div class="table-scroll matrix-scroll"><table class="matrix" id="matrix">
        <thead><tr><th class="corner">Protomer<button id="sort-reset" class="link">structure order</button></th>${cols.map(({ r, ci }) => { const h = colHead(r); return `<th class="${r.cof_atom === 'MG' ? 'mgcol' : ''}" data-ci="${ci}" scope="col"><button class="colsort" title="Sort by this contact"><span>${sci(h.left)}</span><span>··· ${esc(h.right)}</span><small>${esc(h.sub)}</small></button></th>`; }).join('')}</tr></thead>
        <tbody></tbody>
        <tfoot><tr><th scope="row">Range</th>${cols.map(({ r }) => { const d = r.cells.map(c => c.d).filter(x => x != null); return `<td>${d.length ? `${Math.min(...d).toFixed(2)}–${Math.max(...d).toFixed(2)}<small>n=${d.length}</small>` : '—'}</td>`; }).join('')}</tr></tfoot>
      </table></div>
      <div class="two-col">
        <section><h2>How columns are defined</h2>
          <ul class="plain">
            <li>A column is created when any curated scene of this environment lists a polar, water or Mg contact between a cofactor atom and a PsaA/PsaB atom (or the reference-site water). Carbon packing pairs stay in the per-scene tables.</li>
            <li>Partner residues are mapped to 1JB0 numbering by a global sequence alignment (BLOSUM62, gap −10/−0.5) of each protomer’s observed PsaA/PsaB residues; this reproduces all 133 P<sub>A</sub>-network mappings of the earlier curated build. The native residue and atom are shown in each cell’s tooltip and in the CSV.</li>
            <li>Side-chain hydroxyls (Thr OG1, Ser OG, Tyr OH) share a column because the residue differs between structures (e.g. Thr743 ↔ Ser in Chl <i>d</i> entries).</li>
            <li>Quinone columns report the shorter separation from either carbonyl oxygen (CCD double-bonded O). PQN names them O1/O4, PL9 and A1AGD O1/O2; the native atom used is named per cell, never renamed.</li>
            <li>Site-water columns use the deposited water nearest the 1JB0 HOH5011 position after a 25-atom chlorin-core superposition (≤ 3 Å).</li>
          </ul></section>
        <section><h2>Reading the numbers</h2>
          <ul class="plain"><li>Heavy-atom separations only; a short N/O···O distance is a hydrogen-bond <em>candidate</em>.</li>
          <li>Protomers of one entry are not independent replicates. Values can be nearly identical across p1–p3 (largest spread 0.002 Å in 9AU4, 0.04 Å in 6KMX) where symmetry was imposed on the map or model, and differ by up to 0.35 Å (6KMW, 9EYS, 9I9L) or more (X-ray 5OY0) elsewhere — neither case makes them replicates; nominal resolution is not the uncertainty of a single distance.</li>
          <li>Altloc atoms (if any) use the highest-occupancy position and are marked †.</li></ul>
          <p><a class="btn" href="downloads/compare_matrix.csv" download>Download matrix CSV</a></p></section>
      </div>
    </div>`;
    const lo = 2.4, hi = 3.5;
    const shade = d => {
      if (d > hi) return 'beyond';
      const t = Math.max(0, Math.min(1, (d - lo) / (hi - lo)));
      return `--t:${(1 - t).toFixed(3)}`;
    };
    let sortCol = null;
    const draw = () => {
      let list = prots.map(x => x);
      if (sortCol !== null) list.sort((a, b) => {
        const ca = rows[sortCol].cells.find(c => c.pdb === a.s.pdb && c.protomer === a.p.number), cb = rows[sortCol].cells.find(c => c.pdb === b.s.pdb && c.protomer === b.p.number);
        return (ca.d ?? 99) - (cb.d ?? 99);
      });
      let lastPdb = null;
      $('#matrix tbody').innerHTML = list.map(({ s, p }) => {
        const first = sortCol === null && s.pdb !== lastPdb; lastPdb = s.pdb;
        return `<tr class="${first ? 'group-start' : ''}"><th scope="row"><a href="${routeView(viewKey(s.pdb, p.number, partKey))}"><b>${s.pdb}</b> p${p.number}</a> ${tag(s.condition, condKind(s.condition))}<small>${esc(shortOrg(s.organism))}</small></th>${cols.map(({ r }) => {
          const c = r.cells.find(x => x.pdb === s.pdb && x.protomer === p.number);
          if (c.d == null) {
            const m = c.missing || 'not available';
            const txt = m.startsWith('residue differs') ? esc((c.partner || '').replace(/\d.*/, '')) : m.includes('not modelled') ? 'n.m.' : '—';
            return `<td class="na${m.startsWith('residue differs') ? ' diff' : ''}" title="${esc(m)}"><span>${txt}</span><span class="sr">${esc(m)}</span></td>`;
          }
          const sh = shade(c.d), mg = r.cof_atom === 'MG';
          const tip = `${c.a} ··· ${c.b} = ${c.d.toFixed(3)} Å${c.partner ? ' (' + c.partner + ')' : ''}`;
          return `<td class="v ${sh === 'beyond' ? 'beyond' : ''} ${mg ? 'mg' : ''}" style="${sh === 'beyond' ? '' : sh}" title="${esc(tip)}"><a href="${routeView(viewKey(s.pdb, p.number, partKey))}">${c.d.toFixed(2)}${c.altloc ? '†' : ''}</a></td>`;
        }).join('')}</tr>`;
      }).join('');
    };
    app.querySelectorAll('.colsort').forEach(b => b.addEventListener('click', () => {
      const ci = +b.closest('th').dataset.ci; sortCol = sortCol === ci ? null : ci;
      app.querySelectorAll('th[data-ci]').forEach(th => th.classList.toggle('sorted', +th.dataset.ci === sortCol)); draw();
    }));
    $('#sort-reset').addEventListener('click', () => { sortCol = null; app.querySelectorAll('th[data-ci]').forEach(th => th.classList.remove('sorted')); draw(); });
    draw();
  }
  const titleCase = c => c ? c[0] + c.slice(1).toLowerCase() : '';

  /* ================= METHODS ================= */
  function renderMethods() {
    title('Methods & verification');
    const v = A.verification;
    const swatch = st => `<svg class="swatch" viewBox="0 0 28 8" aria-hidden="true"><line x1="1" y1="4" x2="27" y2="4" stroke="${st.color}" stroke-width="2.2" stroke-dasharray="${st.dash.join(' ')}"/></svg>`;
    app.innerHTML = `
    <div class="wrap prose">
      <nav class="crumbs" aria-label="Breadcrumb"><a href="#/">Library</a><span>/</span><span>Methods</span></nav>
      <h1>Methods, scope and verification</h1>
      <p class="lede small">Every scene shows deposited heavy atoms around one PSI cofactor environment and a curated list of measured atom pairs. Selections (atoms, contacts, label anchors, water rules) come from an earlier, reviewed PyMOL build of this library; this build redraws them live and re-derives every number from the deposited mmCIF files.</p>

      <h2>What the library can and cannot tell you</h2>
      <div class="cando">
        <section><h3>Can</h3><ul>
          <li>Give the Euclidean separation between two deposited heavy atoms, from full-precision coordinates, with native chain, residue and atom names.</li>
          <li>Show which polar atoms sit within hydrogen-bonding <em>distance</em> of P<sub>A</sub>, P<sub>B</sub> and the A<sub>1</sub> quinone carbonyls, and which waters are modelled nearby.</li>
          <li>Compare the same homologous contact across 28 protomers, and show where the residue itself differs (e.g. Phe at the 1JB0 Trp683 or Tyr735 positions).</li>
          <li>Separate deposited component identity, interpreted pigment name, functional role and chain ID.</li>
        </ul></section>
        <section><h3>Cannot</h3><ul>
          <li>Confirm a hydrogen bond: hydrogens, protonation states and donor–acceptor angles are not modelled.</li>
          <li>Give the uncertainty of a distance. 0.01 Å is display precision; nominal map or diffraction resolution is not a per-atom error.</li>
          <li>Treat protomers as independent replicates — symmetry or NCS restraints can make them nearly identical by construction.</li>
          <li>Prove that a water is conserved, or absent, or establish Mg coordination geometry, stereochemistry or model ancestry.</li>
          <li>Show local map quality: density and per-atom validation are not included.</li>
        </ul></section>
      </div>

      <h2>Build checks (${esc(A.built_utc)})</h2>
      <table class="kvt"><tbody>
        <tr><th>Scene atoms matched to deposited coordinates</th><td>${v.atoms.toLocaleString()} · max deviation ${v.max_coordinate_deviation_A.toFixed(5)} Å (the earlier build stored coordinates rounded to 0.001 Å)</td></tr>
        <tr><th>Distances recomputed at full deposited precision</th><td>${v.contacts} · max change from the earlier build ${v.max_distance_deviation_A.toFixed(5)} Å (bound √3 × 0.001 Å)</td></tr>
        <tr><th>Cofactor bond graphs vs CCD definitions</th><td>${v.cofactor_graphs} cofactor residues, all covalent bonds identical (Mg–N drawn separately)</td></tr>
        <tr><th>1JB0-numbering alignment vs earlier P<sub>A</sub> mapping</th><td>${v.alignment_crosschecks} positions, all identical</td></tr>
        <tr><th>Starting orientation vs the reviewed PyMOL stills</th><td>all 112 reproduced (&lt; 0.01 px)</td></tr>
        <tr><th>Independent check of displayed values</th><td>a separate script re-reads the deposited files and recomputes every distance and compare-matrix cell shown</td></tr>
      </tbody></table>

      <h2>Corrections relative to the earlier PyMOL build</h2>
      <h3>Displayed value changes at 0.01 Å (${v.rounding_changes.length})</h3>
      <p>The earlier build measured from coordinates rounded to 0.001 Å. Where the deposited file carries more digits, the full-precision value can round differently:</p>
      <div class="table-scroll"><table class="mini-table"><thead><tr><th>Scene</th><th>Pair</th><th class="num">Earlier</th><th class="num">Now</th></tr></thead><tbody>${v.rounding_changes.map(x => `<tr><td><a href="${routeView(x.view)}">${esc(x.view)}</a></td><td><code>${esc(x.atom_1)}</code> ··· <code>${esc(x.atom_2)}</code></td><td class="num">${esc(x.v02_display)}</td><td class="num">${esc(x.v03_display)}</td></tr>`).join('')}</tbody></table></div>
      <h3>Contact class corrections (${v.class_changes.length})</h3>
      <p>Classes are now assigned by one rule (below). These pairs were annotated as water proximity earlier but lie beyond the ${A.polar_screen_A} Å screen:</p>
      <div class="table-scroll"><table class="mini-table"><thead><tr><th>Scene</th><th>Pair</th><th class="num">Å</th><th>Earlier text</th><th>Class now</th></tr></thead><tbody>${v.class_changes.map(x => `<tr><td><a href="${routeView(x.view)}">${esc(x.view)}</a></td><td><code>${esc(x.atom_1)}</code> ··· <code>${esc(x.atom_2)}</code></td><td class="num">${x.distance_A.toFixed(2)}</td><td>${esc(x.v02_category)}</td><td>${esc(CLASS_STYLE[x.v03_class].label)}</td></tr>`).join('')}</tbody></table></div>
      <h3>Reference-site water</h3>
      <p>The site-water rule (nearest deposited water to the 1JB0 HOH5011 position after a 25-atom chlorin-core superposition, ≤ 3 Å) was applied to all 28 protomers. It reproduces all ${v.site_water.filter(x => x.v02_water).length} earlier assignments; ${v.site_water.filter(x => !x.water).length} protomers (${v.site_water.filter(x => !x.water).map(x => x.pdb + ' p' + x.protomer).join(', ')}) have no water within 3 Å of the site.</p>

      <h2>Contact classes</h2>
      <div class="table-scroll"><table class="mini-table"><tbody>${Object.entries(CLASS_STYLE).map(([c, st]) => `<tr><td>${swatch(st)}</td><td><b>${esc(st.label)}</b></td><td>${esc(A.classes[c])}</td></tr>`).join('')}</tbody></table></div>
      <p>Rule, in order: Mg involved → Mg–ligand; same residue → intramolecular; C or S involved → packing; &gt; ${A.polar_screen_A} Å → longer context; water involved → water polar candidate; otherwise polar candidate. The earlier free-text annotation is kept for every pair (table detail row and CSV).</p>

      <h2>Scale and framing</h2>
      <ul>
        <li><b>Common scale</b> uses one Å-per-pixel for all 28 scenes of an environment, sized so that the largest <em>measured region</em> stays in frame through a full spin. Use it to compare sizes and geometry between structures; long tails (e.g. phytyl chains) may leave the frame.</li>
        <li><b>Whole molecule</b> fits this scene alone so that every deposited atom stays in frame through a full spin.</li>
        <li>The scale bar always shows the current Å per pixel. Scenes start from the orientation of the reviewed PyMOL still, aligned to 1JB0 for display only.</li>
      </ul>

      <h2>Scope</h2>
      <ul>
        <li>Deposited coordinates, components and author/label chain identifiers are retained; chain IDs are case-sensitive. Hydrogens and absent atoms (e.g. the 9YL7 PL9 tail, 6KMX A<sub>1B</sub> atoms, 9AU4 Trp693 NE1) are not reconstructed.</li>
        <li>P<sub>A</sub>, P<sub>B</sub>, A<sub>1A</sub>, A<sub>1B</sub> are functional roles, separate from chain IDs. A deposited CLA at P<sub>A</sub> is not reassigned to Chl <i>a</i>′; a component annotation is not an independent stereochemical validation.</li>
        <li>Mg separations are Mg–ligand atom distances; coordination geometry is not assessed (5OY0 protomer 3 has long Mg–His separations).</li>
        <li>Structures: X-ray crystallography (1JB0, 5OY0) and single-particle cryo-EM (ten entries); method fields on the home page are read from each deposited mmCIF.</li>
        <li>Lineage, citations and condition labels come from a curated audit (DOIs and titles verified against Crossref/RCSB on 16 October 2026). Camera alignment to 1JB0 is a display convention, not ancestry.</li>
        <li>Sticks are covalent bonds inferred within residues (checked against CCD for cofactors) plus peptide links; thicker sticks mark cofactors; depth is shown by fog toward white.</li>
      </ul>
    </div>`;
  }

  /* ---------- theme ---------- */
  const themeBtn = $('#theme');
  const applyTheme = t => { if (t) document.documentElement.dataset.theme = t; else delete document.documentElement.dataset.theme; themeBtn.textContent = (document.documentElement.dataset.theme || (matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')) === 'dark' ? '☀' : '☾'; };
  let saved = new URLSearchParams(location.search).get('theme');
  if (!['light', 'dark'].includes(saved)) { saved = null; try { saved = localStorage.getItem('psi-theme'); } catch { } }
  applyTheme(saved);
  themeBtn.addEventListener('click', () => {
    const cur = document.documentElement.dataset.theme || (matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    const nx = cur === 'dark' ? 'light' : 'dark'; applyTheme(nx); try { localStorage.setItem('psi-theme', nx); } catch { }
  });

  window.PSI_APP = { route, loadScene };
  route();
})();
