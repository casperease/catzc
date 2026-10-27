function Get-NetworkCallLines {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Root,

        [Parameter(Mandatory)]
        [string] $File
    )

    $full = Join-Path $Root $File
    if (-not [System.IO.File]::Exists($full)) {
        return $null
    }
    # A file with a NUL byte in its head is binary and holds no code to search.
    $bytes = [System.IO.File]::ReadAllBytes($full)
    if ([System.Array]::IndexOf($bytes, [byte] 0, 0, [System.Math]::Min($bytes.Length, 8000)) -ge 0) {
        return $null
    }
    , [string[]] ([System.Text.Encoding]::UTF8.GetString($bytes) -split '\r?\n')
}
