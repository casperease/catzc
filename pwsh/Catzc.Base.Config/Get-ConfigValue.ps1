<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Config/Get-ConfigValue.ps1
    name: get-config-value
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
    docs: "[Get-ConfigValue.ps1.md](docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md)"
    cites:
      - ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS
      - ADR-CONF-ADDRESSING
      - ADR-CONF-LOADING-ONEREADER
      - ADR-CONF-LOADING-EXISTENCEDISCOVERED
---
#>

function Get-ConfigValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('(?-i)^global\.[a-z0-9]+(-[a-z0-9]+)*(\.[^.]+)*$')]
        [string] $Address,

        [string] $Module
    )

    $parts = $Address -split '\.'
    $configName = $parts[1]
    $keyPath = [string[]]@()
    if ($parts.Count -gt 2) {
        $keyPath = $parts[2..($parts.Count - 1)]
    }

    $config = Get-Config -Config $configName -Module $Module
    Resolve-ConfigKeyPath -Node $config -Segment $keyPath -Address $Address
}
