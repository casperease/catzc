# pwsh/Catzc.Base.VSCode/private/New-VsCodeExtensionFolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$rendered = Join-Path $folder 'media'`, written with `#`.

```text
A lamp is authored as its two green base glyphs, <lamp>-on.svg and <lamp>-off.svg; every condition variant is rendered from them
with the lamp palette: the stroke takes the range's glyph shade, the condition adds its badge, and veto strikes the unlit glyph.
```

## comment:2

Above `$repeats = if ($Extension.contributes.Contains('repeat')) {`, written with `#`.

```text
A repeat source that names glyphs draws one label glyph per item, <glyphs><key>-on/off.svg with the item's title as its label, so
the lamps it repeats need no hand-drawn icon; the pass below recolours them per condition like every other base glyph.
```
