---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/New-VSCodePipelineSchema.ps1.md
    kind: reference
    body_sha: def83c7df179
    adrs: []
---

# automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the authored schema registry (configs/vscode-pipeline-schema.yml, via Get-Config -Config
vscode-pipeline-schema — the validated VscodePipelineSchemaConfig, whose `document` is the authored
JSON-Schema passthrough map) and renders it to the schema file content:
strict JSON, no comment header. Unlike settings/extensions/launch.json (which VS Code reads as JSONC),
this file is consumed by the extension's schema validator as strict JSON, so the provenance marker cannot
be a leading '//' block — it travels as a JSON-Schema '$comment' key the validator ignores.

The point of the schema is to REPLACE the extension's bundled one so its per-task `task` anyOf — the
source of the "String does not match the pattern of ^PowerShell@2$" false positives we get when not
connected to an Azure DevOps org — is gone, while the structural checks worth keeping remain. The
authored yml carries the full rationale; this is a pure renderer that returns the content and writes
nothing. It is the `generator` the root-config registry names for the .vscode/azure-pipelines-schema.json
target, and Build-RootConfig owns the write. See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```

## comment:2

Above `$rendered = [ordered]@{}`.

```text
Front the schema with its meta-schema declaration, then a '$comment' provenance marker (JSON has no
comment syntax and the validator parses this file strictly), then the authored body in registry order.
```
