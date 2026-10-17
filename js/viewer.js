/* PSI contact viewer — Canvas 2D renderer for native scene atoms and measured contacts.
   No WebGL, no dependencies. Camera starts from the accepted v02 still orientation. */
'use strict';
(function () {
  const ELEMENT = { C: '#808080', N: '#264de6', O: '#ff1f1f', S: '#f2cc1a', Mg: '#1abf40' };
  const CLASS_STYLE = {
    mg:      { color: '#178a3c', dash: [],        width: 2.0, label: 'Mg–ligand' },
    polar:   { color: '#1d2a3a', dash: [7, 4],    width: 1.8, label: 'Polar candidate' },
    water:   { color: '#0b7f9c', dash: [7, 4],    width: 1.8, label: 'Water polar candidate' },
    context: { color: '#8a929c', dash: [2, 4],    width: 1.6, label: 'Longer context' },
    packing: { color: '#b0670f', dash: [2, 4],    width: 1.6, label: 'Packing' },
    intra:   { color: '#7a52c7', dash: [8, 3, 2, 3], width: 1.6, label: 'Intramolecular' },
  };
  const ROLE_TEXT = { P_A: ['P', 'A'], P_B: ['P', 'B'], A1_A: ['A', '1A'], A1_B: ['A', '1B'] };
  const STICK_A = 0.13, COFACTOR_STICK_A = 0.16, ROCK_DEG = 25, ROCK_PERIOD = 9, SPIN_PERIOD = 18;
  const FONT = '"Segoe UI", system-ui, -apple-system, "Helvetica Neue", Arial, sans-serif';

  function hexToRgb(h) { const n = parseInt(h.slice(1), 16); return [(n >> 16) & 255, (n >> 8) & 255, n & 255]; }
  function mix(rgb, toward, t) { return rgb.map((c, i) => Math.round(c + (toward[i] - c) * t)); }
  function rgbStr(c) { return `rgb(${c[0]},${c[1]},${c[2]})`; }
  const ELEMENT_RGB = Object.fromEntries(Object.entries(ELEMENT).map(([k, v]) => [k, hexToRgb(v)]));

  function matMul(a, b) {
    const r = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
    for (let i = 0; i < 3; i++) for (let j = 0; j < 3; j++) r[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j] + a[i][2] * b[2][j];
    return r;
  }
  function rotY(t) { const c = Math.cos(t), s = Math.sin(t); return [[c, 0, s], [0, 1, 0], [-s, 0, c]]; }
  function rotX(t) { const c = Math.cos(t), s = Math.sin(t); return [[1, 0, 0], [0, c, -s], [0, s, c]]; }
  function orthonormalize(m) {
    const a = m[0], b = m[1];
    const na = Math.hypot(...a); const x = a.map(v => v / na);
    const d = b[0] * x[0] + b[1] * x[1] + b[2] * x[2];
    const yb = b.map((v, i) => v - d * x[i]); const nb = Math.hypot(...yb); const y = yb.map(v => v / nb);
    const z = [x[1] * y[2] - x[2] * y[1], x[2] * y[0] - x[0] * y[2], x[0] * y[1] - x[1] * y[0]];
    return [x, y, z];
  }

  function rectsOverlap(a, b, pad = 2) {
    return a.x < b.x + b.w + pad && b.x < a.x + a.w + pad && a.y < b.y + b.h + pad && b.y < a.y + a.h + pad;
  }

  class ContactViewer {
    /** @param {HTMLElement} host  @param {object} scene  @param {object} opts */
    constructor(host, scene, opts = {}) {
      this.host = host; this.scene = scene;
      this.opts = Object.assign({ compact: false, labels: true, residueLabels: true, distanceLabels: true,
        motion: 'spin', commonExtent: null, scaleMode: 'common', classes: null, onHover: null, interactive: true }, opts);
      this.canvas = document.createElement('canvas');
      this.canvas.className = 'cv-canvas';
      this.canvas.setAttribute('role', 'img');
      host.appendChild(this.canvas);
      this.ctx = this.canvas.getContext('2d');
      this.tip = document.createElement('div'); this.tip.className = 'cv-tip'; this.tip.hidden = true; host.appendChild(this.tip);
      this.highlight = -1; this.hoverAtom = -1; this.labelMemo = new Map();
      this.prepare();
      this.reset();
      this.visible = true; this.running = false; this.t0 = performance.now(); this.phase = 0;
      if (this.opts.interactive) this.bindInput(); else { this.canvas.style.touchAction = 'auto'; this.canvas.style.cursor = 'pointer'; }
      this.ro = new ResizeObserver(() => this.resize()); this.ro.observe(host);
      if ('IntersectionObserver' in window) {
        this.io = new IntersectionObserver(es => { this.visible = es[0].isIntersecting; this.kick(); }, { rootMargin: '60px' });
        this.io.observe(host);
      }
      this.onVis = () => this.kick(); document.addEventListener('visibilitychange', this.onVis);
      this.resize();
    }

    prepare() {
      const s = this.scene;
      this.atoms = s.atoms.map(a => ({ name: a[0], el: a[1], res: a[2], p: [a[3], a[4], a[5]], occ: a[6], B: a[7] }));
      this.residues = s.residues;
      this.bonds = s.bonds;
      this.contacts = s.contacts;
      this.labels = s.labels;
      this.center = s.camera.centre;
      this.cofactorRes = new Set(s.residues.map((r, i) => r.kind === 'cofactor' ? i : -1).filter(i => i >= 0));
      this.cam = new Float64Array(this.atoms.length * 3);
      this.scr = new Float64Array(this.atoms.length * 3);
      const label = this.canvas;
      label.setAttribute('aria-label', `${s.pdb} protomer ${s.protomer} ${s.part.replace('_', ' ')}: ${s.atoms.length} deposited heavy atoms and ${s.contacts.length} measured separations. The table lists every value.`);
    }

    /* ---------- camera ---------- */
    reset() {
      this.R0 = this.scene.camera.rot.map(r => r.slice());
      this.user = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
      this.pan = [0, 0]; this.zoom = 1; this.angle = 0; this.rockBase = 0; this.rockT = 0; this.theta = 0; this.lastNow = performance.now();
      this.labelMemo.clear(); this.kick();
    }
    setMotion(m) {
      this.angle = this.theta || 0;
      if (m === 'rock') { this.rockBase = this.angle; this.rockT = 0; }
      this.opts.motion = m; this.lastNow = performance.now(); this.kick();
    }
    setScaleMode(m) { this.opts.scaleMode = m; this.zoom = 1; this.pan = [0, 0]; this.kick(); }
    setOption(k, v) { this.opts[k] = v; this.labelMemo.clear(); this.kick(); }
    reduced() { return window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches && this.opts.respectReduced !== false; }
    /* advance the camera-y rotation; called once per animation frame only */
    advance(now) {
      const dt = Math.min(100, Math.max(0, now - (this.lastNow || now))) / 1000; this.lastNow = now;
      const m = this.opts.motion;
      if (m === 'off' || this.reduced() || this.dragging) { this.theta = this.angle; return; }
      if (m === 'spin') { this.angle += dt * 2 * Math.PI / SPIN_PERIOD * (this.scene.camera.spin_sign || 1); this.theta = this.angle; }
      else { this.rockT += dt; this.theta = this.rockBase + Math.sin(this.rockT / ROCK_PERIOD * 2 * Math.PI) * ROCK_DEG * Math.PI / 180; }
    }
    /* Both modes are rotation-safe for a full spin about the vertical axis (extents from the build).
       common: one Å-per-pixel for every scene of this environment, sized to the largest measured region.
       whole:  this scene only, every deposited atom kept in frame. */
    baseScale(w, h) {
      const cam = this.scene.camera;
      const ext = this.opts.scaleMode === 'whole' ? cam.whole : (this.opts.commonExtent || cam.roi);
      return Math.min(w / (2 * ext[0]), h / (2 * ext[1]));
    }
    pxPerA() { return this.s; }

    /* ---------- lifecycle ---------- */
    resize() {
      const r = this.host.getBoundingClientRect();
      const dpr = Math.min(window.devicePixelRatio || 1, 2.5);
      this.cssW = Math.max(50, r.width); this.cssH = Math.max(50, r.height); this.dpr = dpr;
      this.canvas.width = Math.round(this.cssW * dpr); this.canvas.height = Math.round(this.cssH * dpr);
      this.canvas.style.width = this.cssW + 'px'; this.canvas.style.height = this.cssH + 'px';
      this.labelMemo.clear(); this.kick();
    }
    kick() {
      if (this.running) return;
      this.running = true;
      requestAnimationFrame(t => this.frame(t));
    }
    frame(now) {
      this.running = false;
      if (!this.canvas.isConnected) return this.destroy();
      this.advance(now);
      this.draw(this.ctx, this.cssW, this.cssH, this.dpr, now);
      const animating = this.opts.motion !== 'off' && this.visible && !document.hidden && !this.dragging && !this.reduced();
      if (!animating) this.lastNow = 0;
      if (animating) this.kick();
    }
    destroy() {
      this.ro?.disconnect(); this.io?.disconnect(); document.removeEventListener('visibilitychange', this.onVis);
    }

    /* ---------- projection ---------- */
    project(w, h, now) {
      const theta = this.theta || 0;
      this.lastTheta = theta;
      const R = matMul(this.user, matMul(rotY(theta), this.R0));
      this.R = R;
      const s = this.baseScale(w * .96, h * .94) * this.zoom;
      this.s = s;
      const cx = w / 2 + this.pan[0], cy = h / 2 + this.pan[1];
      const c = this.center, cam = this.cam, scr = this.scr;
      let zmin = Infinity, zmax = -Infinity;
      for (let i = 0; i < this.atoms.length; i++) {
        const p = this.atoms[i].p, x = p[0] - c[0], y = p[1] - c[1], z = p[2] - c[2];
        const X = R[0][0] * x + R[0][1] * y + R[0][2] * z, Y = R[1][0] * x + R[1][1] * y + R[1][2] * z, Z = R[2][0] * x + R[2][1] * y + R[2][2] * z;
        cam[i * 3] = X; cam[i * 3 + 1] = Y; cam[i * 3 + 2] = Z;
        scr[i * 3] = cx + s * X; scr[i * 3 + 1] = cy - s * Y; scr[i * 3 + 2] = Z;
        if (Z < zmin) zmin = Z; if (Z > zmax) zmax = Z;
      }
      this.zmin = zmin; this.zmax = zmax;
    }
    fog(z) { const span = this.zmax - this.zmin || 1; return 0.4 * (1 - (z - this.zmin) / span); }

    /* ---------- drawing ---------- */
    draw(ctx, w, h, dpr, now, exportMode = false) {
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      ctx.fillStyle = '#ffffff'; ctx.fillRect(0, 0, w, h);
      this.project(w, h, now);
      const s = this.s, scr = this.scr, atoms = this.atoms, bg = [255, 255, 255];
      const shown = this.opts.classes;
      const hl = this.highlight;
      const hlAtoms = new Set();
      if (hl >= 0) { hlAtoms.add(this.contacts[hl].i); hlAtoms.add(this.contacts[hl].j); }
      const items = [];
      for (const [i, j, coord] of this.bonds) {
        const zi = scr[i * 3 + 2], zj = scr[j * 3 + 2];
        const mx = (scr[i * 3] + scr[j * 3]) / 2, my = (scr[i * 3 + 1] + scr[j * 3 + 1]) / 2;
        const cof = this.cofactorRes.has(atoms[i].res);
        if (coord) { items.push({ z: (zi + zj) / 2, t: 'coord', i, j }); continue; }
        items.push({ z: (zi * 3 + zj) / 4, t: 'half', a: i, x1: scr[i * 3], y1: scr[i * 3 + 1], x2: mx, y2: my, cof });
        items.push({ z: (zj * 3 + zi) / 4, t: 'half', a: j, x1: mx, y1: my, x2: scr[j * 3], y2: scr[j * 3 + 1], cof });
      }
      const bonded = new Set(); for (const [i, j] of this.bonds) { bonded.add(i); bonded.add(j); }
      for (let i = 0; i < atoms.length; i++) {
        const a = atoms[i];
        if (a.el === 'Mg' || this.residues[a.res].kind === 'water' || !bonded.has(i)) items.push({ z: scr[i * 3 + 2] + .01, t: 'ball', a: i });
      }
      items.sort((p, q) => p.z - q.z);
      ctx.lineCap = 'round';
      for (const it of items) {
        if (it.t === 'half') {
          const a = atoms[it.a], base = ELEMENT_RGB[a.el] || ELEMENT_RGB.C, f = this.fog(it.z);
          const col = mix(base, bg, f), dark = mix(mix(base, [0, 0, 0], .32), bg, f), lite = mix(mix(base, [255, 255, 255], .55), bg, f);
          const wd = 2 * (it.cof ? COFACTOR_STICK_A : STICK_A) * s;
          ctx.strokeStyle = rgbStr(dark); ctx.lineWidth = wd + Math.max(1, s * .035);
          ctx.beginPath(); ctx.moveTo(it.x1, it.y1); ctx.lineTo(it.x2, it.y2); ctx.stroke();
          ctx.strokeStyle = rgbStr(col); ctx.lineWidth = wd;
          ctx.beginPath(); ctx.moveTo(it.x1, it.y1); ctx.lineTo(it.x2, it.y2); ctx.stroke();
          // specular streak toward the light (upper left)
          const dx = it.x2 - it.x1, dy = it.y2 - it.y1, L = Math.hypot(dx, dy) || 1;
          let nx = -dy / L, ny = dx / L; if (nx + ny > 0) { nx = -nx; ny = -ny; }
          const o = wd * .2;
          ctx.strokeStyle = rgbStr(lite); ctx.lineWidth = wd * .28; ctx.globalAlpha = .55;
          ctx.beginPath(); ctx.moveTo(it.x1 + nx * o, it.y1 + ny * o); ctx.lineTo(it.x2 + nx * o, it.y2 + ny * o); ctx.stroke();
          ctx.globalAlpha = 1;
        } else if (it.t === 'coord') {
          const f = this.fog(it.z);
          ctx.strokeStyle = rgbStr(mix([120, 150, 125], bg, f)); ctx.lineWidth = Math.max(1, s * .05); ctx.setLineDash([]);
          ctx.beginPath(); ctx.moveTo(scr[it.i * 3], scr[it.i * 3 + 1]); ctx.lineTo(scr[it.j * 3], scr[it.j * 3 + 1]); ctx.stroke();
        } else {
          const a = atoms[it.a], f = this.fog(it.z), base = ELEMENT_RGB[a.el] || ELEMENT_RGB.C;
          const r = (a.el === 'Mg' ? .46 : this.residues[a.res].kind === 'water' ? .40 : .25) * s;
          const x = scr[it.a * 3], y = scr[it.a * 3 + 1];
          const g = ctx.createRadialGradient(x - r * .35, y - r * .35, r * .1, x, y, r);
          g.addColorStop(0, rgbStr(mix(mix(base, [255, 255, 255], .6), bg, f)));
          g.addColorStop(.55, rgbStr(mix(base, bg, f)));
          g.addColorStop(1, rgbStr(mix(mix(base, [0, 0, 0], .35), bg, f)));
          ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y, r, 0, Math.PI * 2); ctx.fill();
        }
      }
      // atom highlight rings
      for (const i of [...hlAtoms, this.hoverAtom].filter(i => i >= 0)) {
        ctx.strokeStyle = '#f59e0b'; ctx.lineWidth = 2.5; ctx.setLineDash([]);
        ctx.beginPath(); ctx.arc(scr[i * 3], scr[i * 3 + 1], Math.max(6, .55 * s), 0, Math.PI * 2); ctx.stroke();
      }
      // guides (on top of the molecule, white halo for legibility)
      this.guideGeom = [];
      this.contacts.forEach((c, k) => {
        if (shown && !shown.has(c.cls)) { this.guideGeom.push(null); return; }
        const st = CLASS_STYLE[c.cls], x1 = scr[c.i * 3], y1 = scr[c.i * 3 + 1], x2 = scr[c.j * 3], y2 = scr[c.j * 3 + 1];
        this.guideGeom.push([x1, y1, x2, y2]);
        const emph = k === hl, dim = hl >= 0 && !emph;
        ctx.globalAlpha = dim ? .35 : 1;
        ctx.setLineDash([]); ctx.strokeStyle = 'rgba(255,255,255,.85)'; ctx.lineWidth = st.width + (emph ? 5 : 3);
        ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.stroke();
        ctx.setLineDash(st.dash.map(d => d * (exportMode ? exportMode : 1))); ctx.strokeStyle = emph ? '#d97706' : st.color; ctx.lineWidth = st.width * (emph ? 1.6 : 1) * (exportMode || 1);
        ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.stroke();
        ctx.globalAlpha = 1;
      });
      ctx.setLineDash([]);
      const bar = this.drawScaleBar(ctx, w, h, exportMode);
      if (this.opts.labels) this.drawLabels(ctx, w, h, exportMode, bar);
    }

    drawScaleBar(ctx, w, h, k) {
      k = k || 1;
      const s = this.s; let len = 5; if (s * 5 > w * .3) len = 2; if (s * 5 < 40) len = 10;
      const px = len * s, x = 14 * k, y = h - 14 * k;
      ctx.strokeStyle = '#3d4650'; ctx.lineWidth = 2 * k; ctx.beginPath();
      ctx.moveTo(x, y - 4 * k); ctx.lineTo(x, y); ctx.lineTo(x + px, y); ctx.lineTo(x + px, y - 4 * k); ctx.stroke();
      ctx.fillStyle = '#3d4650'; ctx.font = `600 ${11 * k}px ${FONT}`; ctx.textBaseline = 'bottom'; ctx.textAlign = 'left';
      ctx.fillText(`${len} Å`, x + px + 6 * k, y + 1 * k);
      const tw = ctx.measureText(`${len} Å`).width;
      return { x: x - 4 * k, y: y - 16 * k, w: px + tw + 14 * k, h: 20 * k };
    }

    measureRole(ctx, role, size) {
      const [base, sub] = ROLE_TEXT[role] || [role, ''];
      ctx.font = `700 ${size}px ${FONT}`; const wb = ctx.measureText(base).width;
      ctx.font = `700 ${size * .7}px ${FONT}`; const ws = ctx.measureText(sub).width;
      return { base, sub, w: wb + ws + 1, wb };
    }

    drawLabels(ctx, w, h, k, bar) {
      const compact = this.opts.compact && !k;
      const scr = this.scr, placed = bar ? [bar] : [];
      let hidden = 0;
      // reserve the bottom-right corner for the "not labelled" note so it never covers a label
      const noteFont = (compact ? 10 : 11.5) * (k || 1);
      ctx.font = `500 ${noteFont}px ${FONT}`;
      const noteW = ctx.measureText(compact ? '+99 in table' : '99 values not labelled here · see table').width;
      placed.push({ x: w - 10 * (k || 1) - noteW, y: h - 8 * (k || 1) - noteFont * 1.3, w: noteW, h: noteFont * 1.3 });
      const dFont = (compact ? 10.5 : 12.5) * (k || 1), rFont = (compact ? 10.5 : 12.5) * (k || 1), roleFont = (compact ? 13 : 16) * (k || 1);
      const inside = r => r.x >= 2 && r.y >= 2 && r.x + r.w <= w - 2 && r.y + r.h <= h - 2;
      const free = r => inside(r) && !placed.some(p => rectsOverlap(p, r));
      // keep atom positions as soft obstacles for residue labels
      const atomBoxes = [];
      for (let i = 0; i < this.atoms.length; i++) atomBoxes.push({ x: scr[i * 3] - 2, y: scr[i * 3 + 1] - 2, w: 4, h: 4 });
      const hitsAtoms = r => { let n = 0; for (const b of atomBoxes) if (rectsOverlap(r, b, 0)) n++; return n; };

      // 1) distance labels, shortest first, along their own guide
      if (this.opts.distanceLabels) {
        const order = this.contacts.map((c, i) => i).filter(i => this.guideGeom[i]).sort((a, b) => (a === this.highlight ? -1 : b === this.highlight ? 1 : this.contacts[a].d - this.contacts[b].d));
        ctx.font = `600 ${dFont}px ${FONT}`;
        for (const ci of order) {
          const c = this.contacts[ci], g = this.guideGeom[ci], st = CLASS_STYLE[c.cls];
          const text = c.d.toFixed(2), tw = ctx.measureText(text).width + 8 * (k || 1), th = dFont + 5 * (k || 1);
          const dx = g[2] - g[0], dy = g[3] - g[1], L = Math.hypot(dx, dy) || 1, nx = -dy / L, ny = dx / L;
          const memoKey = 'd' + ci; const prev = this.labelMemo.get(memoKey);
          const cands = [];
          for (const off of [0, th * .95, -th * .95, th * 1.9, -th * 1.9]) for (const t of [.5, .4, .6, .3, .7, .22, .78]) cands.push([t, off]);
          const tryOrder = prev !== undefined ? [prev, ...cands.keys()] : [...cands.keys()];
          let rect = null, chosen = -1;
          for (const q of tryOrder) {
            const [t, off] = cands[q];
            const r = { x: g[0] + dx * t + nx * off - tw / 2, y: g[1] + dy * t + ny * off - th / 2, w: tw, h: th, t, off };
            if (free(r)) { rect = r; chosen = q; break; }
          }
          const emph = ci === this.highlight;
          if (!rect && emph) rect = { x: g[0] + dx * .5 - tw / 2, y: g[1] + dy * .5 - th / 2, w: tw, h: th, t: .5, off: 0 };
          if (!rect) { hidden++; c._rect = null; this.labelMemo.delete(memoKey); continue; }
          if (chosen >= 0) this.labelMemo.set(memoKey, chosen);
          placed.push(rect);
          if (Math.abs(rect.off) > 0) { // short leader back to the guide
            ctx.strokeStyle = st.color; ctx.globalAlpha = .6; ctx.lineWidth = 1 * (k || 1); ctx.setLineDash([]);
            const gx = g[0] + dx * rect.t, gy = g[1] + dy * rect.t;
            ctx.beginPath(); ctx.moveTo(gx, gy); ctx.lineTo(rect.x + rect.w / 2, rect.y + rect.h / 2); ctx.stroke(); ctx.globalAlpha = 1;
          }
          ctx.fillStyle = emph ? '#fff7e6' : 'rgba(255,255,255,.96)';
          ctx.strokeStyle = emph ? '#d97706' : st.color; ctx.lineWidth = (emph ? 1.6 : 1) * (k || 1);
          roundRect(ctx, rect.x, rect.y, rect.w, rect.h, 4 * (k || 1)); ctx.fill(); ctx.stroke();
          ctx.fillStyle = emph ? '#92400e' : st.color === '#8a929c' ? '#5b636c' : st.color;
          ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
          ctx.fillText(text, rect.x + rect.w / 2, rect.y + rect.h / 2 + .5);
          c._rect = rect;
        }
      }
      // 2) residue, water and role labels near their anchors, pushed outward from the scene centre
      const cx = w / 2 + this.pan[0], cy = h / 2 + this.pan[1];
      this.labels.forEach((lb, li) => {
        if (lb.kind !== 'role' && !this.opts.residueLabels) return;
        const ax = scr[lb.a * 3], ay = scr[lb.a * 3 + 1];
        let tw, th, role = null;
        if (lb.kind === 'role') { role = this.measureRole(ctx, lb.text, roleFont); tw = role.w; th = roleFont * 1.25; }
        else {
          ctx.font = `600 ${rFont}px ${FONT}`; const t1 = ctx.measureText(lb.text).width;
          ctx.font = `400 ${rFont * .8}px ${FONT}`; const t2 = lb.chain ? ctx.measureText(' ' + lb.chain).width : 0;
          tw = t1 + t2; th = rFont * 1.25; lb._t1 = t1;
        }
        let ox = ax - cx, oy = ay - cy; const n = Math.hypot(ox, oy) || 1; ox /= n; oy /= n;
        const base = Math.atan2(oy, ox), gap = (lb.kind === 'role' ? 16 : 10) * (k || 1);
        const cands = [];
        for (const da of [0, .5, -.5, 1, -1, 1.6, -1.6, 2.4, -2.4, Math.PI]) for (const rr of [1, 1.8, 2.8]) {
          const a = base + da, ex = Math.cos(a), ey = Math.sin(a);
          const x = ax + ex * gap * rr + (ex < -.3 ? -tw : ex > .3 ? 0 : -tw / 2), y = ay + ey * gap * rr + (ey < -.3 ? -th : ey > .3 ? 0 : -th / 2);
          cands.push({ x, y, w: tw, h: th });
        }
        const memoKey = 'l' + li, prev = this.labelMemo.get(memoKey);
        let best = null, bestScore = Infinity, bestIdx = -1;
        const tryIdx = prev !== undefined ? [prev, ...cands.keys()] : [...cands.keys()];
        for (const q of tryIdx) {
          const r = cands[q]; if (!free(r)) continue;
          const score = hitsAtoms(r) * 3 + q * .15 - (q === prev ? 2 : 0);
          if (score < bestScore) { bestScore = score; best = r; bestIdx = q; }
          if (score <= 0) break;
        }
        if (!best) return; // no space: the table remains the complete record
        this.labelMemo.set(memoKey, bestIdx);
        placed.push(best);
        const tx = best.x, ty = best.y + best.h / 2;
        // leader if label sits away from its anchor
        const lx = Math.max(best.x, Math.min(ax, best.x + best.w)), ly = Math.max(best.y, Math.min(ay, best.y + best.h));
        if (Math.hypot(lx - ax, ly - ay) > gap * 1.4) {
          ctx.strokeStyle = 'rgba(70,80,90,.55)'; ctx.lineWidth = 1 * (k || 1); ctx.setLineDash([]);
          ctx.beginPath(); ctx.moveTo(ax, ay); ctx.lineTo(lx, ly); ctx.stroke();
        }
        ctx.textBaseline = 'middle'; ctx.textAlign = 'left'; ctx.lineJoin = 'round';
        const halo = (txt, x, y) => { ctx.strokeStyle = 'rgba(255,255,255,.95)'; ctx.lineWidth = 3.5 * (k || 1); ctx.strokeText(txt, x, y); ctx.fillText(txt, x, y); };
        if (role) {
          ctx.font = `700 ${roleFont}px ${FONT}`; ctx.fillStyle = '#0f3d2e'; halo(role.base, tx, ty);
          ctx.font = `700 ${roleFont * .7}px ${FONT}`; halo(role.sub, tx + role.wb + 1, ty + roleFont * .28);
        } else {
          ctx.font = `600 ${rFont}px ${FONT}`; ctx.fillStyle = lb.kind === 'water' ? '#0b6680' : '#26303b'; halo(lb.text, tx, ty);
          if (lb.chain) { ctx.font = `400 ${rFont * .8}px ${FONT}`; ctx.fillStyle = '#6b7580'; halo(' ' + lb.chain, tx + lb._t1, ty + 1); }
        }
      });
      this.hiddenValues = hidden;
      if (hidden) {
        const msg = compact ? `+${hidden} in table` : `${hidden} value${hidden > 1 ? 's' : ''} not labelled here · see table`;
        ctx.font = `500 ${noteFont}px ${FONT}`; ctx.textAlign = 'right'; ctx.textBaseline = 'bottom';
        ctx.fillStyle = '#6b7580'; ctx.fillText(msg, w - 10 * (k || 1), h - 8 * (k || 1));
      }
    }

    /* ---------- picking & input ---------- */
    pick(mx, my) {
      let best = -1, bd = 9;
      for (let i = 0; i < this.atoms.length; i++) {
        const d = Math.hypot(this.scr[i * 3] - mx, this.scr[i * 3 + 1] - my);
        if (d < bd) { bd = d; best = i; }
      }
      let guide = -1, gd = 6;
      (this.guideGeom || []).forEach((g, k) => {
        if (!g) return;
        const r = this.contacts[k]._rect; if (r && mx >= r.x && mx <= r.x + r.w && my >= r.y && my <= r.y + r.h) { guide = k; gd = 0; return; }
        const dx = g[2] - g[0], dy = g[3] - g[1], L2 = dx * dx + dy * dy || 1;
        const t = Math.max(0, Math.min(1, ((mx - g[0]) * dx + (my - g[1]) * dy) / L2));
        const d = Math.hypot(g[0] + t * dx - mx, g[1] + t * dy - my);
        if (d < gd) { gd = d; guide = k; }
      });
      return { atom: best, guide };
    }
    atomText(i) {
      const a = this.atoms[i], r = this.residues[a.res];
      return `${r.comp} ${r.chain} ${r.num} · ${a.name}` + (r.role ? ` (${r.role.replace('_', '')})` : '') +
        `<small>label chain ${r.label_asym} · occ ${a.occ} · B ${a.B} Å²</small>`;
    }
    contactText(k) {
      const c = this.contacts[k], A = this.atoms[c.i], B = this.atoms[c.j], RA = this.residues[A.res], RB = this.residues[B.res];
      return `<b>${c.d.toFixed(2)} Å</b> ${RA.comp} ${RA.chain} ${RA.num} ${A.name} ··· ${RB.comp} ${RB.chain} ${RB.num} ${B.name}<small>${CLASS_STYLE[c.cls].label}</small>`;
    }
    setHighlight(k, fromViewer = false) {
      if (this.highlight === k) return;
      this.highlight = k; this.kick();
      if (fromViewer && this.opts.onHover) this.opts.onHover(k);
    }
    bindInput() {
      const cv = this.canvas; cv.tabIndex = 0;
      const pointers = new Map(); let last = null, pinch = null;
      const pos = e => { const r = cv.getBoundingClientRect(); return [e.clientX - r.left, e.clientY - r.top]; };
      const freeze = () => { if (this.opts.motion !== 'off') { this.angle = this.lastTheta; this.opts.motion = 'off'; this.host.dispatchEvent(new CustomEvent('motionchange', { detail: 'off' })); } };
      cv.addEventListener('pointerdown', e => {
        this.active = true;
        cv.setPointerCapture(e.pointerId); pointers.set(e.pointerId, pos(e));
        if (pointers.size === 1) { last = pos(e); this.dragging = true; this.dragButton = e.button; this.dragShift = e.shiftKey || e.ctrlKey; }
        if (pointers.size === 2) { const [p, q] = [...pointers.values()]; pinch = { d: Math.hypot(p[0] - q[0], p[1] - q[1]), z: this.zoom }; }
      });
      cv.addEventListener('pointermove', e => {
        const p = pos(e);
        if (pointers.has(e.pointerId)) pointers.set(e.pointerId, p);
        if (pinch && pointers.size === 2) {
          const [a, b] = [...pointers.values()]; this.zoom = Math.max(.3, Math.min(8, pinch.z * Math.hypot(a[0] - b[0], a[1] - b[1]) / pinch.d)); this.kick(); return;
        }
        if (this.dragging && last) {
          const dx = p[0] - last[0], dy = p[1] - last[1]; last = p;
          if (Math.abs(dx) + Math.abs(dy) > 0) freeze();
          if (this.dragButton === 2 || this.dragButton === 1 || this.dragShift) { this.pan[0] += dx; this.pan[1] += dy; }
          else this.user = orthonormalize(matMul(matMul(rotY(dx * .01), rotX(dy * .01)), this.user));
          this.tip.hidden = true; this.kick(); return;
        }
        const { atom, guide } = this.pick(p[0], p[1]);
        this.hoverAtom = guide >= 0 ? -1 : atom;
        this.setHighlight(guide, true);
        if (guide >= 0 || atom >= 0) {
          this.tip.innerHTML = guide >= 0 ? this.contactText(guide) : this.atomText(atom);
          this.tip.hidden = false;
          const tx = Math.min(p[0] + 14, this.cssW - this.tip.offsetWidth - 6), ty = p[1] + 16 + this.tip.offsetHeight > this.cssH ? p[1] - this.tip.offsetHeight - 10 : p[1] + 16;
          this.tip.style.transform = `translate(${Math.max(4, tx)}px,${ty}px)`;
        } else this.tip.hidden = true;
        cv.style.cursor = guide >= 0 || atom >= 0 ? 'pointer' : 'grab';
        this.kick();
      });
      const end = e => { pointers.delete(e.pointerId); if (pointers.size < 2) pinch = null; if (!pointers.size) { this.dragging = false; last = null; this.kick(); } };
      cv.addEventListener('pointerup', end); cv.addEventListener('pointercancel', end);
      cv.addEventListener('pointerleave', () => { this.active = false; if (!this.dragging) { this.tip.hidden = true; this.hoverAtom = -1; this.setHighlight(-1, true); } });
      cv.addEventListener('contextmenu', e => e.preventDefault());
      cv.addEventListener('wheel', e => {
        if (this.opts.compact) return;
        if (!(e.ctrlKey || e.metaKey || this.active)) { this.flashHint('Ctrl + scroll (or click the scene first) to zoom'); return; }
        e.preventDefault();
        const f = Math.exp(-e.deltaY * .0015), p = pos(e), cx = this.cssW / 2 + this.pan[0], cy = this.cssH / 2 + this.pan[1];
        const nz = Math.max(.3, Math.min(8, this.zoom * f)), k = nz / this.zoom;
        this.pan[0] += (p[0] - cx) * (1 - k); this.pan[1] += (p[1] - cy) * (1 - k); this.zoom = nz; this.kick();
      }, { passive: false });
      cv.addEventListener('dblclick', () => { this.reset(); });
      cv.addEventListener('keydown', e => {
        const step = e.shiftKey ? .26 : .087; let used = true;
        if (e.key === 'ArrowLeft') this.user = matMul(rotY(-step), this.user);
        else if (e.key === 'ArrowRight') this.user = matMul(rotY(step), this.user);
        else if (e.key === 'ArrowUp') this.user = matMul(rotX(-step), this.user);
        else if (e.key === 'ArrowDown') this.user = matMul(rotX(step), this.user);
        else if (e.key === '+' || e.key === '=') this.zoom = Math.min(8, this.zoom * 1.15);
        else if (e.key === '-') this.zoom = Math.max(.3, this.zoom / 1.15);
        else if (e.key === 'r' || e.key === 'R') this.reset();
        else used = false;
        if (used) { if (e.key.startsWith('Arrow')) freeze(); e.preventDefault(); this.kick(); }
      });
    }

    flashHint(text) {
      if (!this.hintEl) { this.hintEl = document.createElement('div'); this.hintEl.className = 'cv-hint'; this.host.appendChild(this.hintEl); }
      this.hintEl.textContent = text; this.hintEl.classList.add('show');
      clearTimeout(this.hintTimer); this.hintTimer = setTimeout(() => this.hintEl.classList.remove('show'), 1400);
    }

    /* ---------- export ---------- */
    exportPNG(widthPx, filename, caption) {
      const aspect = this.cssH / this.cssW, W = widthPx, H = Math.round(widthPx * aspect), k = W / this.cssW;
      const off = document.createElement('canvas'); off.width = W; off.height = H + Math.round(44 * k);
      const ctx = off.getContext('2d');
      // render in CSS-pixel space scaled by k so framing is identical to the screen
      const savedMemo = new Map(this.labelMemo);
      this.draw(ctx, this.cssW, this.cssH, k, performance.now(), 1);
      this.labelMemo = savedMemo;
      ctx.setTransform(1, 0, 0, 1, 0, 0);
      ctx.fillStyle = '#ffffff'; ctx.fillRect(0, H, W, off.height - H);
      ctx.fillStyle = '#3d4650'; ctx.font = `${13 * k}px ${FONT}`; ctx.textBaseline = 'middle'; ctx.textAlign = 'left';
      ctx.fillText(caption, 14 * k, H + 22 * k);
      off.toBlob(b => { const a = document.createElement('a'); a.href = URL.createObjectURL(b); a.download = filename; a.click(); setTimeout(() => URL.revokeObjectURL(a.href), 4000); }, 'image/png');
      this.kick();
    }
  }

  function roundRect(ctx, x, y, w, h, r) {
    ctx.beginPath(); ctx.moveTo(x + r, y); ctx.lineTo(x + w - r, y); ctx.quadraticCurveTo(x + w, y, x + w, y + r);
    ctx.lineTo(x + w, y + h - r); ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h); ctx.lineTo(x + r, y + h);
    ctx.quadraticCurveTo(x, y + h, x, y + h - r); ctx.lineTo(x, y + r); ctx.quadraticCurveTo(x, y, x + r, y); ctx.closePath();
  }

  window.PSIViewer = { ContactViewer, CLASS_STYLE, ELEMENT };
})();
