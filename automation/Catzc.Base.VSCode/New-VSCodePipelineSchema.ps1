<#
.SYNOPSIS
    Renders .vscode/azure-pipelines-schema.json content from the vscode-pipeline-schema registry — the
    repo-controlled JSON Schema the Azure Pipelines extension validates our pipeline YAML against.
.DESCRIPTION
    Reads the authored schema registry (configs/vscode-pipeline-schema.yml, via Get-Config -Config...
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

    # Front the schema with its meta-schema declaration, then a '$comment' provenance marker (JSON has no comment...
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
