<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
    kind: function
    module: Catzc.Base.VSCode
    visibility: public
    adrs:
      - ADR-REPO-FORMAT#8
      - ADR-REPO-ROOTCFG
---
#>

<#
.SYNOPSIS
    Renders .vscode/extensions.json content from the vscode-extensions registry — the recommended-extension
    list the editor offers on workspace open.
.DESCRIPTION
    Pure renderer: it returns the content and writes nothing, since Build-RootConfig owns the file write.
    [comment:1](/docs/references/automation/catzc-base-vscode/New-VSCodeExtensions.ps1.md#comment1)
.PARAMETER EngineExtension
    An id already in the authored list is skipped, so an engine extension never shows twice in the recommendations.
    [comment:2](/docs/references/automation/catzc-base-vscode/New-VSCodeExtensions.ps1.md#comment2)
.OUTPUTS
    [string] The rendered extensions.json content (LF-joined; the writer canonicalises).
.EXAMPLE
    New-VSCodeExtensions
#>
function New-VSCodeExtensions {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowEmptyCollection()]
        [string[]] $EngineExtension = @()
    )

    $config = Get-Config -Config vscode-extensions

    $recommendations = [System.Collections.Generic.List[string]]::new()
    foreach ($id in @($config.recommendations) + @($EngineExtension | Sort-Object)) {
        if (-not $recommendations.Contains($id)) {
            $recommendations.Add($id)
        }
    }
    $rendered = [ordered]@{
        recommendations = $recommendations.ToArray()
    }

    $header = @(
        '// GENERATED FILE — do not edit. Single source of truth:'
        '//   automation/Catzc.Base.VSCode/configs/vscode-extensions.yml (the authored recommendations + comments)'
        '//   automation/Catzc.Base.Languages/configs/languages.yml (the formatter engines'' extensions)'
        '// Regenerated on import by Build-RootConfig; edit the yml, not this file (VS Code reads the // header fine).'
    ) -join "`n"

    $header + "`n" + (ConvertTo-Json -InputObject $rendered -Depth 4) + "`n"
}
