function Write-ModuleBuildOutput {
    # .SYNOPSIS
    #     Converges the build root to a plan: writes what differs, compiles the types, prunes what the plan omits.
    # .OUTPUTS
    #     [pscustomobject] Built — the combined-types build result, or $null when the selection ships no type.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoBareCacheEntryRead', '',
        Justification = 'The module constants are assigned once in Catzc.Internal.Builder.psm1, whose shared scope this file is dot-sourced into, before any call.')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [string] $BuildRoot,

        [Parameter(Mandatory)]
        [object[]] $Entries
    )

    $keep = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $Entries) {
        [void] $keep.Add($entry.Path)
    }
    [void] $keep.Add('build.json')
    [void] (Clear-StaleBuildFile -BuildRoot $BuildRoot -KeepPath $keep)
    [System.IO.Directory]::CreateDirectory($BuildRoot) | Out-Null

    # The manifests come from the bootstrap's canonical emitter (New-DynamicManifest -NestedModule
    # -FunctionToExport). The bootstrap leaves the session after an import, so it is loaded for the build and
    # removed again when this call loaded it.
    $hadBootstrap = [bool] (Get-Module Catzc.Internal.Bootstrap)
    Import-InternalModule Bootstrap
    try {
        $bootstrap = Get-Module Catzc.Internal.Bootstrap
        foreach ($entry in $Entries) {
            $target = [System.IO.Path]::Combine($BuildRoot, $entry.Path)
            switch ($entry.Kind) {
                'Text' {
                    [void] (Write-FileIfChanged -Path $target -Content $entry.Content)
                }
                'Copy' {
                    [void] (Copy-BuildFileIfChanged -Source $entry.Source -Destination $target -Normalize:$entry.Normalize)
                }
                'Manifest' {
                    $moduleFolder = [System.IO.Path]::GetDirectoryName($target)
                    $nestedModule = [System.IO.Path]::GetFileName($moduleFolder) + $script:mergedFileSuffix
                    $exports = [string[]] @($entry.Exports)
                    & $bootstrap {
                        param($ModulePath, $NestedModule, $FunctionToExport)
                        New-DynamicManifest -ModulePath $ModulePath -NestedModule $NestedModule -FunctionToExport $FunctionToExport
                    } $moduleFolder $nestedModule $exports | Out-Null
                }
            }
        }
    }
    finally {
        if (-not $hadBootstrap) {
            Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction Ignore
        }
    }

    # The one compile path (Build-CombinedTypeAssembly) over the full type set, into the per-machine shadow root; the
    # bundle takes a byte copy, so a rebuild of the same sources ships the same bytes (a compile is not
    # byte-deterministic).
    if (@($Entries | Where-Object { $_.Kind -eq 'Types' }).Count -gt 0) {
        $built = Build-CombinedTypeAssembly -ModulesRoot $SourceRoot -OutputDirectory (Get-TypesShadowRoot)
        $bundleCompiled = [System.IO.Path]::Combine($BuildRoot, '.compiled')
        [System.IO.Directory]::CreateDirectory($bundleCompiled) | Out-Null
        foreach ($file in $built.Path, $built.Manifest) {
            [void] (Copy-BuildFileIfChanged -Source $file -Destination ([System.IO.Path]::Combine($bundleCompiled,
                        [System.IO.Path]::GetFileName($file))) -Normalize:$false)
        }
        $built
    }
}
