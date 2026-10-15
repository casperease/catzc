<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Format-Comments.ps1
    kind: format-function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-COMMENTS#1
      - ADR-REPO-COMMENTS#5
  config:
    synopsis: Puts every comment residue of the repository's code and config files into its one-liner shape, in place.
    description: |-
      A file keeps one residue per long comment — an insight line, then a line with the comment's ADR citations and the
      docs link `[comment:N](/<page>#commentN)` — and the prose lives once, in the file's comment page
      ([ADR-REPO-COMMENTS#1](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments1),
      [ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). This is the shape
      check of the residue ([ADR-REPO-COMMENTS#5](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments5)):
      one insight line within the file's line limit (.editorconfig max_line_length, with links.yml overrides), with no
      link or citation in it, that does not start with one of comments.yml's obvious phrases
      ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).

      What is mechanical is fixed: a residue without an insight line gets the first sentence of its own section as a
      provisional one, a link in the insight goes and a citation moves to the docs-link line, and an overlong insight
      is cut at a word to its first sentence. What needs a person is left as written and listed as unfixable: an
      obvious insight, words on the docs-link line, a residue whose page holds no section, and a comment that still
      outgrows a line (run Export-Comments). Test-Comments reports them. Aligning the link itself stays Format-Links'.
      The formatter is compiled C# (Catzc.Base.QualityGates.CommentFormatter) over the comment engine's public surface;
      files are written as UTF-8 without a BOM, each line keeping its own ending. A source-tree tool: it throws in
      build mode (Assert-SourceTree).
    parameters:
      Path: 'Files or folders to format. Default: every file in scope (Get-CommentScope).'
      RepositoryRoot: 'The repository root paths and pages resolve against. Default: the loaded repository root.'
      DryRun: Report what would change without writing any file.
      PassThru: |-
        Return a result object ({ ChangedCount, ChangedFiles, Fixed, Unfixable, DryRun, ElapsedMs }) instead of only the
        changed paths.
    outputs: '[string[]] the repository-relative paths changed (or, under -DryRun, that would change); with -PassThru, the result object.'
    examples:
      - Format-Comments
      - Format-Comments -DryRun -PassThru
      - Format-Comments -Path automation/Catzc.Base.Files
---
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
