<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-vs-code/New-VSCodeLaunch.ps1.md"
  warning: "Generated Header"
---
#>

function New-VsCodeLaunch {
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
