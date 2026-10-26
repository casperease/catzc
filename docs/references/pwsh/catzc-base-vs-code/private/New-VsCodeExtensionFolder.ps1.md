# pwsh/Base.VSCode/private/New-VsCodeExtensionFolder.ps1

The private renderer of one of the repository's own editor extensions into a folder the editor can pack, from its registry entry and its
script.

## help

### synopsis

Renders one of the repository's own editor extensions to a folder the editor can pack, from its registry entry and its script.

### description

The extension's package.json is rendered from its entry under `extensions:` in vscode-extensions.yml, and its script is copied from the
module's `assets/extensions/<name>.js` to `extension.js`. The folder is generated output: it is replaced on every render, so nothing in it
is edited by hand.

It rests on
[ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency).

### parameter `Extension`

The registry entry to render.

### parameter `OutputDirectory`

The folder the extension folder is written under, as `<OutputDirectory>/<name>/`.

### parameter `AssetDirectory`

The folder that holds the extension scripts. Default: the module's assets/extensions/.

### outputs

`[string]` The full path of the rendered extension folder.

### example 1

```powershell
New-VsCodeExtensionFolder -Extension $entry -OutputDirectory (Join-Path (Get-OutputRoot) 'vscode-extensions')
```

## The extension folder

Each extension is a module of the js track: `<folder>/extension.js`, with its own files in `<folder>/assets/`, shipped as `media/`. The
folder is the extension's name without the js track's namespace, so the name resolves to it
([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)); the installed folder keeps the name, the
extension's id.

## Lamp glyphs

A lamp is authored as its two green base glyphs, `<lamp>-on.svg` and `<lamp>-off.svg`. Every condition variant is rendered from them with
the lamp palette: the stroke takes the range's glyph shade, the condition adds its badge, and veto strikes the unlit glyph.

- A base glyph whose top-right corner is drawn on declares `data-badge="bottom"`; its badge then sits bottom-right.
- A base glyph that declares `data-empty="hidden"` is drawn fully transparent while its lamp claims nothing, keeping its place in the row.
- A repeat that names glyphs draws one label glyph per item, `<glyphs><key>-on/off.svg` with the item's title as its label, so the lamps it
  repeats need no hand-drawn icon; the pass that recolours the base glyphs per condition recolours them too.
