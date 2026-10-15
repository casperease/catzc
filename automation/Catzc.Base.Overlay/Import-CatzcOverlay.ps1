<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Overlay/Import-CatzcOverlay.ps1
    kind: automation-function
    module: Catzc.Base.Overlay
    visibility: public
    relatives:
      test: automation/Catzc.Base.Overlay/tests/Import-CatzcOverlay.Tests.ps1
    adrs:
      - ADR-AUTO-OVERLAY
  config:
    synopsis: Applies the consumer overlay's function overrides to the loaded bundle, after checking the whole overlay.
    description: |-
      Runs at the end of a bundle load ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). It checks
      the overlay first (Assert-CatzcOverlay), so nothing applies unless all of it is valid. Then each override file
      replaces its function inside the bundled module, in two steps:

        1. the file is dot-sourced inside the module's own scope (`. $module { . $file }`), so the module's callers,
           its script state and Mock -ModuleName reach the override (a call with & would open a child scope and
           discard the definition);
        2. a public override is published to the session's command table, where the import had put the original;
           its script block stays bound to the module, so it keeps running in the module's scope, and every other
           module, which resolves through the session, reaches the override too.

      Then each local module loads, after the overrides so it calls the bundle as overridden: its private function
      files, then its public ones (each ordinal — the order a built module's merge uses), are dot-sourced into one new
      module of the folder's name, which exports the public ones. Nothing is written: the module is built in the
      session, and its configs and assets are found in its overlay folder (Get-Config, Get-CatzcModuleRoot).

      Config fragments and asset overrides need no step here: Get-Config and Get-CatzcModuleRoot read them on demand.
    outputs: |-
      [pscustomobject] The function overrides applied and the local modules loaded (Kind, Module, Target,
      Visibility, File, RelativePath).
    examples:
      - Import-CatzcOverlay
---
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

    foreach ($local in @($entries | Where-Object { $_.Kind -eq 'LocalModule' })) {
        $privateFolder = [System.IO.Path]::Combine($local.File, 'private')
        $privateFiles = [string[]] @(if ([System.IO.Directory]::Exists($privateFolder)) {
                [System.IO.Directory]::GetFiles($privateFolder, '*.ps1')
            })
        $publicFiles = [string[]] @([System.IO.Directory]::GetFiles($local.File, '*.ps1'))
        [System.Array]::Sort($privateFiles, [System.StringComparer]::Ordinal)
        [System.Array]::Sort($publicFiles, [System.StringComparer]::Ordinal)
        $publicNames = [string[]] @($publicFiles | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_) })

        # A reload replaces the module a previous load built.
        if (Get-Module -Name $local.Module) {
            Remove-Module -Name $local.Module -Force
            Write-Message "Overlay: removed the previous load of local module $($local.Module)"
        }
        $definition = {
            param([string[]] $FunctionFiles, [string[]] $PublicFunctions)
            foreach ($functionFile in $FunctionFiles) {
                . $functionFile
            }
            Export-ModuleMember -Function $PublicFunctions
        }
        New-Module -Name $local.Module -ScriptBlock $definition -ArgumentList (@($privateFiles) + @($publicFiles)), $publicNames |
            Import-Module -Global
        Write-Message "Overlay: loaded local module $($local.Module) from $($local.RelativePath)"
        $local
    }
}
