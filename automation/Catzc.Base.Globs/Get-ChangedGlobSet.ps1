<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
    kind: function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-FLOW-CD-GLOBS#1
      - ADR-FLOW-CD-GLOBS#4
---
#>

<#
.SYNOPSIS
    The globsets a diff touches — the computed area-of-control of a change.
.DESCRIPTION
    Matching real refs, not a frozen hash, makes squash and concurrent merges harmless; a rename counts both paths.
    [comment:1](/docs/references/automation/catzc-base-globs/Get-ChangedGlobSet.ps1.md#comment1)
.PARAMETER ChangedFile
    The changed repo-relative, '/'-separated paths to reflect (e.g. a diff's file list). May be empty.
.PARAMETER Range
    A git diff range to resolve the changed paths from, e.g. 'HEAD^1..HEAD'.
.PARAMETER IncludeModules
    Also match the derived module globsets, not only the declared registry.
.OUTPUTS
    [Catzc.Base.Globs.GlobSet] Each touched set — declared sets in registry order, then, with
    -IncludeModules, the touched derived module sets.
.EXAMPLE
    Get-ChangedGlobSet -Range 'HEAD^1..HEAD'
.EXAMPLE
    Get-ChangedGlobSet -ChangedFile @('infrastructure/modules/network/main.bicep')
#>
function Get-ChangedGlobSet {
    [CmdletBinding(DefaultParameterSetName = 'ByRange')]
    [OutputType([Catzc.Base.Globs.GlobSet])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByFile')]
        [AllowEmptyCollection()]
        [string[]] $ChangedFile,

        [Parameter(Mandatory, Position = 0, ParameterSetName = 'ByRange')]
        [string] $Range,

        [switch] $IncludeModules
    )

    $changed = if ($PSCmdlet.ParameterSetName -eq 'ByRange') {
        [string[]] (Get-ChangedFile -Range $Range)
    }
    else {
        $ChangedFile
    }

    $sets = [System.Collections.Generic.List[Catzc.Base.Globs.GlobSet]]::new()
    foreach ($set in Get-GlobSet) {
        $sets.Add($set)
    }
    if ($IncludeModules) {
        foreach ($set in Get-ModuleGlobSet) {
            $sets.Add($set)
        }
    }

    foreach ($set in $sets) {
        foreach ($path in $changed) {
            if ($set.Matches($path)) {
                $set
                break
            }
        }
    }
}
