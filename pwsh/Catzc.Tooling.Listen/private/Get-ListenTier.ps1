<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-listen/private/Get-ListenTier.ps1.md"
  warning: "Generated Header"
---
#>

function Get-ListenTier {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $match = Get-FileKind $Path
    $role = if ($match) {
        $match.role
    }
    else {
        $null
    }
    [pscustomobject]@{
        Kind = $role
        Tier = (Get-Config -Config listen).TierOf($role)
    }
}
