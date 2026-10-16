<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Contracts
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-contracts/Publish-ContractRelease.ps1.md
      test: automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1
    adrs:
      - ADR-AUTO-BUNDLE#7
      - ADR-AUTO-PATH#2
      - ADR-PWSH-ENUM#3
      - ADR-PWSH-VERBS#1
      - ADR-REPO-CONTRACT#5
  config:
    synopsis: Freezes a unit's contract draft as a released version folder, with the .frozen record that keeps it unchanged.
    description: |-
      Releasing a unit freezes its draft ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)):
      this copies contracts/<unit>/0.0.0/ byte for byte to contracts/<unit>/<version>/ and writes the folder's .frozen
      record, the SHA-256 of each copied file, line endings read as LF. Test-Contracts compares every released folder with
      its record, so a later edit fails the quality gate; the record is not an asset (Get-Contract skips it).

      It refuses, before writing anything: the draft 0.0.0 itself; the devbox build version (exporter.yml
      direct_install_version, 6.6.666), which names no release
      ([ADR-AUTO-BUNDLE#7](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle7)); a target folder that already
      exists, since a released folder is never written again; a unit with no draft; and a draft that does not list
      (Get-Contract throws on it). A copy that fails part-way removes the target again.

      It writes files only: it never commits, and it does not check the assets. A release build resolves the version
      (Resolve-CatzcBuildVersion), runs this, runs Test-Contracts -Version <version>, and commits the folder in its own
      step. Publish is the approved verb for making a resource available to others
      ([ADR-PWSH-VERBS#1](/docs/adr/pwsh/respect-pwsh-verb-rules.md#rule-adr-pwsh-verbs1)): the frozen
      folder is what a consumer pins.
    parameters:
      Unit: 'The deployable-unit whose draft to freeze, by folder name: today catzc, the bundle.'
      Version: 'The released version, <major>.<minor>.<patch>: the version the release build resolved.'
      RepositoryRoot: 'The repository root that holds contracts/. Default: the loaded repository root.'
    outputs: |-
      [string] The frozen folder in communication form, contracts/<unit>/<version>
      ([ADR-AUTO-PATH#2](/docs/adr/automation/path-representation.md#rule-adr-auto-path2)); nothing under -WhatIf.
    examples:
      - Publish-ContractRelease -Unit catzc -Version 0.1.427
      - Publish-ContractRelease -Unit catzc -Version (Resolve-CatzcBuildVersion) -WhatIf
---
#>

function Publish-ContractRelease {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]*$')]
        [string] $Unit,

        [Parameter(Mandatory)]
        [ValidatePattern('^[0-9]+\.[0-9]+\.[0-9]+$')]
        [string] $Version,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $name = "contracts/$Unit/$Version"
    if ($Version -ceq '0.0.0') {
        throw [System.ArgumentException]::new("Publish-ContractRelease: 0.0.0 is the draft of '$Unit', the folder a release freezes, never a release itself (ADR-REPO-CONTRACT#5).")
    }
    $devbox = "$((Get-Config -Config exporter).direct_install_version)"
    if ($Version -ceq $devbox) {
        throw [System.ArgumentException]::new("Publish-ContractRelease: $Version is the devbox build version (exporter.yml direct_install_version); it names no release, so it never freezes a folder (ADR-REPO-CONTRACT#5).")
    }

    $draft = Join-Path $RepositoryRoot 'contracts' $Unit '0.0.0'
    $target = Join-Path $RepositoryRoot 'contracts' $Unit $Version
    if (-not [System.IO.Directory]::Exists($draft)) {
        throw [System.InvalidOperationException]::new("Publish-ContractRelease: contracts/$Unit/0.0.0/ does not exist, so there is no draft to freeze.")
    }
    if ([System.IO.Directory]::Exists($target) -or [System.IO.File]::Exists($target)) {
        throw [System.InvalidOperationException]::new("Publish-ContractRelease: $name/ already exists; a released version folder is immutable and is never written again (ADR-REPO-CONTRACT#5).")
    }
    $null = @(Get-Contract -Unit ([WildcardPattern]::Escape($Unit)) -Version '0.0.0' -RepositoryRoot $RepositoryRoot)

    if (-not $PSCmdlet.ShouldProcess($name, "Freeze contracts/$Unit/0.0.0/ as")) {
        return
    }

    try {
        $files = [string[]] @(Get-ChildPath $draft -File -Depth 64 -Exclude @() -PruneVendor $false)
        $null = [System.IO.Directory]::CreateDirectory($target)
        foreach ($file in $files) {
            $copy = Join-Path $target ([System.IO.Path]::GetRelativePath($draft, $file))
            $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($copy))
            [System.IO.File]::Copy($file, $copy)
        }

        $hashes = Get-ContractFileHashes -Folder $target
        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add("# $name, frozen by Publish-ContractRelease: the SHA-256 of each file, line endings read as LF.")
        $lines.Add('# A released version folder is immutable (ADR-REPO-CONTRACT#5); Test-Contracts fails when a file differs.')
        foreach ($path in $hashes.Keys) {
            $lines.Add("$($hashes[$path])  $path")
        }
        [System.IO.File]::WriteAllText((Join-Path $target '.frozen'), (($lines -join "`n") + "`n"), [System.Text.UTF8Encoding]::new($false))
    }
    catch {
        if ([System.IO.Directory]::Exists($target)) {
            [System.IO.Directory]::Delete($target, $true)
        }
        throw
    }
    $name
}
