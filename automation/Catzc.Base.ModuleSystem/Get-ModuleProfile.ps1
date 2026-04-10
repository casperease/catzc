<#
.SYNOPSIS
    Resolves a named profile (or an explicit seed list) to the full set of disk-module names to copy — the
    dependency closure of the seed plus the fixed infrastructure needed to load and test.
.DESCRIPTION
    A profile (configs/profiles.yml) is a seed list of module names. This expands the seed to its transitive
    declared-dependency closure (Get-ModuleDependencyClosure) so the result is loadable, then appends the fixed
    infrastructure modules (.internal, .compiled, .vendor) unless -NoInfrastructure. An empty seed (the `full`
    profile, or an empty -Modules) resolves to every on-disk named module.

    The result is the module-name set to feed Copy-Automation -ModuleNames (Copy-Automation -ModuleProfile does
    this for you) or Test-InIsolation.
.PARAMETER Name
    A profile name from profiles.yml (minimal, base, azure, tooling, full, …).
.PARAMETER Modules
    An explicit seed list instead of a named profile — resolved through the same closure logic.
.PARAMETER NoInfrastructure
    Omit the fixed infrastructure modules (.internal, .compiled, .vendor); return only named modules.
.OUTPUTS
    [string[]] The disk-module names (named + infrastructure), ordinal-sorted.
.EXAMPLE
    Get-ModuleProfile -Name azure
.EXAMPLE
    Get-ModuleProfile -Modules Catzc.Base.Config   # explicit, same closure logic
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
        [string[]] @((Get-BaseModule -Kind named).Name)
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
