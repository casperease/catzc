<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
    folder: private
    name: resolve-bicep-config-name
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-AZ-DATAMOD#2
  config:
    synopsis: Parses a config / resource-group identity name into its (environment, slot) parts.
    description: |-
      The inverse of Get-BicepConfigName. A config-name is `<environment>[-<slot>]`; env names contain
      no hyphen, so splitting on the FIRST `-` cleanly separates them: the part before is the
      environment (must be defined in azure.yml), the remainder is the optional slot (1-3 lowercase
      alphanumeric, empty for the base slot). Used at discovery to map config filenames back to envs.
      See [ADR-AZ-DATAMOD#2](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2).
    parameters:
      ConfigName: The config-name (a config filename without extension), e.g. `dev` or `dev-001`.
    examples:
      - 'Resolve-BicepConfigName dev-001   # -> @{ environment = ''dev''; slot = ''001'' }'
---
#>

function Resolve-BicepConfigName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ConfigName
    )

    $parts = $ConfigName -split '-', 2
    $environment = $parts[0]
    $slot = if ($parts.Count -gt 1) {
        $parts[1]
    }
    else {
        ''
    }

    $known = @((Get-Config -Config azure).environments.Keys)
    if ($environment -notin $known) {
        throw "Config '$ConfigName' has an unknown environment '$environment' (valid: $(@($known | Sort-Object) -join ', '))"
    }
    if ($slot -and $slot -cnotmatch '^[a-z0-9]{1,3}$') {
        throw "Config '$ConfigName' has a slot '$slot' that is not valid (must be 1-3 lowercase alphanumeric chars)"
    }

    [ordered]@{ environment = $environment; slot = $slot }
}
