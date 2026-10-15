<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Save-VerifiedDownload.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Downloads a file over HTTPS and verifies its SHA-256, rejecting a mismatch.
.DESCRIPTION
    A mismatch deletes the file before throwing, so an unverified download is never left on disk to be executed.
.PARAMETER Uri
    The download URL.
.PARAMETER OutFile
    Destination path.
.PARAMETER Sha256
    Expected SHA-256, hex (a leading 'sha256:' is stripped).
.EXAMPLE
    Save-VerifiedDownload -Uri $asset.browser_download_url -OutFile $exePath -Sha256 $asset.digest
#>
function Save-VerifiedDownload {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Uri,

        [Parameter(Mandatory, Position = 1)]
        [string] $OutFile,

        [Parameter(Mandatory, Position = 2)]
        [string] $Sha256
    )

    $expected = ($Sha256 -replace '^sha256:', '').Trim()
    Assert-NotNullOrWhitespace $expected -ErrorText "Save-VerifiedDownload needs an expected SHA-256 for '$Uri'."

    Write-Message "Downloading $Uri"
    Invoke-WebRequest -Uri $Uri -OutFile $OutFile -UseBasicParsing
    Assert-PathExist $OutFile

    $actual = (Get-FileHash -Path $OutFile -Algorithm SHA256).Hash
    if ($actual -ne $expected) {
        Remove-Item $OutFile -Force -ErrorAction SilentlyContinue
        throw "Checksum mismatch for '$Uri': expected SHA-256 '$expected', got '$actual'. Download rejected."
    }

    Write-Verbose "Verified SHA-256 of '$OutFile'"
    $OutFile
}
