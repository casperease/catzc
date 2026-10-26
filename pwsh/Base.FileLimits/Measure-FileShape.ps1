<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-file-limits/Measure-FileShape.ps1.md"
  header: "generated"
---
#>

function Measure-FileShape {
    [CmdletBinding()]
    [OutputType([Catzc.Base.FileLimits.FileShape])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string[]] $Path
    )

    process {
        foreach ($file in $Path) {
            [Catzc.Base.FileLimits.FileShape]::Measure((Resolve-Path -LiteralPath $file).ProviderPath)
        }
    }
}
