<#
.SYNOPSIS
    Aligns the repository's links in place: code links repository-rooted, markdown links relative
    ([ADR-REPO-LINK](/docs/adr/repository/markdown-links.md)).
.DESCRIPTION
    The link aligner and the repository-wide migration in one command
    ([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)). Every ADR reference in a
    comment of a code file becomes a canonical code link — `[ADR-<CODE>#<n>](/docs/adr/<path>.md#rule-adr-<code><n>)`,
    or `[ADR-<CODE>](/docs/adr/<path>.md)` for a whole ADR — whatever spelling it had: a bare, ../, or rooted docs/adr
    path, an ADR file name, a bare citation (`ADR-X`, `ADR-X:n`, `ADR-X#n`), a path followed by its citation, or a
    link in another shape. The citation code is the source of truth, so a path to a moved ADR is re-pointed. In
    markdown files a repository-rooted link becomes relative to its file, and a prose rule citation `ADR-X:n` becomes
    `ADR-X#n`.

    A comment line that outgrows its line limit (.editorconfig max_line_length, with links.yml overrides) is wrapped
    per -Wrap: broken before the link, never inside it, continuing with the same comment prefix and indent.

    What cannot be fixed mechanically — a dangling path, an unknown citation code or rule, a bad anchor — is left as
    written and listed as unfixable; Test-Links reports it. The engine is compiled C# (Catzc.Base.QualityGates.LinkEngine)
    and runs files in parallel, so a whole-repository run is fast. Files are written as UTF-8 without a BOM, with
    their own line endings kept. A source-tree tool: it throws in build mode (Assert-SourceTree).
.PARAMETER Path
    Files or folders to align. Default: every git-tracked file.
.PARAMETER Kind
    Which link kinds to align: Code, Markdown, or Both (default).
.PARAMETER Wrap
    How an aligned comment line that outgrows its limit is wrapped: Break or Off. Default: links.yml's wrap.
.PARAMETER RepositoryRoot
    The repository root links resolve against. Default: the loaded repository root.
.PARAMETER DryRun
    Report what would change without writing any file.
.PARAMETER PassThru
    Return a result object ({ ChangedCount, ChangedFiles, Fixed, Unfixable, DryRun, ElapsedMs }) instead of only the
    changed paths.
.OUTPUTS
    [string[]] the repository-relative paths changed (or, under -DryRun, that would change); with -PassThru, the result object.
.EXAMPLE
    Format-Links
.EXAMPLE
    Format-Links -DryRun -PassThru
.EXAMPLE
    Format-Links -Path automation/Catzc.Base.Docs -Kind Code
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
