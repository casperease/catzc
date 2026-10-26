<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md"
  header: "generated"
---
#>

function Publish-ContractRelease {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]*$')]
        [string] $Root,

        [Parameter(Mandatory)]
        [ValidatePattern('^[0-9]+\.[0-9]+\.[0-9]+$')]
        [string] $Version,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $name = "contracts/$Root/$Version"
    $current = [Catzc.Base.Contracts.ContractLayout]::CurrentVersion
    if ($Root -cne [Catzc.Base.Contracts.ContractLayout]::ProvidedRoot) {
        throw [System.ArgumentException]::new("Publish-ContractRelease: '$Root' is a vendor root, which never releases; it follows its vendor in $current, and only $([Catzc.Base.Contracts.ContractLayout]::ProvidedRoot) releases (ADR-REPO-CONTRACT-KEPTWHILEPINNED).")
    }
    if ([int] $Version.Split('.')[0] -lt 1) {
        throw [System.ArgumentException]::new("Publish-ContractRelease: $Version is not a release of '$Root'; a release is a version from 1.0.0 up, and $current is the current version a release freezes a copy of (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).")
    }
    $devbox = "$((Get-Config -Config exporter).direct_install_version)"
    if ($Version -ceq $devbox) {
        throw [System.ArgumentException]::new("Publish-ContractRelease: $Version is the devbox build version (exporter.yml direct_install_version); it names no release, so it never freezes a folder (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).")
    }

    $source = Join-Path $RepositoryRoot 'contracts' $Root $current
    $target = Join-Path $RepositoryRoot 'contracts' $Root $Version
    if (-not [System.IO.Directory]::Exists($source)) {
        throw [System.InvalidOperationException]::new("Publish-ContractRelease: contracts/$Root/$current/ does not exist, so there is nothing to freeze.")
    }
    if ([System.IO.Directory]::Exists($target) -or [System.IO.File]::Exists($target)) {
        throw [System.InvalidOperationException]::new("Publish-ContractRelease: $name/ already exists; a released version folder is immutable and is never written again (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).")
    }
    $null = @(Get-Contract -Root ([WildcardPattern]::Escape($Root)) -Version ([WildcardPattern]::Escape($current)) -RepositoryRoot $RepositoryRoot)

    if (-not $PSCmdlet.ShouldProcess($name, "Freeze contracts/$Root/$current/ as")) {
        return
    }

    try {
        $files = [string[]] @(Get-ChildPath $source -File -Depth 64 -Exclude @() -PruneVendor $false)
        $null = [System.IO.Directory]::CreateDirectory($target)
        foreach ($file in $files) {
            $copy = Join-Path $target ([System.IO.Path]::GetRelativePath($source, $file))
            $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($copy))
            [System.IO.File]::Copy($file, $copy)
        }

        $hashes = Get-ContractFileHashes -Folder $target
        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add("# $name, frozen by Publish-ContractRelease: the SHA-256 of each file, line endings read as LF.")
        $lines.Add('# A released version folder is immutable (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE); Test-Contracts fails when a file differs.')
        foreach ($path in $hashes.Keys) {
            $lines.Add("$($hashes[$path])  $path")
        }
        [System.IO.File]::WriteAllText((Join-Path $target '.frozen'), (($lines -join "`n") + "`n"),
            [System.Text.UTF8Encoding]::new($false))
    }
    catch {
        if ([System.IO.Directory]::Exists($target)) {
            [System.IO.Directory]::Delete($target, $true)
        }
        throw
    }
    $name
}
