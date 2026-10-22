<#
---
catzc:
  immutable:
    with_body_sha: "9a1441c4224c"
  edges:
    docs: "[Get-WrapFreeStamp.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-WrapFreeStamp.ps1.md)"
---
#>

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
