<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
    kind: function
    module: Catzc.Base.VSCode
    visibility: public
    adrs:
      - ADR-REPO-ROOTCFG
---
#>

<#
.SYNOPSIS
    Renders .vscode/azure-pipelines-schema.json content from the vscode-pipeline-schema registry — the
    repo-controlled JSON Schema the Azure Pipelines extension validates our pipeline YAML against.
.DESCRIPTION
    Strict JSON with no comment header: the schema validator rejects a leading // block, unlike settings.json.
    [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)
    [comment:1](/docs/references/automation/catzc-base-vscode/New-VSCodePipelineSchema.ps1.md#comment1)
.OUTPUTS
    [string] The rendered azure-pipelines-schema.json content (LF-joined; the writer canonicalises).
.EXAMPLE
    New-VSCodePipelineSchema
#>
function New-VSCodePipelineSchema {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $document = (Get-Config -Config vscode-pipeline-schema).document

    # Strict JSON has no comment syntax, so the provenance marker rides in a '$comment' key the validator ignores.
    # [comment:2](/docs/references/automation/catzc-base-vscode/New-VSCodePipelineSchema.ps1.md#comment2)
    $rendered = [ordered]@{}
    $rendered['$schema'] = $document['$schema']
    $rendered['$comment'] = 'GENERATED FILE — do not edit. Source of truth: ' +
    'automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml (authored schema + rationale). ' +
    'Regenerated on import by Build-RootConfig; edit the yml, not this file.'
    foreach ($key in $document.Keys) {
        if ($key -eq '$schema') {
            continue
        }
        $rendered[$key] = $document[$key]
    }

    (ConvertTo-Json -InputObject $rendered -Depth 20) + "`n"
}
