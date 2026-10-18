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

    # The type holds the declared conventions over its built-in ones (VariantsConfig.DefaultAspects), so one lookup covers both.
    $aspects = (Get-Config -Config variants).aspects
    if ($aspects.ContainsKey($Track)) {
        $aspects[$Track]
        return
    }

    & $code
}
