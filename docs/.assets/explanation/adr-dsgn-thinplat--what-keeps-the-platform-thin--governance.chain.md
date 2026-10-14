# docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md

`Value-chain minimap: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance`

![Value-chain minimap of adr-dsgn-thinplat--what-keeps-the-platform-thin--governance](adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.png)

The value-chain minimap of the slide `adr-dsgn-thinplat--what-keeps-the-platform-thin--governance` (governance lens). The slide supports
[ADR-AUTO-PARITY][1], [ADR-AZ-CLI][2] and [ADR-DSGN-THINPLAT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 6 value-chain concerns (automation, build, quality-control, release, deploy, access) and lights 5 cells, filled in ink.
Every other cell is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (7 of
the 30 cells hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain
map.

- DSGN × automation: 1 lit of 7 ADRs
- DSGN × deploy: 1 lit of 6 ADRs
- AUTO × automation: 1 lit of 63 ADRs
- CLOUD × deploy: 1 lit of 23 ADRs
- CLOUD × access: 1 lit of 3 ADRs

## Key

Rows are the value-chain stack and columns the value-chain concerns, each printed as a capital code:

- `PRIN`: the PRIN row of the value-chain stack
- `DSGN`: the DSGN row of the value-chain stack
- `AUTO`: the AUTO row of the value-chain stack
- `PIPE`: the PIPE row of the value-chain stack
- `CLOUD`: the CLOUD row of the value-chain stack
- `AUTOMA`: automation
- `BUILD`: build
- `QC`: quality-control
- `RELEAS`: release
- `DEPLOY`: deploy
- `ACCESS`: access

## Why each cell is lit

### DSGN × automation (1 ADR)

Lit ([ADR-DSGN-TRACK#12][4]) by:

- [ADR-DSGN-THINPLAT][3]: selected by [ADR-DSGN-THINPLAT][3]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][5]); its own value-chain concerns (automation and deploy) override its ADR domain's default (automation), so it
  lights the automation column ([ADR-DSGN-TRACK#15][6]).

### DSGN × deploy (1 ADR)

Lit ([ADR-DSGN-TRACK#12][4]) by:

- [ADR-DSGN-THINPLAT][3]: selected by [ADR-DSGN-THINPLAT][3]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][5]); its own value-chain concerns (automation and deploy) override its ADR domain's default (automation), so it
  lights the deploy column ([ADR-DSGN-TRACK#15][6]).

### AUTO × automation (1 ADR)

Lit ([ADR-DSGN-TRACK#12][4]) by:

- [ADR-AUTO-PARITY][1]: selected by [ADR-AUTO-PARITY][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][5]); its value-chain concerns (automation) are its ADR domain's default, so it lights the automation column
  ([ADR-DSGN-TRACK#15][6]).

### CLOUD × deploy (1 ADR)

Lit ([ADR-DSGN-TRACK#12][4]) by:

- [ADR-AZ-CLI][2]: selected by [ADR-AZ-CLI][2]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK#14][5]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it lights the
  deploy column ([ADR-DSGN-TRACK#15][6]).

### CLOUD × access (1 ADR)

Lit ([ADR-DSGN-TRACK#12][4]) by:

- [ADR-AZ-CLI][2]: selected by [ADR-AZ-CLI][2]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK#14][5]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it lights the
  access column ([ADR-DSGN-TRACK#15][6]).

## Keywords

- [value-chain map][7]
- [value-chain stack][8]
- [value-chain concern][9]
- [cell][10]
- [lit cell][11]

[1]: ../../adr/automation/devbox-pipeline-parity.md
[2]: ../../adr/azure/prefer-az-cli.md
[3]: ../../adr/design/thin-platforms.md
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[7]: ../../adr/glossary.md#value-chain-map
[8]: ../../adr/glossary.md#value-chain-stack
[9]: ../../adr/glossary.md#value-chain-concern
[10]: ../../adr/glossary.md#cell
[11]: ../../adr/glossary.md#lit-cell
