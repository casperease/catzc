<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
    kind: private-function
    module: Catzc.Base.Globs
    visibility: private
    adrs:
      - ADR-FLOW-CD-GLOBS#4
---
#>

<#
.SYNOPSIS
    The repo-relative paths changed across a git diff range — the diff counterpart to the tracked-file
    universe.
.DESCRIPTION
    Renames are split into delete plus add so a file moving into or out of a globset re-triggers it.
.PARAMETER Range
    A range reaching a commit missing from a shallow clone fails in git, so a pipeline must fetch full depth.
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
