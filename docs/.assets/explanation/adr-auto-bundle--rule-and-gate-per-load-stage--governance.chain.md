# docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md

`Value-chain minimap: adr-auto-bundle--rule-and-gate-per-load-stage--governance`

![Value-chain minimap of adr-auto-bundle--rule-and-gate-per-load-stage--governance](adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.png)

The value-chain minimap of the slide `adr-auto-bundle--rule-and-gate-per-load-stage--governance` (governance lens). The slide supports
[ADR-AUTO-BUNDLE][1], [ADR-AUTO-TYPES][2], [ADR-DSGN-RUNMODE][3], [ADR-PRIN-ONELIVE][4], [ADR-PWSH-ERROR][5], [ADR-PWSH-TYPES][6] and
[ADR-REPO-ROOTCFG][7]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 6 value-chain concerns (automation, build, quality-control, release, deploy, access) and lights 6 cells, filled in ink.
Every other cell is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (7 of
the 30 cells hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain
map.

- PRIN × release: 1 lit of 32 ADRs
- DSGN × automation: 1 lit of 7 ADRs
- DSGN × build: 1 lit of 5 ADRs
- AUTO × automation: 4 lit of 64 ADRs
- AUTO × build: 3 lit of 5 ADRs
- AUTO × release: 1 lit of 3 ADRs

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

### PRIN × release (1 ADR)

Lit ([ADR-DSGN-TRACK#12][8]) by:

- [ADR-PRIN-ONELIVE][4]: selected by [ADR-PRIN-ONELIVE][4]; its ADR domain `principles` sits on the PRIN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its own value-chain concerns (release) override its ADR domain's default (automation, build, quality-control,
  release, deploy and access), so it lights the release column ([ADR-DSGN-TRACK#15][10]).

### DSGN × automation (1 ADR)

Lit ([ADR-DSGN-TRACK#12][8]) by:

- [ADR-DSGN-RUNMODE][3]: selected by [ADR-DSGN-RUNMODE][3]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its own value-chain concerns (automation and build) override its ADR domain's default (automation), so it lights
  the automation column ([ADR-DSGN-TRACK#15][10]).

### DSGN × build (1 ADR)

Lit ([ADR-DSGN-TRACK#12][8]) by:

- [ADR-DSGN-RUNMODE][3]: selected by [ADR-DSGN-RUNMODE][3]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its own value-chain concerns (automation and build) override its ADR domain's default (automation), so it lights
  the build column ([ADR-DSGN-TRACK#15][10]).

### AUTO × automation (4 ADRs)

Lit ([ADR-DSGN-TRACK#12][8]) by:

- [ADR-AUTO-TYPES][2]: selected by [ADR-AUTO-TYPES][2]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its own value-chain concerns (automation and build) override its ADR domain's default (automation), so it lights
  the automation column ([ADR-DSGN-TRACK#15][10]).
- [ADR-PWSH-ERROR][5]: selected by [ADR-PWSH-ERROR][5]; its ADR domain `pwsh` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its value-chain concerns (automation) are its ADR domain's default, so it lights the automation column
  ([ADR-DSGN-TRACK#15][10]).
- [ADR-PWSH-TYPES][6]: selected by [ADR-PWSH-TYPES][6]; its ADR domain `pwsh` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its own value-chain concerns (automation and build) override its ADR domain's default (automation), so it lights
  the automation column ([ADR-DSGN-TRACK#15][10]).
- [ADR-REPO-ROOTCFG][7]: selected by [ADR-REPO-ROOTCFG][7]; its ADR domain `repository` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its value-chain concerns (automation) are its ADR domain's default, so it lights the automation column
  ([ADR-DSGN-TRACK#15][10]).

### AUTO × build (3 ADRs)

Lit ([ADR-DSGN-TRACK#12][8]) by:

- [ADR-AUTO-BUNDLE][1]: selected by [ADR-AUTO-BUNDLE][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its own value-chain concerns (build and release) override its ADR domain's default (automation), so it lights
  the build column ([ADR-DSGN-TRACK#15][10]).
- [ADR-AUTO-TYPES][2]: selected by [ADR-AUTO-TYPES][2]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its own value-chain concerns (automation and build) override its ADR domain's default (automation), so it lights
  the build column ([ADR-DSGN-TRACK#15][10]).
- [ADR-PWSH-TYPES][6]: selected by [ADR-PWSH-TYPES][6]; its ADR domain `pwsh` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its own value-chain concerns (automation and build) override its ADR domain's default (automation), so it lights
  the build column ([ADR-DSGN-TRACK#15][10]).

### AUTO × release (1 ADR)

Lit ([ADR-DSGN-TRACK#12][8]) by:

- [ADR-AUTO-BUNDLE][1]: selected by [ADR-AUTO-BUNDLE][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][9]); its own value-chain concerns (build and release) override its ADR domain's default (automation), so it lights
  the release column ([ADR-DSGN-TRACK#15][10]).

## Keywords

- [value-chain map][11]
- [value-chain stack][12]
- [value-chain concern][13]
- [cell][14]
- [lit cell][15]

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/automation/BCL/native-csharp-types.md
[3]: ../../adr/design/run-modes.md
[4]: ../../adr/principles/one-living-version.md
[5]: ../../adr/pwsh/error-handling.md
[6]: ../../adr/pwsh/hosting-csharp-types.md
[7]: ../../adr/repository/generated-root-configs.md
[8]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[9]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[10]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[11]: ../../adr/glossary.md#value-chain-map
[12]: ../../adr/glossary.md#value-chain-stack
[13]: ../../adr/glossary.md#value-chain-concern
[14]: ../../adr/glossary.md#cell
[15]: ../../adr/glossary.md#lit-cell
