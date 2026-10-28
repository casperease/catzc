---
plan:
  status: active
  value: high
  reviewed: 2026-10-28
  class: meta
  targets:
    [
      pwsh/Base.GeneratedFiles,
      pwsh/Base.Variants,
      pwsh/Base.Globs,
      pwsh/Base.Languages,
      pwsh/Base.Slides,
      pwsh/Base.Docs,
      pwsh/Base.Drs,
      pwsh/Base.Contracts,
      pwsh/Base.QualityGates,
      python/diagrams,
      js/track-lamps,
      docs/drs/repository,
    ]
---

# Every generated artifact known, stamped and rollable

## Why high

Generated output is the repository's weak spot. Of 130 MB tracked, 100 MB is PNG, and most of it is not known as generated: 201
`*.drawio.png`, 185 `*.slide.png` and 91 slide pictures (`<id>.png`) come from a chain (a `.drawio.yml` or a `yml drawio` block in an
article, then the png, then the picture, then the slide png) that only `Build-Diagrams` half declares, as a target with no inputs. The
`generated` fact is spread over six configs (`generated-files.yml`, every module's `configs/generated.yml`, `rootconfig.yml`, `readme.yml`,
`comment-pages.yml`, the variants members' `generated`/`committed`), which is two answers to one question (PDR-ONELIVE). Nobody can safely
take the generated files out of a working copy and render them back, and a reader of a png cannot learn where it comes from.

## Decided

- The registry is the one truth: each module's `configs/generated.yml` declares its writers whole (name, inputs, outputs, class, check, and
  for each output the inputs it reads); `pwsh/Base.GeneratedFiles/configs/generated-files.yml` is deleted. `readme.yml`, `rootconfig.yml`
  and `comment-pages.yml` stay as the configs that expand a writer's instances; its row points at them.
