<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md"
  warning: "Generated Header"
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
