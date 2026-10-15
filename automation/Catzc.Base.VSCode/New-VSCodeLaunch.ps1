<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
    kind: writer-function
    module: Catzc.Base.VSCode
    visibility: public
    adrs:
      - ADR-REPO-ROOTCFG
---
#>

<#
.SYNOPSIS
    Renders .vscode/launch.json content from the vscode-launch registry — the debug launch profiles the
    editor offers.
.DESCRIPTION
    Pure renderer: it returns the content and writes nothing, since Build-RootConfig owns the file write.
.OUTPUTS
    [string] The rendered launch.json content (LF-joined; the writer canonicalises).
.EXAMPLE
    New-VSCodeLaunch
#>
function New-VSCodeLaunch {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $config = Get-Config -Config vscode-launch

    $rendered = [ordered]@{
        version        = $config.version
        configurations = @($config.configurations | ForEach-Object { $_.fields })
    }

    (ConvertTo-Json -InputObject $rendered -Depth 8) + "`n"
}
