<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Variants/Get-Aspect.ps1
    name: get-aspect
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Variants/tests/Get-Aspect.Tests.ps1
    cites:
      - ADR-DSGN-ASPECT
  config:
    synopsis: Returns a track/container's ordered aspect classification — the named parts its units partition into.
    description: |-
      The `aspects` repo-wide variant (configs/variants.yml,
      [ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)) is a per-track/per-container map of
      ordered first-match (fallthrough) classifications, patterns relative to the unit root. Each aspect is a
      VariantAspect { Name, Patterns }; evaluated in order, first match wins, the LAST aspect is the '**' catch-all
      remainder. The catch-all's liveness is the container's call: 'automation' (code) keeps 'live' closed so a
      stray file falls to the 'tests' catch-all and never ships; 'infrastructure' (a deployment) makes 'live' the
      catch-all — everything under a template ships, only an explicit tests/ folder is non-live. An unknown track
      falls back to the automation convention. The shape is validated by the VariantsConfig type (which also
      validates the defaults below); the Globs aspect engine compiles each aspect into a scan program.
    parameters:
      Track: |-
        The track/container whose convention to return ('automation', 'infrastructure', …). Defaults to
        'automation'.
    examples:
      - 'Get-Aspect -Track automation      # -> live (closed), tests (catch-all)'
      - '(Get-Aspect -Track infrastructure)[-1].Name   # -> ''live'' (a deployment''s catch-all is live)'
---
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
