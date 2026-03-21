# Catzc.Internal.TestKit — an on-demand fixture library for Pester tests.
#
# Many tests stand up a synthetic repository on disk: a temp root, an automation/<module> tree, and
# $env:RepositoryRoot pointed at it (restored afterwards). This centralizes that boilerplate. It is a .internal
# shared module (dot-prefixed, so the module conventions — one-function-per-file, Verb-Noun-only exports — do
# not apply; this is a multi-function fixture helper). It is NOT loaded by the importer at startup — a test
# loads it on demand through the loader, in BeforeAll, and it stays for the session:
#
#   BeforeAll {
#       Import-InternalModule TestKit
#       $script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Base.Alpha' = @{ Public = 'Get-Alpha' } }
#   }
#   AfterAll { Remove-FakeRepositoryRoot $script:fake }

function New-ModuleFolder {
    <#
    .SYNOPSIS
        Fabricate one module folder under a (fake) repo root: automation/<Name>/, with public function files at
        the module root, private/<fn>.ps1 files, and any extra files (path relative to the module folder).
        Returns the module directory path.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Root,

        [Parameter(Mandatory)]
        [string] $Name,

        [string[]] $Public = @(),

        [string[]] $Private = @(),

        [hashtable] $Files = @{}
    )

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $moduleDirectory = Join-Path $Root "automation/$Name"
    [System.IO.Directory]::CreateDirectory($moduleDirectory) | Out-Null

    foreach ($function in $Public) {
        if ($function) {
            [System.IO.File]::WriteAllText((Join-Path $moduleDirectory "$function.ps1"), "function $function {}", $utf8)
        }
    }
    if (@($Private).Where({ $_ }).Count -gt 0) {
        $privateDirectory = Join-Path $moduleDirectory 'private'
        [System.IO.Directory]::CreateDirectory($privateDirectory) | Out-Null
        foreach ($function in $Private) {
            if ($function) {
                [System.IO.File]::WriteAllText((Join-Path $privateDirectory "$function.ps1"), "function $function {}", $utf8)
            }
        }
    }
    foreach ($relative in $Files.Keys) {
        $path = Join-Path $moduleDirectory $relative
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
        [System.IO.File]::WriteAllText($path, [string] $Files[$relative], $utf8)
    }

    $moduleDirectory
}

function New-FakeRepositoryRoot {
    <#
    .SYNOPSIS
        Create a fresh temp repository root, populate it, point $env:RepositoryRoot at it, and return a handle
        { Root; Automation; Saved } to pass to Remove-FakeRepositoryRoot. -Modules maps a module name to a spec
        (@{ Public=..; Private=..; Files=.. }; $null/empty = a bare folder). -Files maps repo-root-relative
        paths to content (importer.ps1, .editorconfig, …).
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [hashtable] $Modules = @{},

        [hashtable] $Files = @{}
    )

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $root = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-fixture-' + [guid]::NewGuid().ToString('N'))
    [System.IO.Directory]::CreateDirectory((Join-Path $root 'automation')) | Out-Null

    foreach ($name in $Modules.Keys) {
        $specification = $Modules[$name]
        $params = @{ Root = $root; Name = $name }
        if ($specification -is [System.Collections.IDictionary]) {
            if ($specification['Public']) {
                $params['Public'] = @($specification['Public'])
            }
            if ($specification['Private']) {
                $params['Private'] = @($specification['Private'])
            }
            if ($specification['Files'] -is [System.Collections.IDictionary]) {
                $params['Files'] = $specification['Files']
            }
        }
        New-ModuleFolder @params | Out-Null
    }
    foreach ($relative in $Files.Keys) {
        $path = Join-Path $root $relative
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
        [System.IO.File]::WriteAllText($path, [string] $Files[$relative], $utf8)
    }

    $saved = $env:RepositoryRoot
    $env:RepositoryRoot = $root
    @{ Root = $root; Automation = (Join-Path $root 'automation'); Saved = $saved }
}

function Remove-FakeRepositoryRoot {
    <#
    .SYNOPSIS
        Restore $env:RepositoryRoot to what it was before New-FakeRepositoryRoot and delete the temp tree.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable] $Handle
    )

    $env:RepositoryRoot = $Handle.Saved
    if ($Handle.Root -and (Test-Path $Handle.Root)) {
        Remove-Item $Handle.Root -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Export-ModuleMember -Function New-ModuleFolder, New-FakeRepositoryRoot, Remove-FakeRepositoryRoot
