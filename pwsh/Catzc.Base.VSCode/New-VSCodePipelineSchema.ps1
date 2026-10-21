<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/New-VsCodePipelineSchema.ps1
    name: new-vs-code-pipeline-schema
    filetype: ps1
    role: function
    subkind: writer
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/New-VsCodePipelineSchema.Tests.ps1
    docs: "[New-VsCodePipelineSchema.ps1.md](docs/references/pwsh/catzc-base-vscode/New-VsCodePipelineSchema.ps1.md)"
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
