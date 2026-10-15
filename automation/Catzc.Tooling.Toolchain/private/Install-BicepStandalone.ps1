<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/private/Install-BicepStandalone.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: private
    adrs:
      - ADR-AUTO-PKGMGR
---
#>

<#
.SYNOPSIS
    Installs the Bicep CLI on Linux: the newest release at the pinned version, verified, into ~/.local/bin.
.DESCRIPTION
    A release asset without a published SHA-256 digest is refused, never run unverified.
    [ADR-AUTO-PKGMGR](/docs/adr/automation/use-proper-package-managers.md)
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/private/Install-BicepStandalone.ps1.md#comment1)
.PARAMETER Version
    The version prefix to install (e.g. 0.48).
.EXAMPLE
    Install-BicepStandalone -Version 0.48
#>
function Install-BicepStandalone {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Version
    )

    Assert-NotNullOrWhitespace $env:HOME -ErrorText 'Install-BicepStandalone needs $env:HOME to locate the user bin (~/.local/bin).'

    Write-Message "Resolving the Azure/bicep release for the locked $Version.x"
    $releases = Invoke-RestMethod -Uri 'https://api.github.com/repos/Azure/bicep/releases?per_page=100' -Headers @{ Accept = 'application/vnd.github+json' }
    $escaped = [regex]::Escape($Version)
    # The newest stable release at the pin; Select-Object -First 1 is $null on no match, so the assert reports it.
    $release = @($releases) |
        Where-Object { -not $_.prerelease -and ($_.tag_name -replace '^v', '') -match "^$escaped(\.|$)" } |
        Sort-Object { [version]($_.tag_name -replace '^v', '') } -Descending |
        Select-Object -First 1
    Assert-NotNull $release -ErrorText "No Azure/bicep release matches the locked $Version.x — bump the bicep pin in tools.yml."

    $architecture = if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq 'Arm64') {
        'arm64'
    }
    else {
        'x64'
    }
    $assetName = "bicep-linux-$architecture"
    $asset = @($release.assets) | Where-Object { $_.name -eq $assetName } | Select-Object -First 1
    Assert-NotNull $asset -ErrorText "Azure/bicep release $($release.tag_name) has no asset '$assetName'."
    $digest = if ($asset.PSObject.Properties['digest']) {
        $asset.digest
    }
    else {
        $null
    }
    Assert-NotNullOrWhitespace $digest -ErrorText "Bicep asset '$assetName' has no published SHA-256 (digest) — refusing an unverified download."

    $binDirectory = Join-Path $env:HOME '.local/bin'
    [System.IO.Directory]::CreateDirectory($binDirectory) | Out-Null
    $destination = Join-Path $binDirectory 'bicep'
    # Download beside the destination, then move it in, so a failed download never leaves a half-written bicep.
    $download = "$destination.download"
    try {
        Save-VerifiedDownload -Uri $asset.browser_download_url -OutFile $download -Sha256 $digest | Out-Null
        Invoke-Executable "chmod +x `"$download`""
        Move-Item -LiteralPath $download -Destination $destination -Force
    }
    finally {
        Remove-Item -LiteralPath $download -Force -ErrorAction Ignore
    }
    Write-Message "Bicep CLI $($release.tag_name) installed to '$destination'"
}
