<#
---
catzc:
  immutable:
    with_body_sha: d5f390e9504f
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleProfile.Tests.ps1
    docs: "[Get-ModuleProfile.ps1.md](docs/references/pwsh/catzc-base-modulesystem/Get-ModuleProfile.ps1.md)"
---
#>

function Get-ModuleProfile {
    [CmdletBinding(DefaultParameterSetName = 'Profile')]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Profile')]
        [ArgumentCompleter({ (Get-Config -Config profiles).profiles.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config profiles).profiles.Keys })]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'Modules')]
        [string[]] $Modules,

        [switch] $NoInfrastructure
    )

    $seed = if ($PSCmdlet.ParameterSetName -eq 'Modules') {
        @($Modules)
    }
    else {
        @((Get-Config -Config profiles).profiles[$Name])
    }
    $seed = @($seed | Where-Object { $_ })   # drop nulls/blanks (an empty seed => the whole repo)

    $named = if ($seed.Count -gt 0) {
        Get-ModuleDependencyClosure -Module $seed
    }
    else {
        [string[]] @((Get-CatzcModule -EngineTrack).name)
    }

    $result = [System.Collections.Generic.List[string]]::new()
    foreach ($module in $named) {
        [void] $result.Add($module)
    }
    if (-not $NoInfrastructure) {
        foreach ($infra in '.internal', '.compiled', '.vendor') {
            if ($infra -notin $result) {
                [void] $result.Add($infra)
            }
        }
    }

    $ret = [string[]] @($result)
    [System.Array]::Sort($ret, [System.StringComparer]::Ordinal)
    $ret
}
