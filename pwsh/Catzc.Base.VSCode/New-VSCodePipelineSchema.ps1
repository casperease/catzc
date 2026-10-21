<#
---
catzc:
  immutable:
    with_body_sha: "3edcf742f29f"
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/New-VSCodePipelineSchema.Tests.ps1
    docs: "[New-VSCodePipelineSchema.ps1.md](docs/references/pwsh/catzc-base-vscode/New-VSCodePipelineSchema.ps1.md)"
    cites:
      - ADR-REPO-ROOTCFG
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
