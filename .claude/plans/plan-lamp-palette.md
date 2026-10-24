---
plan:
  status: active
  value: high
  reviewed: 2026-10-25
  class: feature
  targets:
    - pwsh/Catzc.Base.VSCode/configs/vscode-settings.yml
    - pwsh/Catzc.Base.VSCode/private/New-VsCodeExtensionFolder.ps1
---

# Lamp palette: one declared colour range per meaning, for the lamp icons and the Explorer

Every colour the lamps and the editor show for a file's state is a value of one **range** declared once: committed green, local work in
progress blue-grey (staged dark, unstaged lighter), failed red, empty neutral grey, and any later state (the veto). A range carries a shade
per use: the lit glyph, the unlit glyph, the badge, file-name text, marks (gutter, ruler, minimap) and line backgrounds with their alpha.
The icons and the editor settings are rendered from it, so a colour changes in one line.

## Why its value is high

The 2026-10-25 change from brown/yellow to blue-grey touched 48 icons, 17 settings keys, an extension's defaults and a record by hand; the
same hex lives in four files and a generator script under `out/`. A declared range makes the next change one line and keeps the lamps and
the Explorer on one mapping (DDR-FILTER-STATEALWAYSSHOWN, PDR-CONFIG, PDR-ONELIVE).

## Decided (2026-10-25)

- Blue-grey is the range for local work in progress: staged `#546a85`, unstaged `#8fa3bd`, file names `#7d93b0` and `#b3c3d8`; empty is a
  neutral grey (`#8c8c8c` lit, `#6b6b6b` unlit), kept visibly apart from the blue-grey.
- Only each lamp's two base glyphs (`<lamp>-on.svg`, `<lamp>-off.svg`, green) are authored; every condition's variant is rendered from them
  by the palette when the extension folder is built, never committed. A new colour the icons need is a new range or shade in the palette,
  and its icons are generated, never drawn by hand.

## Open steps

1. [ ] `pwsh/Catzc.Base.VSCode/configs/lamp-palette.yml` (new) and its type `LampPaletteConfig` registered in `configs.yml`: the ranges
       committed, staged, unstaged, failed, empty (and veto once that state lands), each with `glyph_lit`, `glyph_unlit`, `badge`, `text`,
       `mark` and `background` (with alpha), every default declared once on the type (check: an L0 test of the type reads the file and
       refuses an unknown range key or a shade that is no `#rrggbb[aa]`).
2. [ ] `pwsh/Catzc.Base.VSCode/private/New-VsCodeExtensionFolder.ps1`: renders every lamp's condition variants into `media/` from its two
       base glyphs and the palette (colour swap plus the condition's badge), and the committed variant files under
       `assets/extensions/catzc-track-lamps/` are deleted (check: the L1 manifest test finds every icon a command names in the rendered
       folder, and `Test-GeneratedFiles` reports no committed variant).
3. [ ] `pwsh/Catzc.Base.VSCode/configs/vscode-settings.yml`: the git decoration, gutter, ruler, minimap, diff and git-changes colours name a
       palette shade (for example `palette.unstaged.text`) that `New-VsCodeSettings` resolves, and the `catzc-git-changes` defaults read the
       same shades (check: the rendered `.vscode/settings.json` holds the palette's hexes and no literal colour is left in the two configs).

## Refs

- DDR-FILTER-STATEALWAYSSHOWN, PDR-CONFIG, PDR-ONELIVE.
