<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Modules/Get-Aspect.ps1
    name: get-aspect
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Modules
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1
    cites:
      - ADR-AUTO-MODULE#2
      - ADR-DSGN-ASPECT
  config:
    synopsis: Returns a track/container's ordered aspect classification — the named parts its units partition into.
    description: |-
      An aspect convention is an ordered first-match (fallthrough) classification of VariantAspect { Name, Patterns }, patterns relative
      to the unit root; the LAST aspect is the '**' catch-all remainder ([ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)).

      A code track (a track of the modules track type) derives its convention from the layout
      ([ADR-AUTO-MODULE#2](/docs/adr/automation/module-model.md#rule-adr-auto-module2)): 'live' is the patterns of the layout's live rows,
      kept closed so a stray file falls to the 'tests' catch-all and never ships. Any other track takes the convention its `aspects`
      entry in configs/variants.yml declares, else the built-in one: 'infrastructure' (a deployment) makes 'live' the catch-all, so
      everything under a template ships and only an explicit tests/ folder is non-live. A track with neither falls back to the code
      convention. The `aspects` shape is validated by the VariantsConfig type; the Globs aspect engine compiles each aspect into a scan
      program.
    parameters:
      Track: The track/container whose convention to return ('automation', 'infrastructure', …).
    examples:
      - 'Get-Aspect -Track automation      # -> live (closed, from the layout), tests (catch-all)'
      - '(Get-Aspect -Track infrastructure)[-1].Name   # -> ''live'' (a deployment''s catch-all is live)'
---
#>

function Get-Aspect {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.VariantAspect])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Track
    )

    $code = {
        [Catzc.Base.Variants.VariantAspect]::new('live', [string[]](Get-Config -Config languages).LivePatterns())
        [Catzc.Base.Variants.VariantAspect]::new('tests', [string[]]@('**'))
    }

    $trackEntry = @(Get-Track).Where({ $_.name -ceq $Track })
    if ($trackEntry.Count -gt 0 -and $trackEntry[0].type -ceq 'modules') {
        & $code
        return
    }

    $configured = (Get-Config -Config variants).aspects
    if ($configured -and $configured.ContainsKey($Track)) {
        $configured[$Track]
        return
    }

    $builtIn = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
            aspects = [ordered]@{ infrastructure = @([ordered]@{ tests = @('**/tests/**') }, [ordered]@{ live = @('**') }) }
        }).aspects
    if ($builtIn.ContainsKey($Track)) {
        $builtIn[$Track]
        return
    }

    & $code
}
