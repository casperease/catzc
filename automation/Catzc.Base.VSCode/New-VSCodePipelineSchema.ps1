<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
    kind: writer-function
    language: powershell
    track: automation
    module: Catzc.Base.VSCode
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-vscode/New-VSCodePipelineSchema.ps1.md
      test: automation/Catzc.Base.VSCode/tests/New-VSCodePipelineSchema.Tests.ps1
    adrs:
      - ADR-REPO-ROOTCFG
  config:
    synopsis: |-
      Renders .vscode/azure-pipelines-schema.json content from the vscode-pipeline-schema registry — the
      repo-controlled JSON Schema the Azure Pipelines extension validates our pipeline YAML against.
    description: |-
      Reads the authored schema registry (configs/vscode-pipeline-schema.yml, via Get-Config -Config
      vscode-pipeline-schema — the validated VscodePipelineSchemaConfig, whose `document` is the authored
      JSON-Schema passthrough map) and renders it to the schema file content:
      strict JSON, no comment header. Unlike settings/extensions/launch.json (which VS Code reads as JSONC),
      this file is consumed by the extension's schema validator as strict JSON, so the generated-file head cannot
      be a leading '//' block — Build-RootConfig writes it into a JSON-Schema '$comment' key the validator ignores.

      The point of the schema is to REPLACE the extension's bundled one so its per-task `task` anyOf — the
      source of the "String does not match the pattern of ^PowerShell@2$" false positives we get when not
      connected to an Azure DevOps org — is gone, while the structural checks worth keeping remain. The
      authored yml carries the full rationale; this is a pure renderer that returns the content and writes
      nothing. It is the `generator` the root-config registry names for the .vscode/azure-pipelines-schema.json
      target, and Build-RootConfig owns the write. See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
    outputs: '[string] The rendered azure-pipelines-schema.json content (LF-joined; the writer canonicalises).'
    examples:
      - New-VSCodePipelineSchema
---
#>

function New-VSCodePipelineSchema {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $document = (Get-Config -Config vscode-pipeline-schema).document

    $rendered = [ordered]@{}
    $rendered['$schema'] = $document['$schema']
    foreach ($key in $document.Keys) {
        if ($key -eq '$schema') {
            continue
        }
        $rendered[$key] = $document[$key]
    }

    (ConvertTo-Json -InputObject $rendered -Depth 20) + "`n"
}
