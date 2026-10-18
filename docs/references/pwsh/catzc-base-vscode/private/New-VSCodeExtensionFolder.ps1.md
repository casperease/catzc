# pwsh/Catzc.Base.VSCode/private/New-VSCodeExtensionFolder.ps1

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
[ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency).

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
New-VSCodeExtensionFolder -Extension $entry -OutputDirectory (Join-Path (Get-OutputRoot) 'vscode-extensions')
```
