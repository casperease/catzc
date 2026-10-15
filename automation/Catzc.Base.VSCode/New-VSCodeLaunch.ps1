<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
    kind: function
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
    [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)
    [comment:1](/docs/references/automation/catzc-base-vscode/New-VSCodeLaunch.ps1.md#comment1)
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

    $header = @(
        '// GENERATED FILE — do not edit. Single source of truth:'
        '//   automation/Catzc.Base.VSCode/configs/vscode-launch.yml (the authored launch profiles + comments)'
        '// Regenerated on import by Build-RootConfig; edit the yml, not this file (VS Code reads the // header fine).'
    ) -join "`n"

    $header + "`n" + (ConvertTo-Json -InputObject $rendered -Depth 8) + "`n"
}
