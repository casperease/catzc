<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-modules/Get-Aspect.ps1.md"
  header: "generated"
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

    # A laid-out track, one whose primary language owns layout rows, derives its convention from the layout.
    $trackEntry = @(Get-Track).Where({ $_.name -ceq $Track })
    if ($trackEntry.Count -gt 0 -and (Get-Config -Config languages).IsLaidOut($trackEntry[0].languages)) {
        & $code
        return
    }

    # The type holds the declared conventions over its built-in ones (VariantsConfig.DefaultAspects), so one lookup
    # covers both.
    $aspects = Get-AspectDeclaration
    if ($aspects.ContainsKey($Track)) {
        $aspects[$Track]
        return
    }

    & $code
}
