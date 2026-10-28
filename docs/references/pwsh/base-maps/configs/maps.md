# pwsh/Base.Maps/configs/maps.yml

The map settings: the palette, the limits and the printed labels of the world map and the value-chain map, the minimaps, the reviewed
highlight pins and exceptions, and the folder the PDFs are written to. The shipped file is empty (`{}`): every key has its default on
`Catzc.Base.Maps.MapsConfig` and the section types it holds
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), and a key
is set only to change it. `Get-Config -Config maps` loads it.

## Keys

- **`palette`** — colours, each `#` and six hex digits: `background` (the page, drawn first), `row`, `column` and `cell` (the headers and an
  empty cell, the idle end of the file-count scale), `shade` (the fullest cell), `line`, `text`, `violation` (the mark of a cell that breaks
  its track's tech-stack) and `highlight` (the outline of a lit cell; the slide minimaps fill a lit cell with it). The defaults are the dark
  tokens of the diagram kit.
- **`limits`** — positive numbers: `page_width` and `page_height` in PDF points (842 by 595, A4 landscape), `min_font_size` (the smallest a
  label shrinks to, 6), `max_row_label` (24 characters of a track name) and `max_column_label` (16 characters of a file-language name).
- **`labels`** — the fixed text the maps print. The world map has `grid_title`, `tree_title`, `row_axis`, `column_axis`, `root_files`,
  `unlisted_files` and three legend entries. The value-chain map has the keys that start `value_chain_`: a title, two axes and two legend
  entries. A label is WinAnsi text, the only text the base-14 PDF fonts show, and its head, the text before the first `:`, names a defined
  term ([DDR-TRACK-LABELSNAMEDEFINEDTERMS](../../../../drs/design/tracks.md#rule-ddr-track-labelsnamedefinedterms)). The row labels fit
  `max_row_label` and the column labels `max_column_label`; the value-chain labels have no limit.
- **`highlight`** — reviewed overrides of the derived highlight: `pins` (cells a rule always lights), `exceptions` (cells a rule never
  lights, a passing mention) and `citation_exclude` (globs of files whose citations light nothing; each still sits in its cell). A pin or
  exception is `{ rule, track, file_language, reason }`.
- **`minimaps`** — which minimaps an explanation or a reference diagram may show, the command that computes each one's data, and the axis
  and place budgets.
- **`output_folder`** — one folder name under the output root, `world-map` by default
  ([ADR-REPO-OUTDIR-SUBDIRECTORYPERPRODUCER](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-subdirectoryperproducer)).

## Why the labels name terms

The catch-all row prints the root files ([DDR-TRACK-ROOTFILE](../../../../drs/design/tracks.md#rule-ddr-track-rootfile)) and the catch-all
column the unlisted files ([DDR-TRACK-UNLISTEDFILE](../../../../drs/design/tracks.md#rule-ddr-track-unlistedfile)). The value-chain labels
follow [ADR-REPO-VALUECHAIN-MAP][r1]. `Test-WorldMap` checks the world-map labels and `Test-ValueChainMap` the value-chain ones.

## Default citation exclusions

By default the files whose citations light nothing are the session logs and plans under `.claude/`, the diagram assets under
`docs/**/.assets/`, the explanation articles under `docs/explanation/` and the drawing tooling under `python/diagrams/`. A slide's minimap
then lights the repository's citations of its rules, never the slide's own words.

[r1]: ../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-map
