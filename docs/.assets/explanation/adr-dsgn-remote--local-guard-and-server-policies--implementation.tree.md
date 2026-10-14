# docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.md

`Tree minimap: adr-dsgn-remote--local-guard-and-server-policies--implementation`

![Tree minimap of adr-dsgn-remote--local-guard-and-server-policies--implementation](adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.png)

The tree minimap of the slide `adr-dsgn-remote--local-guard-and-server-policies--implementation` (implementation lens). The slide supports
[ADR-DSGN-REMOTE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 21 files in 4 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- docs (docs/ outside docs/adr/): 10 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][2], in the cell docs × markdown: selected
  by [ADR-DSGN-REMOTE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md][3], in the cell docs × markdown: selected
  by [ADR-DSGN-REMOTE][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][4], in the cell docs × markdown:
  selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.md][5], in the cell docs × markdown:
  selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md][6], in the cell docs × markdown: selected by
  [ADR-DSGN-REMOTE][1]: the file cites it at line 67 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][7], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file
  cites it at line 15 (text), line 45 (text), line 46 (text) and line 48 (text).
- [docs/explanation/design/guard-and-policies-by-command.md][8], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file
  cites it at line 16 (text), line 48 (text) and line 51 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][9], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file
  cites it at line 16 (text), line 19 (text), line 22 (text), line 49 (text), line 50 (text), line 50 (text) and line 52 (text).
- [docs/explanation/design/local-guard-and-server-policies.md][10], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file
  cites it at line 19 (text), line 55 (text) and line 58 (text).
- [docs/explanation/design/one-door-in-one-stable-point-out.md][11], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file
  cites it at line 14 (text), line 43 (text), line 44 (text), line 45 (text) and line 47 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][12], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][13], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][14], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][15], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][16], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][1], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][17], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][18], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][19], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][20], in the cell automation × yaml: selected by [ADR-DSGN-REMOTE][1]: the file cites it at
  line 100 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][21], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 93 (text).

## Keywords

- [world map][22]
- [track][23]
- [file language][24]
- [cell][25]
- [lit cell][26]
- [automation][27]: a track
- [docs][27]: a track
- [markdown][28]: a file language
- [yaml][28]: a file language

[1]: ../../adr/design/server-remote-integration.md
[2]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[3]: adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md
[4]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[5]: adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.md
[6]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md
[7]: ../../explanation/design/clients-bridge-to-one-server.md
[8]: ../../explanation/design/guard-and-policies-by-command.md
[9]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[10]: ../../explanation/design/local-guard-and-server-policies.md
[11]: ../../explanation/design/one-door-in-one-stable-point-out.md
[12]: ../../adr/design/commit-lifecycle.md
[13]: ../../adr/design/dora-explains.md
[14]: ../../adr/design/module-aspects.md
[15]: ../../adr/design/run-modes.md
[16]: ../../adr/design/self-service.md
[17]: ../../adr/design/thin-platforms.md
[18]: ../../adr/design/tracks.md
[19]: ../../adr/design/visual-design.md
[20]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../adr/index.md
[22]: ../../adr/glossary.md#world-map
[23]: ../../adr/glossary.md#track
[24]: ../../adr/glossary.md#file-language
[25]: ../../adr/glossary.md#cell
[26]: ../../adr/glossary.md#lit-cell
[27]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[28]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
