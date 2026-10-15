<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Get-Aspect.ps1
    kind: public-function
    module: Catzc.Base.Variants
    visibility: public
    adrs:
      - ADR-DSGN-ASPECT
---
#>

<#
.SYNOPSIS
    Returns a track/container's ordered aspect classification — the named parts its units partition into.
.DESCRIPTION
    First match wins and the last aspect is the catch-all: automation leaves it to tests, infrastructure to live.
.PARAMETER Track
    An unknown track silently gets the automation aspects instead of an error.
.EXAMPLE
    Get-Aspect -Track automation      # -> live (closed), tests (catch-all)
.EXAMPLE
    (Get-Aspect -Track infrastructure)[-1].Name   # -> 'live' (a deployment's catch-all is live)
#>
function Get-Aspect {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.VariantAspect])]
    param(
        [string] $Track = 'automation'
    )

    $default = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
            aspects = [ordered]@{
                automation     = @([ordered]@{ live = @('*.ps1', 'private/**', 'types/**', 'configs/**', 'assets/**') }, [ordered]@{ tests = @('**') })
                infrastructure = @([ordered]@{ tests = @('**/tests/**') }, [ordered]@{ live = @('**') })
            }
        }).aspects
    $configured = Get-Variant -Name aspects -Default $default

    $list = if ($configured.ContainsKey($Track)) {
        $configured[$Track]
    }
    elseif ($default.ContainsKey($Track)) {
        $default[$Track]
    }
    else {
        $configured.ContainsKey('automation') ? $configured['automation'] : $default['automation']
    }

    $list
}
