---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/types/VscodePipelineSchemaConfig.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "5bebda20fd3b"
---

# automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The Azure Pipelines schema registry, configs/vscode-pipeline-schema.yml — the authored source that
New-VSCodePipelineSchema renders to the managed .vscode/azure-pipelines-schema.json, the schema the Azure Pipelines
extension validates pipeline YAML against ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
The file IS a JSON-Schema document ('$schema', camelCase keywords), data passed through to the extension as-is, so
the type keeps it as an ordered passthrough map (`document`) rather than typing each keyword. Constructing an
instance MAPS and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.VSCode.VscodePipelineSchemaConfig), so
Get-Config -Config vscode-pipeline-schema returns this typed model.

Load-time rules — the file's own rationale, as checks:
  - only the top-level keywords '$schema', 'title', 'type', 'properties', and 'definitions' ('$comment' is the
    renderer's provenance marker, never authored);
  - '$schema' is a non-empty string; 'type' is 'object' (a full pipeline or any template fragment);
  - 'properties' and 'definitions' are maps;
  - every '#/definitions/<name>' $ref resolves to a definition;
  - nothing sets 'additionalProperties: false' — the schema stays open, so it never invents a new false positive;
  - the 'step' definition carries no 'anyOf' / 'oneOf' — that per-task branch fan-out is the false-positive source
    the schema exists to remove.
```
