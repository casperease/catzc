<#
.SYNOPSIS
    Returns a track/container's ordered aspect classification — the facets its units partition into.
.DESCRIPTION
    The `aspects` repo-wide variant (configs/variants.yml, ADR-ASPECT) is a per-track/per-container map of
    ordered first-match (fallthrough) classifications, patterns relative to the unit root. Each aspect is
    { Name, Patterns }; evaluated in order, first match wins, the LAST aspect is the '**' catch-all remainder.
    The catch-all's liveness is the container's call: 'automation' (code) keeps 'live' closed so a stray file
    falls to the 'tests' catch-all and never ships; 'infrastructure' (a deployment) makes 'live' the catch-all
    — everything under a template ships, only an explicit tests/ folder is non-live. An unknown track falls
    back to the automation convention. The shape is validated by Assert-VariantsConfig; the Globs aspect
    engine compiles each aspect into a scan program.
.PARAMETER Track
    The track/container whose convention to return ('automation', 'infrastructure', …). Defaults to
    'automation'.
.EXAMPLE
    Get-Aspect -Track automation      # -> live (closed), tests (catch-all)
.EXAMPLE
    (Get-Aspect -Track infrastructure)[-1].Name   # -> 'live' (a deployment's catch-all is live)
#>
function Get-Aspect {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Track = 'automation'
    )

    $default = [ordered]@{
        automation     = @([ordered]@{ live = @('*.ps1', 'private/**', 'types/**', 'configs/**') }, [ordered]@{ tests = @('**') })
        infrastructure = @([ordered]@{ tests = @('**/tests/**') }, [ordered]@{ live = @('**') })
    }
    $configured = Get-Variant -Name aspects -Default $default

    $list = if ($configured.Contains($Track)) {
        $configured[$Track]
    }
    elseif ($default.Contains($Track)) {
        $default[$Track]
    }
    else {
        $configured.Contains('automation') ? $configured['automation'] : $default['automation']
    }

    foreach ($item in @($list)) {
        $name = @($item.Keys)[0]
        [pscustomobject]@{
            Name     = "$name"
            Patterns = @($item[$name] | ForEach-Object { "$_" })
        }
    }
}
