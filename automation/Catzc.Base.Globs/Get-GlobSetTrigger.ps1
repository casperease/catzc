<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
    kind: public-function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-FLOW-CD-GLOBS#1
      - ADR-FLOW-CD-GLOBS#4
---
#>

<#
.SYNOPSIS
    Projects a globset's scan program into vendor-native pipeline path filters — the no-start trigger.
.DESCRIPTION
    Only a mechanical projection: an ADO set it cannot reproduce exactly is caught by the superset test, not here.
.PARAMETER Name
    The declared globset to project.
.PARAMETER GlobSet
    A [Catzc.Base.Globs.GlobSet] to project instead (the path a derived set takes).
.OUTPUTS
    [pscustomobject] { Name; GitHub = [string[]] ordered paths; AdoInclude = [string[]]; AdoExclude = [string[]] }.
.EXAMPLE
    Get-GlobSetTrigger -Name apex
.EXAMPLE
    (Get-GlobSetTrigger -Name automation).GitHub
#>
function Get-GlobSetTrigger {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'ByName')]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByObject')]
        [Catzc.Base.Globs.GlobSet] $GlobSet
    )

    $set = if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        Get-GlobSet -Name $Name
    }
    else {
        $GlobSet
    }

    $gitHub = [System.Collections.Generic.List[string]]::new()
    $lastSelect = [ordered]@{}
    foreach ($rule in $set.ScanProgram()) {
        $pattern = $rule.Pattern.Pattern
        if ($rule.Select) {
            $gitHub.Add($pattern)
        }
        else {
            $gitHub.Add("!$pattern")
        }
        $lastSelect[$pattern] = [bool]$rule.Select
    }

    $adoInclude = [System.Collections.Generic.List[string]]::new()
    $adoExclude = [System.Collections.Generic.List[string]]::new()
    foreach ($pattern in $lastSelect.Keys) {
        if ($lastSelect[$pattern]) {
            $adoInclude.Add($pattern)
        }
        else {
            $adoExclude.Add($pattern)
        }
    }

    [pscustomobject]@{
        Name       = $set.Name
        GitHub     = $gitHub.ToArray()
        AdoInclude = $adoInclude.ToArray()
        AdoExclude = $adoExclude.ToArray()
    }
}
