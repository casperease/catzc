<#
.SYNOPSIS
    Writes Catzc.psm1 — the RootModule for the NuGet/PSGallery package form of the bundle.
.DESCRIPTION
    The module-manifest delivery shape (Install-PSResource Catzc; Import-Module Catzc) needs a RootModule that
    runs on import. It mirrors the bundle importer.ps1 — anchor CatzcModulesRoot at its own automation/ and boot
    the one living importer in -Bundle mode — with one difference: a Gallery-installed module lives in a
    (often read-only) PSModulePath store and has no separate root importer.ps1 to set the working root, so
    RepositoryRoot defaults to the caller's current directory (where out/ and repo-relative paths resolve) unless
    already set. Dot-source semantics are not available to a RootModule, so the load runs on Import-Module.
.PARAMETER Path
    The module directory to write Catzc.psm1 into.
.PARAMETER Version
    The package version, stamped into the header comment.
#>
function Write-CatzcRootModule {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Version
    )

    Assert-NotNullOrWhitespace $Path
    Assert-NotNullOrWhitespace $Version

    $lines = @(
        "# Catzc $Version RootModule (generated — do not edit). Import-Module Catzc loads the platform."
        'Set-StrictMode -Version Latest'
        'if (-not $env:RepositoryRoot) {'
        '    $env:RepositoryRoot = (Get-Location).ProviderPath'
        '}'
        "`$env:CatzcModulesRoot = Join-Path `$PSScriptRoot 'automation'"
        "Import-Module (Join-Path `$env:CatzcModulesRoot '.internal/Catzc.Internal.Loader.psm1') -Scope Global -Force"
        'Import-InternalModule Importer -Force'
        'try {'
        '    Invoke-Importer -Bundle'
        '}'
        'finally {'
        '    Remove-Module Catzc.Internal.Importer -Force -ErrorAction Ignore'
        '}'
    )
    $content = ($lines -join "`n") + "`n"

    $path = Join-Path $Path 'Catzc.psm1'
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
    $path
}
