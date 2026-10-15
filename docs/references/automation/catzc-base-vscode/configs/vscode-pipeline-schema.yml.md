---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/configs/vscode-pipeline-schema.yml.md
    kind: comment-page
    body_sha: "2fbd56815ffc"
    adrs: []
---

# automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$schema: http://json-schema.org/draft-07/schema#`.

```text
Azure Pipelines schema — the authored SOURCE OF TRUTH for .vscode/azure-pipelines-schema.json, the schema
the ms-azure-devops.azure-pipelines extension validates our pipeline YAML against. It is wired in via
`azure-pipelines.customSchemaFile` (vscode-settings.yml) and rendered to strict JSON by
New-VSCodePipelineSchema (through Build-RootConfig; see rootconfig.yml and
[ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)). Edit THIS file, never the rendered .json.

WHY a repo-controlled schema instead of the extension's bundled one — the false positives we are killing:
  The bundled schema models a step's `task` as a giant anyOf, one branch per known task
  (^PowerShell@2$, ^AzureCLI@2$, ^UseNode@1$, …), each branch pinning that task's exact `inputs`. When the
  extension cannot reach an Azure DevOps org to resolve the real task set — which is always, because we
  author offline and are not connected directly — it cannot pick the matching branch and instead surfaces
  EVERY branch's failure. That is why a file using only UseNode@1/UseDotNet@2 still warns
  "String does not match the pattern of ^PowerShell@2$": the message is a sibling branch that did not
  match, not a real problem with the file. The extension exposes no severity/ignore knob, only this
  customSchemaFile override.

WHAT this overrides: `task` collapses to one loose pattern and `inputs` becomes a free-form object, so the
  anyOf that produces the noise does not exist here. We keep the STRUCTURAL checks that are still worth
  having — the top-level shape, that `steps`/`jobs`/`stages` are the right container types, and key typos
  like `tasks:` vs `task:` — and leave everything else open (an empty schema `{}` and the default
  additionalProperties: true accept anything), so this schema never invents a NEW false positive. It is a
  deliberately permissive compliance net, not a re-implementation of the full Azure Pipelines schema.

Loaded via Get-Config -Config vscode-pipeline-schema as Catzc.Base.VSCode.VscodePipelineSchemaConfig: the
JSON-Schema keywords stay a free-form, ordered passthrough map; the type turns the rationale above into checks
(the root is an open `type: object`, nothing sets `additionalProperties: false`, the `step` definition has no
anyOf/oneOf, every `#/definitions/` $ref resolves).
```

## comment:2

Above `properties:`.

```text
Top level is a full pipeline OR any template fragment (parameters/steps/jobs/stages/variables only), so the
root stays open (additionalProperties defaults to true) and every known key is permissive. `{}` is the
empty schema — it accepts any value — used wherever a key is polymorphic (string | array | object).
```

## comment:3

Above `type: object`.

```text
One loose object shape for every step kind — no oneOf/anyOf across task variants, because that branch
fan-out is exactly the false-positive source. It covers task/script/checkout/download/template steps, the
Azure Pipelines shortcut steps (pwsh, powershell, bash) and conditional insertions (${{ if … }}: [ … ]) alike; additionalProperties
defaults to true, so any key not listed here is accepted rather than flagged.
```
