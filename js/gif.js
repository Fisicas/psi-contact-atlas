/* Minimal animated-GIF (GIF89a) writer for the contact viewer. No dependencies.
   Palette: 256 colours chosen by popularity from sample frames (5 bits per channel, bin means).
   LZW: the classic variable-code-length compressor used by GIF encoders (12-bit codes, open-addressed hash). */
'use strict';
(function () {
  const bin = (r, g, b) => ((r >> 3) << 10) | ((g >> 3) << 5) | (b >> 3);

  function buildPalette(samples) {
    const count = new Uint32Array(32768), sr = new Float64Array(32768), sg = new Float64Array(32768), sb = new Float64Array(32768);
    for (const px of samples) {
      for (let i = 0; i < px.length; i += 8) {           // every second pixel is plenty
        const k = bin(px[i], px[i + 1], px[i + 2]);
        count[k]++; sr[k] += px[i]; sg[k] += px[i + 1]; sb[k] += px[i + 2];
      }
    }
    const used = [];
    for (let k = 0; k < 32768; k++) if (count[k]) used.push(k);
    used.sort((a, b) => count[b] - count[a]);
    const top = used.slice(0, 256), pal = new Uint8Array(768);
    top.forEach((k, i) => { pal[i * 3] = Math.round(sr[k] / count[k]); pal[i * 3 + 1] = Math.round(sg[k] / count[k]); pal[i * 3 + 2] = Math.round(sb[k] / count[k]); });
    return { pal, n: top.length };
  }

  class GifWriter {
    constructor(width, height, palette) {
      this.w = width; this.h = height; this.pal = palette.pal; this.n = palette.n;
      this.lookup = new Int16Array(32768).fill(-1);
      this.parts = []; this.buf = [];
      const b = this.buf;
      for (const c of 'GIF89a') b.push(c.charCodeAt(0));
      b.push(width & 255, width >> 8, height & 255, height >> 8, 0xF7, 0, 0);   // global table, 256 entries
      for (let i = 0; i < 768; i++) b.push(this.pal[i]);
      b.push(0x21, 0xFF, 11); for (const c of 'NETSCAPE2.0') b.push(c.charCodeAt(0)); b.push(3, 1, 0, 0, 0);  // loop forever
      this.flushBuf();
    }
    flushBuf() { if (this.buf.length) { this.parts.push(new Uint8Array(this.buf)); this.buf = []; } }
    nearest(k) {
      let v = this.lookup[k];
      if (v >= 0) return v;
      const r = ((k >> 10) << 3) + 4, g = (((k >> 5) & 31) << 3) + 4, b = ((k & 31) << 3) + 4, p = this.pal;
      let best = 0, bd = Infinity;
      for (let i = 0; i < this.n; i++) {
        const dr = p[i * 3] - r, dg = p[i * 3 + 1] - g, db = p[i * 3 + 2] - b, d = dr * dr * 2 + dg * dg * 4 + db * db * 3;
        if (d < bd) { bd = d; best = i; }
      }
      this.lookup[k] = best; return best;
    }
    addFrame(rgba, delayCs) {
      const n = this.w * this.h, idx = new Uint8Array(n);
      for (let i = 0, j = 0; i < n; i++, j += 4) idx[i] = this.nearest(bin(rgba[j], rgba[j + 1], rgba[j + 2]));
      const b = this.buf;
      b.push(0x21, 0xF9, 4, 0x04, delayCs & 255, delayCs >> 8, 0, 0);            // graphic control: no disposal of previous
      b.push(0x2C, 0, 0, 0, 0, this.w & 255, this.w >> 8, this.h & 255, this.h >> 8, 0);
      lzw(idx, 8, b);
      this.flushBuf();
    }
    finish() { this.buf.push(0x3B); this.flushBuf(); return new Blob(this.parts, { type: 'image/gif' }); }
  }

  function lzw(pixels, initCodeSize, out) {
    const BITS = 12, MAXMAX = 1 << BITS, HSIZE = 5003;
    const htab = new Int32Array(HSIZE).fill(-1), codetab = new Int32Array(HSIZE);
    const CLEAR = 1 << initCodeSize, EOI = CLEAR + 1;
    let nBits = initCodeSize + 1, maxcode = (1 << nBits) - 1, freeEnt = CLEAR + 2, clearFlg = false;
    let acc = 0, accBits = 0;
    const block = new Uint8Array(255); let bc = 0;
    const flushBlock = () => { if (bc) { out.push(bc); for (let i = 0; i < bc; i++) out.push(block[i]); bc = 0; } };
    const byte = c => { block[bc++] = c; if (bc >= 254) flushBlock(); };
    const output = code => {
      acc &= (1 << accBits) - 1;
      acc = accBits > 0 ? acc | (code << accBits) : code;
      accBits += nBits;
      while (accBits >= 8) { byte(acc & 255); acc >>>= 8; accBits -= 8; }
      if (freeEnt > maxcode || clearFlg) {
        if (clearFlg) { nBits = initCodeSize + 1; maxcode = (1 << nBits) - 1; clearFlg = false; }
        else { nBits++; maxcode = nBits === BITS ? MAXMAX : (1 << nBits) - 1; }
      }
      if (code === EOI) { while (accBits > 0) { byte(acc & 255); acc >>>= 8; accBits -= 8; } flushBlock(); }
    };
    let hshift = 0; for (let f = HSIZE; f < 65536; f *= 2) hshift++; hshift = 8 - hshift;
    out.push(initCodeSize);
    let ent = pixels[0];
    output(CLEAR);
    outer: for (let p = 1; p < pixels.length; p++) {
      const c = pixels[p], fcode = (c << BITS) + ent;
      let i = (c << hshift) ^ ent;
      if (htab[i] === fcode) { ent = codetab[i]; continue; }
      if (htab[i] >= 0) {
        let disp = HSIZE - i; if (i === 0) disp = 1;
        do { if ((i -= disp) < 0) i += HSIZE; if (htab[i] === fcode) { ent = codetab[i]; continue outer; } } while (htab[i] >= 0);
      }
      output(ent); ent = c;
      if (freeEnt < MAXMAX) { codetab[i] = freeEnt++; htab[i] = fcode; }
      else { htab.fill(-1); freeEnt = CLEAR + 2; clearFlg = true; output(CLEAR); }
    }
    output(ent); output(EOI);
    out.push(0);
  }

  window.PSIGif = { buildPalette, GifWriter };
})();
