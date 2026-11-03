function New-BicepConfig {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Target = '*',

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $config = Get-Config -Config bicep
    # The registry host is the url's first segment and the module path the rest, so a br/<name>:<module>:<version> reference resolves there.
    $url = $config.package_source.url
    $slash = $url.IndexOf('/')
    $alias = [ordered]@{}
    if ($slash -lt 0) {
        $alias['registry'] = $url
    }
    else {
        $alias['registry'] = $url.Substring(0, $slash)
        $alias['modulePath'] = $url.Substring($slash + 1)
    }
    $settings = [ordered]@{
        analyzers     = $config.analyzers
        moduleAliases = [ordered]@{ br = [ordered]@{ $config.package_source.name = $alias } }
    }
    $content = (ConvertTo-Json -InputObject $settings -Depth 6).Replace("`r`n", "`n") + "`n"

    # One file per folder of a track that holds Bicep, where the compiler finds the nearest bicepconfig.json.
    foreach ($track in @(Get-Track).Where({ 'bicep' -in $_.languages })) {
        foreach ($place in $track.places) {
            if (-not [System.IO.Directory]::Exists((Join-Path $RepositoryRoot $place))) {
                continue
            }
            $file = "$place/bicepconfig.json"
            if ($file -clike $Target) {
                [pscustomobject]@{ Target = $file; Content = $content }
            }
        }
    }
}
