function Assert-VendorModuleAvailable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Position = 1)]
        [string] $Version
    )

    if (-not (Test-VendorModuleAvailable -Name $Name -Version $Version)) {
        $where = "source '$(Resolve-VendorRepository)'"
        $what = if ($Version) {
            "'$Name' v$Version"
        }
        else {
            "'$Name'"
        }
        throw "Vendor module $what is not available from $where — it cannot be restored from the network."
    }
}
