<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Save-FileMetaResult.ps1
    folder: private
    name: save-file-meta-result
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Save-FileMetaResult.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#3
  config:
    synopsis: Writes the files an engine run found drifted, and names the findings no tool can repair.
    description: The one writer behind Format-FileMeta and the file-meta imprint step, so the two cannot disagree. Files are UTF-8 without a BOM.
    parameters:
      Result: What Invoke-FileMetaEngine returned.
      RepositoryRoot: The repository root the result's paths are relative to.
      DryRun: Report what would change without writing any file.
    outputs: '[pscustomobject] @{ Fixed; Unowned } — Fixed holds the engine''s file entries that changed, Unowned the findings left for a person.'
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
        Unowned = @($Result.Files | ForEach-Object { $_.Findings } | Where-Object Kind -In 'Unowned', 'UnownedHead')
    }
}
