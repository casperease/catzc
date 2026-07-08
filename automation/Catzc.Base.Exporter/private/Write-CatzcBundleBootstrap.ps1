<#
.SYNOPSIS
    Writes the bundle's importer.ps1 — the self-contained bootstrap that loads catzc from the bundle.
.DESCRIPTION
    Generates the importer.ps1 a built bundle carries at its root. Dot-sourcing it establishes a catzc session
    from the bundle, outside the mono repo: it sets RepositoryRoot to the bundle folder (the working root — out/
    and repo-relative paths resolve there), sets CatzcModulesRoot to the bundle's own automation/ (the code
    root), loads the .internal loader by path, and runs Invoke-Importer -Bundle (janitors off, the pre-set
    anchor honoured). This is the proven load path — the same sequence the mono shim runs, minus the git/dev
    janitors a read-only install must not run.
.PARAMETER Root
    The folder to write importer.ps1 into (the working root: RepositoryRoot resolves to it at load time).
.PARAMETER Version
    The bundle version, stamped into the header comment.
.PARAMETER ModulesSubPath
    The path from Root ($PSScriptRoot at load time) to the bundle's automation/ — 'automation' for a
    self-contained bundle (Build-Catzc), or '.vendor/Catzc/<version>/automation' for a two-part install
    (Install-Catzc) where the module lives under the root but apart from the importer.
.EXAMPLE
    Write-CatzcBundleBootstrap -Root $staging -Version (Get-CatzcVersion)
#>
function Write-CatzcBundleBootstrap {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Root,

        [Parameter(Mandatory)]
        [string] $Version,

        [string] $ModulesSubPath = 'automation'
    )

    Assert-NotNullOrWhitespace $Root
    Assert-NotNullOrWhitespace $Version
    Assert-NotNullOrWhitespace $ModulesSubPath

    $lines = @(
        "# Catzc bundle importer $Version (generated — do not edit)."
        '# Dot-source this file to load the catzc platform from the installed bundle:  . <this-folder>/importer.ps1'
        'Set-StrictMode -Version Latest'
        '$env:RepositoryRoot = $PSScriptRoot'
        "`$env:CatzcModulesRoot = Join-Path `$PSScriptRoot '$ModulesSubPath'"
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

    $path = Join-Path $Root 'importer.ps1'
    [System.IO.Directory]::CreateDirectory($Root) | Out-Null
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
    $path
}
