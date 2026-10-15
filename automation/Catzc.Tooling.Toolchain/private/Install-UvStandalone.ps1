<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/private/Install-UvStandalone.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: private
    adrs:
      - ADR-AUTO-PKGMGR
      - ADR-AUTO-UVPY
---
#>

<#
.SYNOPSIS
    Bootstraps uv on Linux from Astral's standalone GitHub release — user-space, hash-verified, no root.
.DESCRIPTION
    The standalone build is also the one uv self update serves, so later upgrades stay in place.
    [ADR-AUTO-PKGMGR](/docs/adr/automation/use-proper-package-managers.md),
    [ADR-AUTO-UVPY](/docs/adr/automation/uv-python-handler.md)
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/private/Install-UvStandalone.ps1.md#comment1)
.PARAMETER Version
    The locked uv version prefix from tools.yml (e.g. '0.11').
#>
function Install-UvStandalone {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Version
    )

    Assert-NotNullOrWhitespace $env:HOME -ErrorText 'Install-UvStandalone needs $env:HOME to locate the uv tool-bin (~/.local/bin).'

    Write-Message "Resolving the astral-sh/uv release for the locked $Version.x"
    $releases = Invoke-RestMethod -Uri 'https://api.github.com/repos/astral-sh/uv/releases?per_page=100' -Headers @{ Accept = 'application/vnd.github+json' }
    $escaped = [regex]::Escape($Version)
    # Select-Object -First 1 is $null on no match (indexing an empty array throws under strict), so the assert reports it
    $release = $releases | Where-Object { ($_.tag_name -replace '^v', '') -match "^$escaped(\.|$)" } | Select-Object -First 1
    Assert-NotNull $release -ErrorText "No astral-sh/uv release matches the locked $Version.x — bump the uv pin in tools.yml."

    $architecture = if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq 'Arm64') {
        'aarch64'
    }
    else {
        'x86_64'
    }
    $assetName = "uv-$architecture-unknown-linux-gnu.tar.gz"
    # Select-Object -First 1 is $null on no match (indexing an empty array throws under strict), so the assert reports it
    $asset = $release.assets | Where-Object { $_.name -eq $assetName } | Select-Object -First 1
    Assert-NotNull $asset -ErrorText "astral-sh/uv release $($release.tag_name) has no asset '$assetName'."

    # A missing digest hard-fails rather than running an unverified binary, the same discipline as Install-Git.
    # [comment:2](/docs/references/automation/catzc-tooling-toolchain/private/Install-UvStandalone.ps1.md#comment2)
    $digest = if ($asset.PSObject.Properties['digest']) {
        $asset.digest
    }
    else {
        $null
    }
    Assert-NotNullOrWhitespace $digest -ErrorText "uv asset '$assetName' has no published SHA-256 (digest) — refusing an unverified download."

    $archivePath = Join-Path ([IO.Path]::GetTempPath()) $assetName
    $extractDirectory = Join-Path ([IO.Path]::GetTempPath()) ('uv-standalone-' + [guid]::NewGuid().ToString('N'))
    [System.IO.Directory]::CreateDirectory($extractDirectory) | Out-Null
    try {
        Save-VerifiedDownload -Uri $asset.browser_download_url -OutFile $archivePath -Sha256 $digest | Out-Null
        Invoke-Executable "tar -xzf `"$archivePath`" -C `"$extractDirectory`""

        $binDirectory = Join-Path $env:HOME '.local/bin'
        [System.IO.Directory]::CreateDirectory($binDirectory) | Out-Null
        foreach ($binary in 'uv', 'uvx') {
            # Select-Object -First 1 is $null on no match (indexing an empty array throws under strict), so the assert reports it
            $found = [System.IO.Directory]::EnumerateFiles($extractDirectory, $binary, [System.IO.SearchOption]::AllDirectories) |
                Select-Object -First 1
            Assert-NotNullOrWhitespace $found -ErrorText "'$binary' was not found in the extracted uv archive."
            $destination = Join-Path $binDirectory $binary
            [System.IO.File]::Copy($found, $destination, $true)
            Invoke-Executable "chmod +x `"$destination`""
        }
    }
    finally {
        Remove-Item $archivePath -Force -ErrorAction Ignore
        Remove-Item $extractDirectory -Recurse -Force -ErrorAction Ignore
    }

    # The tool bin is normally on the persistent PATH already; this only makes it resolve in this session.
    # [ADR-AUTO-UVPY](/docs/adr/automation/uv-python-handler.md)
    # [comment:3](/docs/references/automation/catzc-tooling-toolchain/private/Install-UvStandalone.ps1.md#comment3)
    if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains $binDirectory) {
        $env:PATH = "$binDirectory$([System.IO.Path]::PathSeparator)$env:PATH"
    }
    Assert-Command uv -ErrorText "uv was installed to '$binDirectory' but is not on PATH. Add '$binDirectory' to PATH and restart your shell."
    Write-Message "uv $($release.tag_name -replace '^v', '') installed to '$binDirectory'"
}
