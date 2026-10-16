<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Core/Save-VerifiedDownload.ps1
    name: save-verified-download
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Tooling.Core/tests/Save-VerifiedDownload.Tests.ps1
  config:
    synopsis: Downloads a file over HTTPS and verifies its SHA-256, rejecting a mismatch.
    description: |-
      Downloads -Uri to -OutFile, computes the SHA-256, and asserts it equals -Sha256 (case-insensitive,
      'sha256:' prefix tolerated). On mismatch the partial/bad file is deleted and the call throws — a
      download is never left on disk for a caller to execute unverified. Returns the verified path.

      The expected hash comes from the caller. For a sanctioned 'latest' base tool (e.g. git) it is the
      publisher's own published hash for the resolved version — the GitHub release asset `digest`. (Tools
      whose publisher provides no checksum, e.g. Postman, are TLS-only and do not use this helper.) See
      ADR controlling-systemwide-deps.
    parameters:
      Uri: The download URL.
      OutFile: Destination path.
      Sha256: Expected SHA-256, hex (a leading 'sha256:' is stripped).
    examples:
      - Save-VerifiedDownload -Uri $asset.browser_download_url -OutFile $exePath -Sha256 $asset.digest
---
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
