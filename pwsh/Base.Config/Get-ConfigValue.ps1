function Get-ConfigValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('(?-i)^global\.[a-z0-9]+(-[a-z0-9]+)*(\.[^.]+)*$')]
        [string] $Address,

        [string] $Module,

        [ValidateNotNullOrEmpty()]
        [string] $Namespace
    )

    $parts = $Address -split '\.'
    $configName = $parts[1]
    $keyPath = [string[]]@()
    if ($parts.Count -gt 2) {
        $keyPath = $parts[2..($parts.Count - 1)]
    }

    $resolveIn = if ($Namespace) {
        $Namespace
    }
    else {
        Get-CallerNamespace
    }
    $config = Get-Config -Config $configName -Module $Module -Namespace $resolveIn
    Resolve-ConfigKeyPath -Node $config -Segment $keyPath -Address $Address
}
