<#
.SYNOPSIS
    The link gate: fails on any off-form, dangling, or dead link or citation (ADR-REPO-LINK).
.DESCRIPTION
    Runs the same engine as Format-Links, read-only, and reports every violation: a code link not yet in canonical
    repository-rooted form, a markdown link that is rooted or climbs above the repository root, a rule citation
    spelled `ADR-X:n`, a link target or #fragment that does not exist, an unknown citation code or rule, an absolute
    URL into this repository outside .github/, and a docs path in a PowerShell string that names no file. A fixable
    violation is fixed by running Format-Links; the rest need a person. Informational findings (a comment line
    that stays over its limit) are listed but never fail the gate. A source-tree gate: it throws in build mode.
.PARAMETER Path
    Files or folders to check. Default: every git-tracked file.
.PARAMETER Kind
    Which link kinds to check: Code, Markdown, or Both (default).
.PARAMETER RepositoryRoot
    The repository root links resolve against. Default: the loaded repository root.
.PARAMETER PassThru
    Return a result object ({ ViolationCount, Violations, Information, FileCount }) instead of throwing.
.OUTPUTS
    Throws on any violation; with -PassThru, returns the result object.
.EXAMPLE
    Test-Links
.EXAMPLE
    (Test-Links -Kind Code -PassThru).Violations | Format-Table File, Line, Type, Message
#>
function Test-Links {
    [CmdletBinding()]
    param(
        [string[]] $Path,

        [Catzc.Base.QualityGates.LinkKind] $Kind = [Catzc.Base.QualityGates.LinkKind]::Both,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $PassThru
    )

    Assert-SourceTree

    $result = Invoke-LinkEngine -RepositoryRoot $RepositoryRoot -Path $Path -Kind $Kind -Wrap (Get-Config -Config links).wrap
    $violations = @($result.Findings | Where-Object { $_.IsViolation })
    $information = @($result.Findings | Where-Object { -not $_.IsViolation })

    if ($violations.Count -eq 0) {
        Write-Message "All links in $($result.FileCount) file(s) are aligned and resolve."
    }
    else {
        $fixable = @($violations | Where-Object { $_.IsFixable }).Count
        Write-Message "$($violations.Count) link violation(s) in $($result.FileCount) file(s): $fixable fixable by Format-Links, $($violations.Count - $fixable) need a person."
    }

    if ($PassThru) {
        return [pscustomobject]@{
            ViolationCount = $violations.Count
            Violations     = $violations
            Information    = $information
            FileCount      = $result.FileCount
        }
    }

    if ($violations.Count -gt 0) {
        $listing = ($violations | Select-Object -First 50 | ForEach-Object { "  $_" }) -join "`n"
        $more = if ($violations.Count -gt 50) {
            "`n  … and $($violations.Count - 50) more (use -PassThru for all)"
        }
        else {
            ''
        }
        throw "Test-Links failed: $($violations.Count) link violation(s) — run Format-Links, then fix what remains by hand:`n$listing$more"
    }
}
