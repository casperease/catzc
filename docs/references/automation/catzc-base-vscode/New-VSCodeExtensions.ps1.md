---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/New-VSCodeExtensions.ps1.md
    kind: comment-page
    body_sha: b19448500c10
    adrs:
      - ADR-REPO-FORMAT#8
---

# automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the authored recommendation registry (configs/vscode-extensions.yml, via Get-Config -Config
vscode-extensions, which maps and validates it as a VscodeExtensionsConfig) and renders it to the extensions.json content: the
recommendations as JSON, in registry order, without a head (Build-RootConfig writes the generated-file head as a JSONC comment
head, which VS Code reads in extensions.json). The per-extension explanations live as comments in the yml — the authored,
searched artifact — not in the rendering.

This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
root-config registry names for the .vscode/extensions.json target, and Build-RootConfig owns the write.
See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```

## comment:2

Section `.PARAMETER EngineExtension` of the comment-based help.

```text
The extensions that run the repository's formatter engines in the editor, appended after the authored
recommendations when not already listed. Supplied by the generator dispatch from the file-language registry, so
an engine's extension is recommended wherever a language uses it
([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)).
```
