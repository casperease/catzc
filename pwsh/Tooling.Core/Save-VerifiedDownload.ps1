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
