# Explanation

```text
Explanation articles: how cats works and why, one diagram each.

automation      module dependencies, the importer, the bundle, and what compiled types cost
azure           how Azure resource names are assembled
configuration   how configuration is read, cached and addressed
design          the commit lifecycle, run modes, module aspects, tracks, the thin platform, the server remote
flow            promotion, the pipeline runner, and the globsets that trigger pipelines
model           the physical and meta models, where each is declared, and the zoom ladder
pipelines       how Azure DevOps calls prove their credentials
repository      how managed root files and repository variants are kept in shape
```

The documentation has four kinds of article. A [decision record](../drs/index.md) records a decision and the rules it sets. A
[how-to](../how-to/getting-started/automation/index.md) walks through one task. A [reference](../references/pwsh/index.md) describes a
module's responsibilities. An **explanation** article shows how one part of cats works and why it holds: each one narrates a single diagram,
step by step, and points back to the DRS rules the diagram supports.

Each diagram is drawn through a lens, what it shows, and may stand at a zoom level, how far out it stands; the
[zoom ladder](model/the-zoom-ladder.md) names the lenses and the five levels and how they cross.

## How to read the diagrams

Every diagram uses the same glyphs. The shape says what kind of thing an element is, and the colour says whether it is structure (dark, with
white text) or state and outcome (light). Every diagram also carries its own legend panel.

![The glyph library: one kind, one shape, one colour, one legend phrase](.assets/glyphs.drawio.png)

The glyph library is described element by element in the kit's
[style guide](../../python/catzc_diagrams/assets/STYLE.md#glyphs-one-kind-one-shape-one-colour-one-legend-phrase).

The sidebar of every diagram places it on three maps, each drawn small as a minimap:

- The **world map** is the repository drawn as its tracks crossed with its file languages
  ([DDR-TRACK-WORLDMAP](../drs/design/tracks.md#rule-ddr-track-worldmap)). It shows where the files the diagram concerns are.
- The **tree** is the repository's files, grouped by folder. It shows the same files in the folders that hold them.
- The **value-chain map** is the decision records drawn as the value-chain stack crossed with the value-chain concerns
  ([DDR-TRACK-VALUECHAINMAP](../drs/design/tracks.md#rule-ddr-track-valuechainmap)). It shows where the decision sits in delivery.

On each map, a **lit cell** ([DDR-TRACK-LITCELL](../drs/design/tracks.md#rule-ddr-track-litcell)) is one the diagram's decision record
selects; a cell lit only by passing mentions is drawn lighter, and every other cell is idle. The map key below the minimaps names the four
swatches, and each minimap's own description, in the minimap's sub-folder of `docs/explanation/.assets/` (`grid/`, `tree/`, `chain/`), gives
the reason for every lit cell. An inspection note on a diagram is deleted once the engine answers it, never marked done.

## Domains

The articles are grouped by the decision-record domain of the decision they explain:

- [Ado](ado/index.md) — how Azure DevOps calls prove their credentials.
- [Automation](automation/index.md) — module dependencies, the importer, and the bundle.
- [Azure](azure/index.md) — how Azure resource names are assembled.
- [Configuration](configuration/index.md) — how configuration is read, cached and addressed.
- [Design](design/index.md) — the commit lifecycle, run modes, module aspects, tracks, the thin platform, and the server remote.
- [Flow](flow/index.md) — promotion, the pipeline runner, and the globsets that trigger pipelines.
- [Model](model/index.md) — the physical and meta models, where each is declared, and the zoom ladder.
- [Repository](repository/index.md) — how managed root files and repository variants are kept in shape.
- [Thesis](thesis/index.md) — the product thesis as a deck of slide files.
