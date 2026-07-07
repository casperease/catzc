<#
.SYNOPSIS
    Renders .vscode/azure-pipelines-schema.json content from the vscode-pipeline-schema registry — the
    repo-controlled JSON Schema the Azure Pipelines extension validates our pipeline YAML against.
.DESCRIPTION
    Reads the authored schema registry (configs/vscode-pipeline-schema.yml, via Get-Config -Config
    vscode-pipeline-schema — raw, free-form JSON-Schema keys) and renders it to the schema file content:
    strict JSON, no comment header. Unlike settings/extensions/launch.json (which VS Code reads as JSONC),
    this file is consumed by the extension's schema validator as strict JSON, so the provenance marker cannot
    be a leading '//' block — it travels as a JSON-Schema '$comment' key the validator ignores.

    The point of the schema is to REPLACE the extension's bundled one so its per-task `task` anyOf — the
    source of the "String does not match the pattern of ^PowerShell@2$" false positives we get when not
    connected to an Azure DevOps org — is gone, while the structural checks worth keeping remain. The
    authored yml carries the full rationale; this is a pure renderer that returns the content and writes
    nothing. It is the `generator` the root-config registry names for the .vscode/azure-pipelines-schema.json
    target, and Build-RootConfig owns the write. See docs/adr/repository/generated-root-configs.md.
.OUTPUTS
    [string] The rendered azure-pipelines-schema.json content (LF-joined; the writer canonicalises).
.EXAMPLE
    New-VSCodePipelineSchema
#>
function New-VSCodePipelineSchema {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $config = Get-Config -Config vscode-pipeline-schema

    # Front the schema with its meta-schema declaration, then a '$comment' provenance marker (JSON has no
    # comment syntax and the validator parses this file strictly), then the authored body in registry order.
    $rendered = [ordered]@{}
    if ($config.Contains('$schema')) {
        $rendered['$schema'] = $config['$schema']
    }
    $rendered['$comment'] = 'GENERATED FILE — do not edit. Source of truth: ' +
    'automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml (authored schema + rationale). ' +
    'Regenerated on import by Build-RootConfig; edit the yml, not this file.'
    foreach ($key in $config.Keys) {
        if ($key -eq '$schema') {
            continue
        }
        $rendered[$key] = $config[$key]
    }

    (ConvertTo-Json -InputObject $rendered -Depth 20) + "`n"
}
