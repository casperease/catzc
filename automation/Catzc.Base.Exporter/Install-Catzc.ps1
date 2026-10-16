<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Exporter/Install-Catzc.ps1
    name: install-catzc
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Exporter
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-exporter/Install-Catzc.ps1.md
      test: automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1
    adrs:
      - ADR-AUTO-BUNDLE#6
      - ADR-AUTO-DRYRUN#2
      - ADR-AUTO-ENGINE#2
      - ADR-PWSH-ENUM#3
  config:
    synopsis: Installs a Catzc build — two-part beside a working root, or into the current user's module path.
    description: |-
      Places a build (Build-Modules' Catzc/<version>/ folder) where it is consumed
      ([ADR-AUTO-BUNDLE#6](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle6)):

        -Root <dir>            the two-part install. The build is copied to <dir>/.vendor/Catzc/<version>/, and a
                               root importer.ps1 is written at <dir> that dot-sources the installed Import-Catzc.ps1
                               with -RepositoryRoot set to <dir> — so <dir> is the working root (out/ and
                               repo-relative paths resolve there) and the installed build is the code root.
                               Dot-source <dir>/importer.ps1 to load the platform.
        -Scope CurrentUser     the build is copied to <user module path>/Catzc/<version>/, after which
                               Import-Module Catzc loads it from any shell.

      The build is verified first (Assert-CatzcBundle), before the destination is touched. The version is the
      build's own (build.json). Idempotent: when the target already holds the same content hash the copy is
      skipped (and a -Root install only refreshes its importer.ps1); -Force copies anyway. On Linux and macOS a copy
      makes every shipped shell script with a shebang executable again, since the copy drops the bit bash needs.
    parameters:
      Root: The destination working root for a two-part install. Not the mono repo.
      Scope: CurrentUser — install into the user's PowerShell module path instead of beside a working root.
      Bundle: |-
        Whose devbox build to install when -Source is not given (an exporter.yml bundles key). Defaults to
        default_bundle.
      Source: |-
        The build to install (default: the bundle's devbox build,
        <Get-OutputRoot>/automation/built/<bundle>/Catzc/<direct_install_version>).
      Force: Copy the build even when the target already holds the same content hash.
      DryRun: Report the plan without copying or writing.
      Silent: Suppress the summary line.
    examples:
      - Install-Catzc -Root C:\work\project
      - Install-Catzc -Scope CurrentUser
---
#>

function Install-Catzc {
    [CmdletBinding(DefaultParameterSetName = 'Root')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Root')]
        [string] $Root,

        [Parameter(Mandatory, ParameterSetName = 'Scope')]
        [ValidateSet('CurrentUser')]
        [string] $Scope,

        [string] $Bundle = "$((Get-Config -Config exporter).default_bundle)",

        [string] $Source = (Join-Path (Get-OutputRoot) "automation/built/$Bundle/Catzc/$((Get-Config -Config exporter).direct_install_version)"),
        [switch] $Force,
        [switch] $DryRun,
        [switch] $Silent
    )

    Assert-CatzcBundle -Path $Source

    $sourceBuild = [System.IO.File]::ReadAllText((Join-Path $Source 'build.json')) | ConvertFrom-Json
    $version = "$($sourceBuild.version)"
    $sourceHash = "$($sourceBuild.contentHash)"

    $importer = $null
    if ($Scope -eq 'CurrentUser') {
        $moduleTarget = Join-Path (Get-CatzcUserModulePath) "Catzc/$version"
    }
    else {
        $moduleTarget = Join-Path $Root ".vendor/Catzc/$version"
        $importer = Join-Path $Root 'importer.ps1'
    }

    $targetBuild = Join-Path $moduleTarget 'build.json'
    $upToDate = $false
    if ([System.IO.File]::Exists($targetBuild)) {
        $upToDate = "$(([System.IO.File]::ReadAllText($targetBuild) | ConvertFrom-Json).contentHash)" -eq $sourceHash
    }
    $copy = $Force -or -not $upToDate

    if (-not $DryRun) {
        if ($copy) {
            if ([System.IO.Directory]::Exists($moduleTarget)) {
                [System.IO.Directory]::Delete($moduleTarget, $true)
            }
            Copy-Directory -Path $Source -Destination $moduleTarget
            if (-not $IsWindows) {
                $execute = [System.IO.UnixFileMode]::UserExecute -bor [System.IO.UnixFileMode]::GroupExecute -bor [System.IO.UnixFileMode]::OtherExecute
                foreach ($engine in @([Catzc.Base.Engines.ExecutionEngines]::All | Where-Object RequiresExecutableBit)) {
                    foreach ($extension in $engine.ScriptExtensions) {
                        foreach ($script in Get-ChildPath $moduleTarget -File -Filter "*$extension" -Depth 64 -Exclude @() -PruneVendor $false) {
                            if ([System.IO.File]::ReadLines($script) | Select-Object -First 1 | Where-Object { $_.StartsWith('#!') }) {
                                [System.IO.File]::SetUnixFileMode($script, [System.IO.File]::GetUnixFileMode($script) -bor $execute)
                            }
                        }
                    }
                }
            }
        }
        if ($importer) {
            $lines = @(
                "# Catzc $version root importer (generated by Install-Catzc — do not edit)."
                '# Dot-source it to load catzc from the installed build, with this folder as the working root:  . ./importer.ps1'
                'param([switch] $AllowWarnings)'
                ". (Join-Path `$PSScriptRoot '.vendor/Catzc/$version/Import-Catzc.ps1') -RepositoryRoot `$PSScriptRoot -AllowWarnings:`$AllowWarnings"
            )
            Write-FileIfChanged -Path $importer -Content ($lines -join "`n") | Out-Null
        }
    }

    if (-not $Silent) {
        $verb = if ($DryRun) {
            'Would install'
        }
        elseif ($copy) {
            'Installed'
        }
        else {
            'Already current:'
        }
        $where = "module $moduleTarget"
        if ($importer) {
            $where += "; importer $importer"
        }
        Write-Message "$verb Catzc $version -> $where"
    }

    [pscustomobject]@{
        ModulePath     = $moduleTarget
        Importer       = $importer
        Version        = $version
        ContentHash    = $sourceHash
        AlreadyCurrent = -not $copy
    }
}
