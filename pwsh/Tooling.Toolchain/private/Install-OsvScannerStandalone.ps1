function Install-OsvScannerStandalone {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Version
    )

    Assert-NotNullOrWhitespace $env:HOME -ErrorText 'Install-OsvScannerStandalone needs $env:HOME to locate the user bin (~/.local/bin).'

    Write-Message "Resolving the google/osv-scanner release for the locked $Version.x"
    $releases = Invoke-RestMethod -Uri 'https://api.github.com/repos/google/osv-scanner/releases?per_page=100' -Headers @{ Accept = 'application/vnd.github+json' }
    $escaped = [regex]::Escape($Version)
    # The newest stable release at the pin; Select-Object -First 1 is $null on no match, so the assert reports it.
    $release = @($releases) |
        Where-Object { -not $_.prerelease -and ($_.tag_name -replace '^v', '') -match "^$escaped(\.|$)" } |
        Sort-Object { [version]($_.tag_name -replace '^v', '') } -Descending |
        Select-Object -First 1
    Assert-NotNull $release -ErrorText "No google/osv-scanner release matches the locked $Version.x — bump the osv_scanner pin in tools.yml."

    $architecture = if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq 'Arm64') {
        'arm64'
    }
    else {
        'amd64'
    }
    $assetName = "osv-scanner_linux_$architecture"
    $asset = @($release.assets) | Where-Object { $_.name -eq $assetName } | Select-Object -First 1
    Assert-NotNull $asset -ErrorText "google/osv-scanner release $($release.tag_name) has no asset '$assetName'."
    $digest = if ($asset.PSObject.Properties['digest']) {
        $asset.digest
    }
    else {
        $null
    }
    Assert-NotNullOrWhitespace $digest -ErrorText "osv-scanner asset '$assetName' has no published SHA-256 (digest) — refusing an unverified download."

    $binDirectory = Join-Path $env:HOME '.local/bin'
    [System.IO.Directory]::CreateDirectory($binDirectory) | Out-Null
    $destination = Join-Path $binDirectory 'osv-scanner'
    # Download beside the destination, then move it in, so a failed download never leaves a half-written binary.
    $download = "$destination.download"
    try {
        Save-VerifiedDownload -Uri $asset.browser_download_url -OutFile $download -Sha256 $digest | Out-Null
        Invoke-Executable "chmod +x `"$download`""
        Move-Item -LiteralPath $download -Destination $destination -Force
    }
    finally {
        Remove-Item -LiteralPath $download -Force -ErrorAction Ignore
    }
    Write-Message "osv-scanner $($release.tag_name) installed to '$destination'"
}
