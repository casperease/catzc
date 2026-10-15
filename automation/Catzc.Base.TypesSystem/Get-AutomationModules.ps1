<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
    kind: function
    module: Catzc.Base.TypesSystem
    visibility: public
    adrs:
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-PESTER#9
---
#>

<#
.SYNOPSIS
    Returns the names of all automation modules (the non-dot directories under the loaded code root).
.DESCRIPTION
    The platform's single source of the module name list, so it is always the filesystem, never hand-kept.
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)
    [comment:1](/docs/references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md#comment1)
.PARAMETER AutomationRoot
    Pass a fixture tree to isolate a logic test from the real module set.
    [comment:2](/docs/references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md#comment2)
.EXAMPLE
    Get-AutomationModules
.EXAMPLE
    Get-AutomationModules -AutomationRoot (Join-Path $fixtureRoot 'automation')
#>
function Get-AutomationModules {
    [OutputType([string[]])]
    param(
        [string] $AutomationRoot = (Get-CatzcModulesRoot)
    )

    Assert-PathExist $AutomationRoot -PathType Container

    # Raw .NET, not Get-ChildItem: the cmdlet adds about 20ms of provider overhead per call.
    # [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)
    # [comment:3](/docs/references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md#comment3)
    $names = [System.Collections.Generic.List[string]]::new()
    foreach ($dir in [System.IO.Directory]::EnumerateDirectories($AutomationRoot)) {
        $name = [System.IO.Path]::GetFileName($dir)
        if (-not $name.StartsWith('.')) {
            $names.Add($name)
        }
    }

    $arr = [string[]]$names.ToArray()
    [System.Array]::Sort($arr, [System.StringComparer]::Ordinal)
    @($arr)
}
