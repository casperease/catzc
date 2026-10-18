<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Config/Get-ConfigValue.ps1
    name: get-config-value
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
    cites:
      - ADR-AUTO-ENVVAR#7
      - ADR-CONF-ADDRESSING#{3-5}
      - ADR-CONF-LOADING#{1,2}
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
