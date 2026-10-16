<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Toolchain/private/Install-BicepStandalone.ps1
    folder: private
    name: install-bicep-standalone
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1
    cites:
      - ADR-AUTO-PKGMGR
  config:
    synopsis: 'Installs the Bicep CLI on Linux: the newest release at the pinned version, verified, into ~/.local/bin.'
    description: |-
      Linux has no distribution package for the Bicep CLI, so Install-Bicep comes here. The newest Azure/bicep release
      whose tag matches the pin is resolved from the GitHub releases API, and its single-file binary for this machine's
      architecture (bicep-linux-x64 or bicep-linux-arm64) is downloaded through Save-VerifiedDownload against the SHA-256
      GitHub publishes for the asset (`digest`) — an asset without one is refused, never run unverified
      ([ADR-AUTO-PKGMGR](/docs/adr/automation/use-proper-package-managers.md)). It lands in the user's ~/.local/bin (the
      same user-space bin as the standalone uv), marked executable; no root is needed.
    parameters:
      Version: The version prefix to install (e.g. 0.48).
    examples:
      - Install-BicepStandalone -Version 0.48
---
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
