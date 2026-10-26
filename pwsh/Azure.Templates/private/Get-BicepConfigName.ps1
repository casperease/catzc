function Get-BicepConfigName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Environment,

        [Parameter(Position = 1)]
        [string] $Slot
    )

    if ([string]::IsNullOrEmpty($Slot)) {
        $Environment
    }
    else {
        "$Environment-$Slot"
    }
}
