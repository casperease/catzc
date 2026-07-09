<#
.SYNOPSIS
    Bootstraps uv on Linux from Astral's standalone GitHub release — user-space, hash-verified, no root.
.DESCRIPTION
    Linux has no uv apt package, so the fresh-machine bootstrap is Astral's standalone release: resolve the
    newest astral-sh/uv release matching the locked version prefix, download the platform tarball verified
    against the release asset's published SHA-256 (Save-VerifiedDownload — the Install-Git discipline, see
    docs/adr/automation/use-proper-package-managers.md), and extract uv and uvx into the uv tool-bin
    (~/.local/bin, docs/adr/automation/uv-python-handler.md). Entirely user-space: no package manager, no
    elevation. The standalone build is also the one `uv self update` serves, so later upgrades stay in place.
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
    $release = @($releases | Where-Object { ($_.tag_name -replace '^v', '') -match "^$escaped(\.|$)" })[0]
    Assert-NotNull $release -ErrorText "No astral-sh/uv release matches the locked $Version.x — bump the uv pin in tools.yml."

    $architecture = if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq 'Arm64') {
        'aarch64'
    }
    else {
        'x86_64'
    }
    $assetName = "uv-$architecture-unknown-linux-gnu.tar.gz"
    $asset = @($release.assets | Where-Object { $_.name -eq $assetName })[0]
    Assert-NotNull $asset -ErrorText "astral-sh/uv release $($release.tag_name) has no asset '$assetName'."

    # The GitHub release asset carries its published SHA-256 ('digest'); hard-fail rather than run an
    # unverified binary — the same discipline as Install-Git.
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
            $found = @([System.IO.Directory]::EnumerateFiles($extractDirectory, $binary, [System.IO.SearchOption]::AllDirectories))[0]
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

    # The uv tool-bin is normally on the persistent PATH already (ADR-AUTO-UVPY); make it resolve in this session.
    if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains $binDirectory) {
        $env:PATH = "$binDirectory$([System.IO.Path]::PathSeparator)$env:PATH"
    }
    Assert-Command uv -ErrorText "uv was installed to '$binDirectory' but is not on PATH. Add '$binDirectory' to PATH and restart your shell."
    Write-Message "uv $($release.tag_name -replace '^v', '') installed to '$binDirectory'"
}
