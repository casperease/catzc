<#
.SYNOPSIS
    The repo-relative paths changed across a git diff range — the diff counterpart to the tracked-file
    universe.
.DESCRIPTION
    The diff sibling of Get-TrackedFile: `git diff --name-only` over the range, with renames split into a delete + an...
    [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)
    [comment:1](/docs/references/automation/catzc-base-globs/private/Get-ChangedFile.ps1.md#comment1)
.PARAMETER Range
    The git diff range: a merge-base range 'origin/main...HEAD' (a PR's net change since it diverged) or a commit...
    [comment:2](/docs/references/automation/catzc-base-globs/private/Get-ChangedFile.ps1.md#comment2)
.EXAMPLE
    Get-ChangedFile -Range 'HEAD^1..HEAD'
#>
function Get-ChangedFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Range
    )

    $ret = Invoke-Executable "git -c core.quotepath=off diff --name-only --no-renames $Range" -PassThru -Silent
    $ret.Output -split "`r?`n" | Where-Object { $_ -ne '' }
}
