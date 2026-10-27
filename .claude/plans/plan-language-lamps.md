---
plan:
  status: active
  value: medium
  reviewed: 2026-10-25
  class: feature
  targets:
    [
      js/track-lamps,
      pwsh/Base.VSCode/configs/vscode-extensions.yml,
      pwsh/Base.VSCode/New-VsCodeSettings.ps1,
      pwsh/Base.Languages/configs/languages.yml,
      docs/drs/design/repository-filters.md,
    ]
---

# A languages button that clicks language lamps into the title row

A **button**, not a lamp, picks the languages: one click opens a pick list of the languages `languages.yml` declares, and every language
ticked there becomes a lamp of its own, after the filters, with everything a lamp has: off, on and veto, its condition colour, the red
journey, a place in the census and the status words. Unticking takes the lamp out of the row again.

## Why its value is medium

A reader often wants "only the Python" or "everything but the Bicep" for a while, which the filters do not cut. The lamp language already
takes any set of globs, so a language lamp is one set per language and no new rule; the work is the editor surface.

## Decided (2026-10-25)

- **Which languages**: every `languages.yml` entry with a `tag` (the short word a diagram prints, e.g. `py`, `go`, `js`), its sets one
  include per extension (`**/*<extension>`). The tag is the lamp's label, so a language without a tag is not offered.
- **The data**: `New-VsCodeSettings` renders `catzc.trackLamps.languages` again, now name to `{ tag, extensions }` for the tagged languages
  only, from the languages config; the engine reads only that setting.
- **The button**: one command, `catzc.lamps.languages.pick`, right of the last filter lamp, opening a multi-select quick pick (each row the
  tag, the language name and its extensions; the ticked ones pre-ticked). The ticked list lives in the workspace state, like the switches.
- **The lamps' commands**: the manifest's menus are static, so the commands of every tagged language are declared ahead by a second repeat
  over the languages config (`repeat: { language: { config: languages, list: languages, key: name } }`), the same veto/putOut/light commands
  per condition as a filter lamp, each shown only while its `catzc.lamps.shown.lang-<name>` key is set; the key is set when ticked.
- **The icons**: a generated label glyph per tag (the icon theme already draws label SVGs), recoloured per condition by the same renderer as
  the filter glyphs; no hand-drawn SVG per language.
- **Names**: a language lamp is `lang-<name>` in every key and in the status words (`catzc − lang-python`), so it never collides with a
  filter of the same name.

## Open steps

- [ ] Reload VS Code (`catzc-track-lamps` 0.26.0 is installed); tick two languages, put one out, veto the other, untick both. Check: the
      user's eye on the title row and the status line.
