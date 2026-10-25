<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-vs-code/New-VSCodePipelineSchema.ps1.md"
  warning: "Generated Header"
---
#>

function New-VsCodePipelineSchema {
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
