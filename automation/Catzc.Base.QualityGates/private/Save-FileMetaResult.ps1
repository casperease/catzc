# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Save-FileMetaResult.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Writes the files an engine run found drifted, and names the findings no tool can repair.
.DESCRIPTION
    The one writer behind Format-FileMeta and the file-meta imprint step, so the two cannot disagree.
    [ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Save-FileMetaResult.ps1.md#comment1)
.PARAMETER Result
    What Invoke-FileMetaEngine returned.
.PARAMETER RepositoryRoot
    The repository root the result's paths are relative to.
.PARAMETER DryRun
    Report what would change without writing any file.
.OUTPUTS
    [pscustomobject] @{ Fixed; Unowned } — Fixed holds the engine's file entries that changed, Unowned the findings left for a person.
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
        Unowned = @($Result.Files | ForEach-Object { $_.Findings } | Where-Object Kind -In 'Unowned', 'UnownedHead')
    }
}
