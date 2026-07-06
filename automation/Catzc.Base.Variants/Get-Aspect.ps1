<#
.SYNOPSIS
    Returns the ordered aspect classification — the facets every module and track partitions into.
.DESCRIPTION
    The `aspects` repo-wide variant (configs/variants.yml, ADR-ASPECT): an ordered first-match (fallthrough)
    classification of a unit's tracked files, patterns relative to the unit root. Each aspect is
    { Name, Patterns }; evaluated in order, first match wins, the LAST aspect is the '**' catch-all
    remainder. The default separates the prod-going artifacts ('live' — root functions, private helpers,
    C# types, configs) from the means to verify them ('tests' — the catch-all remainder), so anything
    'live' does not explicitly claim falls to the non-live side and can never silently ship. The shape is
    validated by Assert-VariantsConfig; the Globs aspect engine compiles each aspect into a scan program.
.EXAMPLE
    Get-Aspect   # -> live (closed), tests (catch-all)
.EXAMPLE
    (Get-Aspect)[-1].Name   # -> 'tests' (the non-live catch-all)
#>
function Get-Aspect {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $default = @(
        [ordered]@{ live = @('*.ps1', 'private/**', 'types/**', 'configs/**') }
        [ordered]@{ tests = @('**') }
    )
    foreach ($item in @(Get-Variant -Name aspects -Default $default)) {
        $name = @($item.Keys)[0]
        [pscustomobject]@{
            Name     = "$name"
            Patterns = @($item[$name] | ForEach-Object { "$_" })
        }
    }
}
