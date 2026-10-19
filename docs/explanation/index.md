# Explanation

```text
Explanation articles: how cats works and why, one diagram each.

automation      module dependencies, the importer, the bundle, and what compiled types cost
azure           how Azure resource names are assembled
configuration   how configuration is read, cached and addressed
design          the commit lifecycle, run modes, module aspects, tracks, the thin platform, the server remote
flow            promotion, the pipeline runner, and the globsets that trigger pipelines
pipelines       how Azure DevOps calls prove their credentials
repository      how managed root files and repository variants are kept in shape
```

The documentation has four kinds of article. An [ADR](../adr/index.md) records a decision and the rules it sets. A
[how-to](../how-to/getting-started/automation/index.md) walks through one task. A [reference](../references/pwsh/index.md) describes a
module's responsibilities. An **explanation** article shows how one part of cats works and why it holds: each one narrates a single diagram,
step by step, and points back to the ADR rules the diagram supports.

Each diagram is drawn five times, through five lenses, so the same idea can be read at the depth a reader needs:

| Lens               | Shows                                                                  |
| ------------------ | ---------------------------------------------------------------------- |
| **meta**           | the idea and the one rule that holds, with no function or file names   |
| **architecture**   | the parts, their boundaries, and who depends on whom                   |
| **implementation** | the real functions, files and configs, in the order the code runs them |
| **operations**     | what a person or a pipeline runs, and what they see when it fails      |
| **governance**     | which ADR rule constrains each step, and which gate checks it          |

## How to read the diagrams

Every diagram uses the same glyphs. The shape says what kind of thing an element is, and the colour says whether it is structure (dark, with
white text) or state and outcome (light). Every diagram also carries its own legend panel.

![The glyph library: one kind, one shape, one colour, one legend phrase](.assets/glyphs/diagram.drawio.png)

The glyph library is described element by element in [its asset description](.assets/glyphs/diagram.drawio.md).

The sidebar of every diagram places it on three maps, each drawn small as a minimap:

- The **world map** is the repository drawn as its tracks crossed with its file languages
  ([ADR-DSGN-TRACK-WORLDMAP](../adr/design/tracks.md#rule-adr-dsgn-track-worldmap)). It shows where the files the diagram concerns are.
- The **tree** is the repository's files, grouped by folder. It shows the same files in the folders that hold them.
- The **value-chain map** is the ADRs drawn as the value-chain stack crossed with the value-chain concerns
  ([ADR-DSGN-TRACK-VALUECHAINMAP](../adr/design/tracks.md#rule-adr-dsgn-track-valuechainmap)). It shows where the decision sits in delivery.

On each map, a **lit cell** ([ADR-DSGN-TRACK-LITCELL](../adr/design/tracks.md#rule-adr-dsgn-track-litcell)) is one the diagram's ADR
selects; a cell lit only by passing mentions is drawn lighter, and every other cell is idle. The map key below the minimaps names the four
swatches, and each minimap's own description, in the minimap's sub-folder of `docs/explanation/.assets/` (`grid/`, `tree/`, `chain/`), gives
the reason for every lit cell.

## Domains

The articles are grouped by the ADR domain of the decision they explain:

- [Ado](ado/index.md) — how Azure DevOps calls prove their credentials.
- [Automation](automation/index.md) — module dependencies, the importer, and the bundle.
- [Azure](azure/index.md) — how Azure resource names are assembled.
- [Configuration](configuration/index.md) — how configuration is read, cached and addressed.
- [Design](design/index.md) — the commit lifecycle, run modes, module aspects, tracks, the thin platform, and the server remote.
- [Flow](flow/index.md) — promotion, the pipeline runner, and the globsets that trigger pipelines.
- [Repository](repository/index.md) — how managed root files and repository variants are kept in shape.
- [Thesis](thesis/index.md) — the product thesis as a deck of slide files.
