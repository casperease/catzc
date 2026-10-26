function Get-WrapFreeStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    # A missing file has no stamp, so a change to it never reads as wrapping only.
    if (-not [System.IO.File]::Exists($Path)) {
        return $null
    }
    $text = ([System.IO.File]::ReadAllText($Path) -replace '\s+', ' ').Trim()
    [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($text)))
}
