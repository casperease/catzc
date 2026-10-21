<#
---
catzc:
  immutable:
    with_body_sha: ca30d1a5ce8c
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1
    docs: "[Format-Links.ps1.md](docs/references/pwsh/catzc-base-quality-gates/Format-Links.ps1.md)"
    cites:
      - ADR-REPO-LINK-ALIGNEDBYTOOL
---
#>

function Format-Links {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [Catzc.Base.QualityGates.LinkKind] $Kind = [Catzc.Base.QualityGates.LinkKind]::Both,

        [Catzc.Base.QualityGates.LinkWrap] $Wrap = (Get-Config -Config links).wrap,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-SourceTree

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $result = Invoke-LinkEngine -RepositoryRoot $RepositoryRoot -Path $Path -Kind $Kind -Wrap $Wrap

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    $changedFiles = [string[]] @($result.Changed.Keys | Sort-Object)
    if (-not $DryRun) {
        foreach ($file in $changedFiles) {
            [System.IO.File]::WriteAllText((Join-Path $RepositoryRoot $file), $result.Changed[$file], $utf8NoBom)
        }
    }
    $stopwatch.Stop()

    $fixed = @($result.Findings | Where-Object { $_.IsFixable })
    $unfixable = @($result.Findings | Where-Object { -not $_.IsFixable -and $_.IsViolation })
    $verb = if ($DryRun) {
        'would align'
    }
    else {
        'aligned'
    }
    $elapsed = "$($stopwatch.ElapsedMilliseconds) ms"
    $needPerson = "$($unfixable.Count) need a person (run Test-Links to list them)"
    if ($fixed.Count -eq 0 -and $unfixable.Count -eq 0) {
        Write-Message "Links: all $($result.FileCount) file(s) already aligned ($elapsed)."
    }
    elseif ($fixed.Count -eq 0) {
        Write-Message "Links: nothing to align in $($result.FileCount) file(s) ($elapsed); $needPerson."
    }
    elseif ($unfixable.Count -eq 0) {
        Write-Message "Links: $verb $($fixed.Count) link(s) in $($changedFiles.Count) of $($result.FileCount) file(s) ($elapsed)."
    }
    else {
        Write-Message "Links: $verb $($fixed.Count) link(s) in $($changedFiles.Count) of $($result.FileCount) file(s) ($elapsed); $needPerson."
    }

    if ($PassThru) {
        return [pscustomobject]@{
            ChangedCount = $changedFiles.Count
            ChangedFiles = $changedFiles
            Fixed        = $fixed
            Unfixable    = $unfixable
            DryRun       = [bool] $DryRun
            ElapsedMs    = $stopwatch.ElapsedMilliseconds
        }
    }
    $changedFiles
}
