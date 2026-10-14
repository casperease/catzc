<#
.SYNOPSIS
    Applies the consumer overlay's function overrides to the loaded bundle, after checking the whole overlay.
.DESCRIPTION
    Runs at the end of a bundle load ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). It checks
    the overlay first (Assert-CatzcOverlay), so nothing applies unless all of it is valid. Then each override file
    replaces its function inside the bundled module, in two steps:

      1. the file is dot-sourced inside the module's own scope (`. $module { . $file }`), so the module's callers,
         its script state and Mock -ModuleName reach the override (a call with & would open a child scope and
         discard the definition);
      2. a public override is published to the session's command table, where the import had put the original;
         its script block stays bound to the module, so it keeps running in the module's scope, and every other
         module, which resolves through the session, reaches the override too.

    Config fragments and asset overrides need no step here: Get-Config and Get-CatzcModuleRoot read them on demand.
.OUTPUTS
    [pscustomobject] The function overrides applied (Kind, Module, Target, Visibility, File, RelativePath).
.EXAMPLE
    Import-CatzcOverlay
#>
function Import-CatzcOverlay {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $entries = @(Get-CatzcOverlay)
    if ($entries.Count -eq 0) {
        return
    }
    Assert-CatzcOverlay -Entry $entries

    foreach ($override in @($entries | Where-Object { $_.Kind -eq 'FunctionOverride' })) {
        $module = Get-Module $override.Module
        . $module { param($overrideFile) . $overrideFile } $override.File
        if ($override.Visibility -eq 'public') {
            Set-Item -Path "function:global:$($override.Target)" -Value $module.ExportedFunctions[$override.Target].ScriptBlock
        }
        Write-Verbose "Overlay: $($override.Module)/$($override.Target) replaced by $($override.RelativePath)"
        $override
    }
}