- Re-render order is derived from the input/output graph, never listed by hand. The same graph answers "what is this file's source" and
  "is it stale" (the writer's input-hash stamp), images included.
- A writer has one class: `rollable`, `import-critical` (importer, root configs, track-sets, module manifests: never rolled off, since the
  session that restores them must import), `snapshot` (reads outside the tree, `Update-AzurePriceTable`, `Update-AdoFlowOccupants`: never
  rolled off), `untracked` (out/, bin/obj, .venv).
- Roll off / roll on is one operation over the existing `generated` filter view (`filters.yml`): `Remove-Generated` deletes the view's
  rollable files from the working copy, so git shows them deleted; `Restore-Generated` runs their writers in graph order. A clean round trip
  (`Remove-Generated`, `Restore-Generated`, then `git status` shows no change) is the safety proof.
- The head is a stamp, never a source: every committed generated file carries one, projected from its registry row when the writer writes
  it and never read back (ADR-REPO-FILEMETA-NOREADBACK). It is a one-way note to a person and may be out of sync, so no command decides
  anything from it: which files are generated, which `Remove-Generated` deletes and which `Restore-Generated` renders come from the
  registry alone, and a file with a head on no declared path is authored as far as every tool is concerned. `with_body_sha` stays only as
  the drift check's fast path, which falls back to the full render on any mismatch. Keys, in order: `warning`,
  `regenerate`, `sources` (this file's own inputs), `remove`, `with_body_sha`. The commands are templates declared once in
  `generated-head.yml` (`"{writer} -Path {path}"`), a writer row overriding where its call differs; no writer words its own head.
- One head renderer: the C# type renders the head text; PowerShell and Python writers both stamp through it, Python by calling the one
  command, never by a copy of the logic.
- A carrier for every committed generated format: png a `tEXt` chunk keyed `catzc` (the body sha hashes the image without it), svg a
  `<metadata>` element, xml a `<?catzc ...?>` processing instruction, json the `"//"` property. A generated format with no carrier is
  never committed.
- This reverses ADR-REPO-FILEMETA-PROVENANCEINHEAD's "the registry answers, never written into the file" and widens
  ADR-REPO-FILEMETA-COMPOSEDFILES's two-key head; both rules are reworded in the same change as the head type, and the 2026-10-19
  body-sha-only decision is superseded.

## Open steps

### Proof first

- [ ] `out/generated-determinism.ps1` (scratch) renders five `*.drawio.png`, five slide pictures and five `*.slide.png` twice each into
      `out/` and compares hashes; a writer that is not byte-stable gets its fix step here before any roll-off step lands. Check: the
      script's report lists 15 equal pairs.
- [ ] The lamp SVGs: `js/track-lamps/assets/*.svg` traced to their writer (lamp palette or hand-drawn) and the six
      `python/diagrams/assets/flow/*.svg` confirmed as `flow_glyphs.py` output; the answers land as rows in the registry step below or as
      "authored" in this plan. Check: `Test-Plans` reports 0 issues.
- [ ] The comment pages: `Get-GeneratedTarget` declares `<page root>/**` by `Format-Code` while ADR-REPO-COMMENTS-PAGEISAUTHORED says a
      page is authored; the rule decides and `pwsh/Base.Variants/Get-GeneratedTarget.ps1` drops the comment-page block if they are
      authored. Check: `Invoke-Pester pwsh/Base.Variants/tests` passes.
- [ ] The contract `types.json`: whether a frozen contract asset may carry a head is read from ADR-REPO-CONTRACT-RELEASEDIMMUTABLE; the
      answer becomes a line under Decided. Check: `Test-Plans` reports 0 issues.

### Rules

- [ ] `docs/drs/repository/file-meta.md`: ADR-REPO-FILEMETA-PROVENANCEINHEAD and ADR-REPO-FILEMETA-COMPOSEDFILES reworded to the stamp
      head (keys, templates, one renderer, every committed generated file); the carrier table text gains png, svg, xml; the registry named
      as the per-module `generated.yml`. Check: `Test-DrsRegistry` and `Test-Links` report 0 issues.
- [ ] `docs/drs/repository/generated-root-configs.md` (or the record that owns writers) gains the writer classes, the derived order and the
      roll-off round trip as rules. Check: `Test-DrsRegistry` reports 0 issues.

### One registry

- [ ] `pwsh/Base.Variants/types/GeneratedConfig.cs`: a target row becomes a writer row (name, inputs, outputs with per-output inputs,
      class, check, at_import, command overrides), validated in the constructor. Check: `Invoke-Pester pwsh/Base.Variants/tests` passes.
- [ ] Each module `configs/generated.yml` (Contracts, Docs, Drs, Globs, ModuleSystem, Repository, Slides, TypesSystem, Tooling.Python) takes
      its writers' rows from `generated-files.yml`, one file at a time. Check: `Test-ConfigValidators` reports 0 issues after each file.
- [ ] `pwsh/Base.Slides/configs/generated.yml` declares the image chain: `Build-Diagrams` (inputs `*.drawio.yml` and article `yml drawio`
      blocks), `slide_png picture` (the slide head and its source png), `slide_png render` (the slide md and its picture), each per output.
      Check: `Test-Diagrams` and `Test-Slides` report 0 issues.
- [ ] The unregistered writers gain rows in their own modules: `Build-FrontPage`, `Build-CommentView`, `Export-Comments`,
      `New-GitAttributes`, `Save-PsReadLineKeyHandlerSet`, `flow_glyphs.py`, `Update-AzurePriceTable` and `Update-AdoFlowOccupants`
      (snapshot). Check: `Test-GeneratedFiles` reports 0 issues.
- [ ] `pwsh/Base.GeneratedFiles/types/GeneratedFilesConfig.cs` reads the module rows and derives the order by a topological sort over
      inputs and outputs, failing on a cycle. Check: `Invoke-Pester pwsh/Base.GeneratedFiles/tests` passes.
- [ ] `pwsh/Base.GeneratedFiles/configs/generated-files.yml` is deleted and every reader (`Test-GeneratedFiles`,
      `Get-GeneratedWriterDue`, `Build-TrackGlobSets`, `Build-RootConfig`'s `.gitattributes` render) reads the one registry in the same
      change, by staged burst (import path). Check: `Test-GeneratedFiles` reports 0 issues in a fresh import.
- [ ] `pwsh/Base.Variants/Get-GeneratedTarget.ps1` answers from the one registry; `.gitattributes` `linguist-generated` lines then cover the
      images. Check: `Test-RootConfigFiles` reports 0 issues.

### Stamp heads

- [ ] `pwsh/Base.Languages/types/GeneratedHeadConfig.cs` knows `warning`, `regenerate`, `sources`, `remove`, `with_body_sha` and the
      command templates; `pwsh/Base.Languages/configs/generated-head.yml` lists them. Check: `Invoke-Pester pwsh/Base.Languages/tests`
      passes.
- [ ] `pwsh/Base.Languages/configs/file-carriers.yml`: `diagram-render` and `asset` (generated png) get a `png-text` carrier, svg a
      `metadata` carrier, `xml` a `processing-instruction` carrier; the carrier kinds land in the carrier type. Check:
      `Test-ConfigValidators` reports 0 issues.
- [ ] `pwsh/Base.Languages/Format-GeneratedFileHead.ps1` fills the head from the writer row and writes the three new carriers; a command
      exposes the renderer to Python. Check: `Invoke-Pester pwsh/Base.Languages/tests` passes.
- [ ] `pwsh/Base.Slides/Build-Diagrams.ps1`, `python/diagrams/slide_png.py`, `python/diagrams/flow_glyphs.py` stamp through the one
      renderer. Check: `Test-Diagrams` reports 0 issues and `Test-PythonLint` passes.
- [ ] `pwsh/Base.QualityGates/Test-FileMeta.ps1` (or `Test-GeneratedFiles`) walks the registry, never the heads: for every tracked path in
      the `generated` view the writer's dry run renders the file, head included, and a byte difference is a finding (a stale or hand-edited
      head is drift like any other). Check: the gate reports 0 issues after a full re-render.

### Roll off, roll on

- [ ] `pwsh/Base.GeneratedFiles/Remove-Generated.ps1` (new public, staged burst): deletes the rollable files of the `generated` view, resolved
      from the registry and never from a head, from the working copy; `-WhatIf` lists them. Check: its Pester test passes on a fixture tree.
- [ ] `pwsh/Base.GeneratedFiles/Restore-Generated.ps1` (new public, staged burst): runs the writers of the missing or stale rollable files
      in graph order. Check: its Pester test passes on a fixture tree.
- [ ] A commit guard refuses staged deletions of generated files the view says stay committed. Check: its Pester test passes.
- [ ] The round trip on the real tree: `Remove-Generated`, `Restore-Generated`, `git status --porcelain` empty. Check: the user's full run.

## Refs

- [file-meta](../../docs/drs/repository/file-meta.md), [generated-root-configs](../../docs/drs/repository/generated-root-configs.md),
  [plans](../../docs/drs/repository/plans.md), [one-living-version](../../docs/drs/principles/one-living-version.md).
- The 2026-10-28 survey: six `generated` configs, 477 tracked png (79 MB drawio, 16 MB slide), 89 svg, 158 articles with `yml drawio`
  blocks against 46 `.drawio.yml` files.
