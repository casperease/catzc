function Get-ListenTier {
    <#
    .SYNOPSIS
        Names a repository-relative path's file kind (Get-FileKind) and the listen tier that kind sits in.
    #>
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
