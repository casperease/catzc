# pwsh/Catzc.Base.VSCode/New-VsCodeExtensions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders .vscode/extensions.json content from the vscode-extensions registry — the recommended-extension list the editor offers on workspace
open.

### description

Reads the authored recommendation registry (configs/vscode-extensions.yml, via Get-Config -Config vscode-extensions, which maps and
validates it as a VscodeExtensionsConfig) and renders it to the extensions.json content: the recommendations as JSON, in registry order,
without a head (Build-RootConfig writes the generated-file head as a JSONC comment head, which VS Code reads in extensions.json). The
per-extension explanations live as comments in the yml — the authored, searched artifact — not in the rendering.

This is a pure renderer: it returns the content and writes nothing — it is the `generator` the root-config registry names for the
.vscode/extensions.json target, and Build-RootConfig owns the write. See
[ADR-REPO-ROOTCFG](../../../adr/repository/generated-root-configs.md).

### parameter `EngineExtension`

The extensions that run the repository's formatter engines in the editor, appended after the authored recommendations when not already
listed. Supplied by the generator dispatch from the file-language registry, so an engine's extension is recommended wherever a language uses
it ([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../adr/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)).

### outputs

`[string]` The rendered extensions.json content (LF-joined; the writer canonicalises).

### example 1

```powershell
New-VsCodeExtensions
```
