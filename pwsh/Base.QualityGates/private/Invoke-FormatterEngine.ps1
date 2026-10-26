<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Invoke-FormatterEngine.ps1.md"
  header: "generated"
---
#>

function Invoke-FormatterEngine {
    [CmdletBinding()]
    [OutputType([string[]], [pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Engine,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [switch] $DryRun
    )

    $adapter = Get-FormatEngineAdapter -Engine $Engine
    & $adapter -File $File -DryRun:$DryRun
}
