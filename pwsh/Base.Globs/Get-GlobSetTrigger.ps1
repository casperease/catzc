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
