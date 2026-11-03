function Resolve-NetworkCallHost {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $ConfigName
    )

    $url = (Get-Config -Config $ConfigName).package_source.url
    $authority = ($url -replace '^[a-z][a-z0-9+.-]*://', '') -split '/' | Select-Object -First 1
    ($authority -replace ':\d+$', '').ToLowerInvariant()
}
