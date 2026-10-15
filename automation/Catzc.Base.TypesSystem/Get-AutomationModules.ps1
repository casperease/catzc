<#
.SYNOPSIS
    Returns the names of all automation modules (the non-dot directories under the loaded code root).
.DESCRIPTION
    Enumerates the code root (Get-CatzcModulesRoot) and returns each module folder name — the same set...
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)
    [comment:1](/docs/references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md#comment1)
.PARAMETER AutomationRoot
    Path to the automation directory.
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

    # [System.IO] (sorted ordinally) instead of Get-ChildItem -Directory — the cmdlet carries ~20ms of per-call...
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
