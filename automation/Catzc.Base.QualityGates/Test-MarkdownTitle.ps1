<#
.SYNOPSIS
    The Markdown title and heading gate: fails on any in-scope file whose title is not its repository path or whose
    headings are not in normal form
    ([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6),
    [ADR-REPO-FORMAT#7](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format7)).
.DESCRIPTION
    Runs the same check as Format-MarkdownTitle, read-only, and reports every file whose first line after any YAML
    front matter is not the H1 `# <repository-relative path>`, every heading with a trailing reference group, every
    unquoted dora-explains paragraph, every link to an anchor that moves, and every duplicate anchor. Running
    Format-MarkdownTitle fixes all of them except a Duplicate, which the author rewords. A source-tree gate: it throws
    in build mode.
.PARAMETER Path
    Files or folders to check. Default: every in-scope file.
.PARAMETER RepositoryRoot
    The repository root titles are relative to. Default: the loaded repository root.
.PARAMETER PassThru
    Return a result object ({ ViolationCount; Violations; FileCount }) instead of throwing.
.OUTPUTS
    Throws on any violation; with -PassThru, returns the result object.
.EXAMPLE
    Test-MarkdownTitle
.EXAMPLE
    (Test-MarkdownTitle -PassThru).Violations | Format-Table Path, Line, Actual
#>
function Test-MarkdownTitle {
    [CmdletBinding()]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $PassThru
    )

    Assert-SourceTree

    $result = Invoke-MarkdownTitleEngine -RepositoryRoot $RepositoryRoot -Path $Path
    $violations = @($result.Files | ForEach-Object { $_.Findings } | ForEach-Object {
            [pscustomobject]@{
                Path    = $_.Path
                Line    = $_.Line
                Kind    = $_.Kind
                Actual  = $_.Actual
                Message = "$($_.Path):$($_.Line) [$($_.Kind)] expected '$($_.Expected)', found '$($_.Actual)'"
            }
        })

    if ($violations.Count -eq 0) {
        Write-Message "All $($result.FileCount) Markdown file(s) are titled with their path and their headings are in normal form."
    }
    else {
        Write-Message "$($violations.Count) title or heading finding(s) in $($result.FileCount) Markdown file(s) — run Format-MarkdownTitle; reword a Duplicate by hand."
    }

    if ($PassThru) {
        return [pscustomobject]@{
            ViolationCount = $violations.Count
            Violations     = $violations
            FileCount      = $result.FileCount
        }
    }
    if ($violations.Count -gt 0) {
        $listing = ($violations | Select-Object -First 50 | ForEach-Object { "  $($_.Message)" }) -join "`n"
        $more = if ($violations.Count -gt 50) {
            "`n  … and $($violations.Count - 50) more (use -PassThru for all)"
        }
        else {
            ''
        }
        throw "Test-MarkdownTitle failed: $($violations.Count) title or heading finding(s) — run Format-MarkdownTitle (reword a Duplicate by hand):`n$listing$more"
    }
}
