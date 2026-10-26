function Get-ManagedGuids {
    [CmdletBinding()]
    param()

    (Get-Config -Config guids).guids
}
