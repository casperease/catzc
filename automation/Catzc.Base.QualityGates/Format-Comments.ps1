<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Format-Comments.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-COMMENTS#1
      - ADR-REPO-COMMENTS#5
---
#>

<#
.SYNOPSIS
    Puts every comment residue of the repository's code and config files into its one-liner shape, in place.
.DESCRIPTION
    Fixes only the mechanical cases; an obvious insight or a residue without a page section is listed unfixable.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Format-Comments.ps1.md#comment1)
.PARAMETER Path
    Files or folders to format. Default: every file in scope (Get-CommentScope).
.PARAMETER RepositoryRoot
    The repository root paths and pages resolve against. Default: the loaded repository root.
.PARAMETER DryRun
    Report what would change without writing any file.
.PARAMETER PassThru
    Read Unfixable here: the changed paths alone hide the residues that still need a person.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Format-Comments.ps1.md#comment2)
.OUTPUTS
    [string[]] the repository-relative paths changed (or, under -DryRun, that would change); with -PassThru, the result object.
.EXAMPLE
    Format-Comments
.EXAMPLE
    Format-Comments -DryRun -PassThru
.EXAMPLE
    Format-Comments -Path automation/Catzc.Base.Files
#>
function Format-Comments {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-SourceTree

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $config = Get-Config -Config comments
    $links = Get-Config -Config links
    $limits = Get-LinkLineLimit -RepositoryRoot $RepositoryRoot -Override $links.line_limit
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)

    $findings = [System.Collections.Generic.List[Catzc.Base.QualityGates.CommentFinding]]::new()
    $changedFiles = [System.Collections.Generic.List[string]]::new()
    $scope = @(Get-CommentScope -RepositoryRoot $RepositoryRoot -Path $Path)
    foreach ($entry in $scope) {
        $filePath = Join-Path $RepositoryRoot $entry.File
        $pagePath = Join-Path $RepositoryRoot $entry.Page
        $pageText = $null
        if (Test-Path -LiteralPath $pagePath -PathType Leaf) {
            $pageText = [System.IO.File]::ReadAllText($pagePath)
        }
        $limit = $links.default_line_limit
        if ($limits.ContainsKey($entry.Extension)) {
            $limit = $limits[$entry.Extension]
        }
        $text = [System.IO.File]::ReadAllText($filePath)
        $result = [Catzc.Base.QualityGates.CommentFormatter]::Format($text, $entry.Extension, $entry.Language, $entry.File, $pageText, $config, $limit)
        $findings.AddRange($result.Findings)
        if (-not $result.Changed) {
            continue
        }
        $changedFiles.Add($entry.File)
        if (-not $DryRun) {
            [System.IO.File]::WriteAllText($filePath, $result.Text, $utf8NoBom)
        }
    }
    $stopwatch.Stop()

    $fixed = @($findings | Where-Object { $_.IsFixable })
    $unfixable = @($findings | Where-Object { -not $_.IsFixable })
    $verb = if ($DryRun) {
        'would fix'
    }
    else {
        'fixed'
    }
    $elapsed = "$($stopwatch.ElapsedMilliseconds) ms"
    $needPerson = "$($unfixable.Count) need a person (run Test-Comments to list them)"
    if ($fixed.Count -eq 0 -and $unfixable.Count -eq 0) {
        Write-Message "Comments: all residues of $($scope.Count) file(s) already in shape ($elapsed)."
    }
    elseif ($fixed.Count -eq 0) {
        Write-Message "Comments: nothing to fix in $($scope.Count) file(s) ($elapsed); $needPerson."
    }
    elseif ($unfixable.Count -eq 0) {
        Write-Message "Comments: $verb $($fixed.Count) residue(s) in $($changedFiles.Count) of $($scope.Count) file(s) ($elapsed)."
    }
    else {
        Write-Message "Comments: $verb $($fixed.Count) residue(s) in $($changedFiles.Count) of $($scope.Count) file(s) ($elapsed); $needPerson."
    }

    if ($PassThru) {
        return [pscustomobject]@{
            ChangedCount = $changedFiles.Count
            ChangedFiles = [string[]] $changedFiles.ToArray()
            Fixed        = $fixed
            Unfixable    = $unfixable
            DryRun       = [bool] $DryRun
            ElapsedMs    = $stopwatch.ElapsedMilliseconds
        }
    }
    [string[]] $changedFiles.ToArray()
}
