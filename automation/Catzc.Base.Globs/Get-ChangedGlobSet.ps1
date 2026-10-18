<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
    name: get-changed-glob-set
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
    cites:
      - ADR-FLOW-CD-GLOBS#{1,4}
---
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
