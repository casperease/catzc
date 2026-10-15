<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Overlay/Import-CatzcOverlay.ps1
    kind: function
    module: Catzc.Base.Overlay
    visibility: public
    adrs:
      - ADR-AUTO-OVERLAY
---
#>

<#
.SYNOPSIS
    Applies the consumer overlay's function overrides to the loaded bundle, after checking the whole overlay.
.DESCRIPTION
    Overrides load before local modules, so a local module calls the bundle as overridden.
.OUTPUTS
    [pscustomobject] The function overrides applied and the local modules loaded (Kind, Module, Target,
    Visibility, File, RelativePath).
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
