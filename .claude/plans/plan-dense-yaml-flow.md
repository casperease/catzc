---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets:
    [
      python/catzc_diagrams/declaration.py,
      python/catzc_diagrams/tests/test_declaration.py,
      docs/drs/repository/slides-as-markdown.md,
      docs/drs/azure/.assets/azure-name-assembly.drawio.yml,
    ]
---

# Dense yaml flow

A diagram declaration is high-density data: `azure-name-assembly.drawio.yml` spends 374 lines on glyphs, edges and groups of three to four
short keys each, one key per line. The default block style suits most yml; a declaration reads better with each small record on one line.

## Why its value

The declaration is the one source a person and an agent read and edit by hand (ADR-REPO-SLIDES-DECLARATION, ADR-REPO-SLIDES-TWODIRECTIONS).
A glyph or edge on one line reads as one row of a table, and the file shrinks to roughly a third, which is less to read for every agent that
opens one of the 176 declarations.

## Decided

- **What flattens:** a node whose children are all scalars, a leaf mapping or a leaf list (a glyph, an edge, a group, a band, `adrs:`, a
  minimap's `by:`), is printed in flow style: `- { id: c-env, kind: set, label: 1 env, in: grp-name }`, `adrs: [ADR-AZ-NAMING]`. A node with
  a nested mapping or list keeps block style; its leaf children flatten on their own.
- **When it flattens:** only when the whole flow line, its indent and key included, is at most the limit; a longer one stays block style.
- **The limit:** `max_line_length` of the `[*.md]` section of the root `.editorconfig` (140), read at print time, never a second copy in the
  kit's `drawio.yml` or the code (PDR-CONFIG-VARYINGBEHAVIOURISCONFIG, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER). Prettier's `printWidth` is the
  same 140, so Prettier leaves a flow line that fits as it is.
- **The print form is Prettier's:** `{ a: b, c: d }` with inner spaces, `[a, b]` without, quoting as `yaml.safe_dump` gives a scalar, so a
  printed declaration passes Test-Formatting unchanged.
- **Reading does not change:** YAML parses flow and block alike, so `read_source`, `load` and the pwsh readers (`Write-DiagramMinimapData`,
  `Get-DiagramDeclarationText`) stay as they are.

## Open steps

- [ ] `python/catzc_diagrams/declaration.py`: a `print_width()` reading `max_line_length` under `[*.md]` from the repository root's
      `.editorconfig`, failing with the path and section when either is missing, and a `flow_yaml(data, width)` that dumps block style and
      prints each leaf node that fits as one flow line in Prettier's form; `dump()` returns `flow_yaml(out, print_width())` in place of its
      `yaml.safe_dump(..., width=120)`. (check:
      `uv run --project python/catzc_diagrams pytest python/catzc_diagrams/tests/test_declaration.py`)
- [ ] `python/catzc_diagrams/declaration.py`: `minimaps_block()` prints each `- cell: …` entry's `by:` as one flow line when it fits the
      same width, and its block list when not. (check: the same pytest file)
- [ ] `python/catzc_diagrams/tests/test_declaration.py`: tests with widget/gadget fixtures for a leaf mapping that fits (one flow line), one
      over the width (block), a nested mapping (block, its leaves flow), a leaf list, an empty string value, a scalar that needs quotes, the
      `by:` list both ways, `yaml.safe_load(flow_yaml(x)) == x` for each, and `print_width()` reading a temporary `.editorconfig`. (check:
      the same pytest file, every test green)
- [ ] `python/catzc_diagrams/declaration.py`: a `reflow <folder>` subcommand that rewrites one declaration in the printed form, keeping its
      generated head and its rows as read, and refuses to write when `load()` of the new text differs from `load()` of the old. (check: the
      same pytest file, with a reflow test over a fixture that has a head and a row)
- [ ] `docs/drs/azure/.assets/azure-name-assembly.drawio.yml`: reflowed by the new subcommand as the pilot. (check: the file shrinks from
      374 lines, `git diff --stat` shows that file only, Test-Formatting on it is clean, and
      `Build-Diagrams -Path docs/drs/azure/.assets/azure-name-assembly.drawio.yml` renders a png identical to the committed one)
- [ ] `docs/drs/repository/slides-as-markdown.md`: ADR-REPO-SLIDES-DECLARATION gains the print form in one sentence (a leaf node is one flow
      line when it fits the markdown `max_line_length`), with its reasoning in the section "The declaration is the source" (decisions become
      rules, ADR-REPO-PLANS-DECISIONSBECOMERULES). (check: Test-Drs and Test-Links on the file)

## Open questions

- **The other 175 declarations.** Recommended: reflow them through the subcommand after the pilot is committed, a folder of `.assets/` at a
  time, each write already guarded by the `load()` parity check, with the folder's renders checked unchanged. The alternative is to leave
  them until a sync rewrites each one, which leaves two print forms in the tree for a long time (PDR-ONELIVE).
- **Other dense yml.** Recommended: no. Configs are hand-authored, and Prettier keeps a flow line a person writes. A generic flattening step
  in Format-Code would need a comment-preserving YAML round trip that pwsh lacks; it opens as its own plan if a second dense file kind turns
  up.

## Refs

- The writers: `dump()` and `minimaps_block()` in `python/catzc_diagrams/declaration.py`; `save()` (sync) and `declare_minimaps()` call
  them.
- The limit: `pwsh/Catzc.Base.RootConfig/assets/root/.editorconfig` `[*.md]`, materialised to the root by Build-RootConfig;
  `.prettierrc.yml` `printWidth` holds the same 140.
