# docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md

`Value-chain minimap: adr-auto-bundle--every-code-root-is-a-copy--architecture`

![Value-chain minimap of adr-auto-bundle--every-code-root-is-a-copy--architecture](adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.png)

The value-chain minimap of the slide `adr-auto-bundle--every-code-root-is-a-copy--architecture` (architecture lens). The slide supports
[ADR-AUTO-BUNDLE][1] and [ADR-DSGN-RUNMODE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 6 value-chain concerns (automation, build, quality-control, release, deploy, access) and lights 4 cells, filled in ink.
Every other cell is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (7 of
the 30 cells hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain
map.

- DSGN × automation: 1 lit of 7 ADRs
- DSGN × build: 1 lit of 5 ADRs
- AUTO × build: 1 lit of 5 ADRs
- AUTO × release: 1 lit of 3 ADRs

## Key

Rows are the value-chain stack and columns the value-chain concerns, each printed as a capital code:

- `PRIN`: the PRIN row of the value-chain stack
- `DSGN`: the DSGN row of the value-chain stack
- `AUTO`: the AUTO row of the value-chain stack
- `PIPE`: the PIPE row of the value-chain stack
- `CLOUD`: the CLOUD row of the value-chain stack
- `LOCAL`: the LOCAL row of the value-chain stack
- `BUILD`: build
- `QC`: quality-control
- `RELEASE`: release
- `DEPLOY`: deploy
- `ACCESS`: access

## Why each cell is lit

### DSGN × automation (1 ADR)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-DSGN-RUNMODE][2]: selected by [ADR-DSGN-RUNMODE][2]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (automation and build) override its ADR domain's default (automation), so it lights
  the automation column ([ADR-DSGN-TRACK#15][5]).

### DSGN × build (1 ADR)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-DSGN-RUNMODE][2]: selected by [ADR-DSGN-RUNMODE][2]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (automation and build) override its ADR domain's default (automation), so it lights
  the build column ([ADR-DSGN-TRACK#15][5]).

### AUTO × build (1 ADR)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-AUTO-BUNDLE][1]: selected by [ADR-AUTO-BUNDLE][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (build and release) override its ADR domain's default (automation), so it lights
  the build column ([ADR-DSGN-TRACK#15][5]).

### AUTO × release (1 ADR)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-AUTO-BUNDLE][1]: selected by [ADR-AUTO-BUNDLE][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (build and release) override its ADR domain's default (automation), so it lights
  the release column ([ADR-DSGN-TRACK#15][5]).

## Keywords

- [value-chain map][6]
- [value-chain stack][7]
- [value-chain concern][8]
- [cell][9]
- [lit cell][10]

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/design/run-modes.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[6]: ../../adr/glossary.md#value-chain-map
[7]: ../../adr/glossary.md#value-chain-stack
[8]: ../../adr/glossary.md#value-chain-concern
[9]: ../../adr/glossary.md#cell
[10]: ../../adr/glossary.md#lit-cell
