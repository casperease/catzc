function Get-BundleModuleDirectory {
    [CmdletBinding()]
    [OutputType([System.IO.DirectoryInfo[]])]
    param(
        [Parameter(Mandatory)]
        [string] $ModulesRoot
    )

    $recordPath = [System.IO.Path]::Combine($ModulesRoot, 'build.json')
    if (-not [System.IO.File]::Exists($recordPath)) {
        throw "Read-only load: the bundle record '$recordPath' does not exist; a bundle names its modules there."
    }
    $record = [System.IO.File]::ReadAllText($recordPath) | ConvertFrom-Json
    $recorded = [string[]] @(if ($record.PSObject.Properties['modules']) {
            $record.modules
        })

    # One level, inline: this module loads before the walker exists
    # ([ADR-PWSH-ENUM-EARLYLOADINGCODE](/docs/drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-earlyloadingcode)).
    [System.IO.DirectoryInfo[]] @([System.IO.DirectoryInfo]::new($ModulesRoot).GetDirectories() |
            Where-Object { $_.Name -cin $recorded })
}
