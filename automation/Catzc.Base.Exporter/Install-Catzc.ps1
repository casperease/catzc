<#
.SYNOPSIS
    Installs a built Catzc bundle onto a destination root — two parts: the module, and a root importer.ps1.
.DESCRIPTION
    Places a bundle (from Build-Catzc / out/) at a destination that is NOT the mono repo, as two artifacts:
      1. the module — the bundle's automation/ tree and build.json — copied to <Root>/<ModulesSubfolder>/Catzc/<version>/;
      2. a root importer.ps1 written at <Root>, whose $PSScriptRoot becomes RepositoryRoot (the working root: out/
         and repo-relative paths resolve there) and which points CatzcModulesRoot at the installed module's
         automation/. Dot-source <Root>/importer.ps1 to load the platform from the install.

    Verifies the source bundle first (Assert-CatzcBundle). Idempotent: when the target already holds the same
    content hash, the module copy is skipped and only the root importer.ps1 is (re)written; -Force copies anyway.
    The install target is writable by design (a repo's .vendor, a user/app dir), so no manifest pre-generation
    is needed — the module manifests generate on first load.
.PARAMETER Root
    The destination working root (the root importer.ps1 is written here). Not the mono repo.
.PARAMETER ModulesSubfolder
    Where under Root the module folder goes; default '.vendor' -> <Root>/.vendor/Catzc/<version>/.
.PARAMETER Source
    The built bundle to install (default: out/catzc/<version>).
.PARAMETER Version
    The version to install (default: Get-CatzcVersion — the 6.6.666 direct-install sentinel).
.PARAMETER Force
    Copy the module even when the target already holds the same content hash.
.PARAMETER DryRun
    Report the plan without copying or writing.
.PARAMETER Silent
    Suppress the summary line.
.EXAMPLE
    Install-Catzc -Root C:\work\project
#>
function Install-Catzc {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Root,

        [string] $ModulesSubfolder = '.vendor',
        [string] $Source,
        [string] $Version,
        [switch] $Force,
        [switch] $DryRun,
        [switch] $Silent
    )

    Assert-NotNullOrWhitespace $Root
    if (-not $Version) {
        $Version = Get-CatzcVersion
    }
    if (-not $Source) {
        $Source = Join-Path (Get-OutputRoot) "catzc/$Version"
    }
    Assert-CatzcBundle -Path $Source

    $moduleTarget = Join-Path $Root (Join-Path $ModulesSubfolder "Catzc/$Version")
    $sourceHash = (Get-Content (Join-Path $Source 'build.json') -Raw | ConvertFrom-Json).contentHash
    $targetBuild = Join-Path $moduleTarget 'build.json'
    $upToDate = $false
    if (Test-Path $targetBuild) {
        $upToDate = (Get-Content $targetBuild -Raw | ConvertFrom-Json).contentHash -eq $sourceHash
    }

    $subPath = (Join-Path $ModulesSubfolder "Catzc/$Version/automation").Replace('\', '/')

    if (-not $DryRun) {
        if ($upToDate -and -not $Force) {
            # module already current — leave it, just refresh the root importer below
        }
        else {
            if ([System.IO.Directory]::Exists($moduleTarget)) {
                [System.IO.Directory]::Delete($moduleTarget, $true)
            }
            Copy-Directory -Path (Join-Path $Source 'automation') -Destination (Join-Path $moduleTarget 'automation')
            [System.IO.Directory]::CreateDirectory($moduleTarget) | Out-Null
            [System.IO.File]::Copy((Join-Path $Source 'build.json'), $targetBuild, $true)
        }
        Write-CatzcBundleBootstrap -Root $Root -Version $Version -ModulesSubPath $subPath | Out-Null
    }

    if (-not $Silent) {
        $verb = 'Installed'
        if ($DryRun) {
            $verb = 'Would install'
        }
        elseif ($upToDate -and -not $Force) {
            $verb = 'Refreshed (module current)'
        }
        Write-Message "$verb Catzc $Version -> module: $moduleTarget ; importer: $(Join-Path $Root 'importer.ps1')"
    }

    [pscustomobject]@{
        Root           = $Root
        ModulePath     = $moduleTarget
        Importer       = Join-Path $Root 'importer.ps1'
        Version        = $Version
        ContentHash    = $sourceHash
        AlreadyCurrent = ($upToDate -and -not $Force)
    }
}
