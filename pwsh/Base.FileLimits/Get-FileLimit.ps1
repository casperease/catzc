<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-file-limits/Get-FileLimit.ps1.md"
  header: "generated"
---
#>

function Get-FileLimit {
    [CmdletBinding()]
    [OutputType([Catzc.Base.FileLimits.ResolvedFileLimit])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string[]] $Path
    )

    begin {
        $config = Get-Config -Config file-limits
    }

    process {
        foreach ($file in $Path) {
            $language = Get-FileLanguage -Path $file
            $config.ResolveFile($file, ($null -eq $language ? $null : $language.name))
        }
    }
}
