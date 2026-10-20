<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/Save-VerifiedDownload.ps1
    name: save-verified-download
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Save-VerifiedDownload.Tests.ps1
    docs: "[Save-VerifiedDownload.ps1.md](docs/references/pwsh/catzc-tooling-core/Save-VerifiedDownload.ps1.md)"
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
