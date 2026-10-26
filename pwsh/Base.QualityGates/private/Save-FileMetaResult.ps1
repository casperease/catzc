<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Save-FileMetaResult.ps1.md"
  header: "generated"
---
#>

function Save-FileMetaResult {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Result,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [switch] $DryRun
    )

    $fixed = @($Result.Files | Where-Object { @($_.Findings | Where-Object Kind -EQ 'Drift').Count -gt 0 })
    if (-not $DryRun) {
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        foreach ($file in $fixed) {
            [System.IO.File]::WriteAllText((Join-Path $RepositoryRoot $file.Path), $file.Fixed, $utf8NoBom)
        }
    }
    [pscustomobject]@{
        Fixed   = $fixed
        Unowned = @($Result.Files | ForEach-Object { $_.Findings } |
                Where-Object Kind -In 'Unowned', 'UnownedHead', 'ForbiddenConfig')
    }
}
