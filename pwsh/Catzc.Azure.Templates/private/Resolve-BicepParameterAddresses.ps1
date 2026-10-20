<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
    folder: private
    name: resolve-bicep-parameter-addresses
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
    docs: "[Resolve-BicepParameterAddresses.ps1.md](docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD-VALUEBYADDRESS
      - ADR-CONF-ADDRESSING-GLOBALADDRESSFORM
      - ADR-CONF-ADDRESSING-VERSIONCONTROLLEDONLY
---
#>

function Resolve-BicepParameterAddresses {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Parameters,

        [Parameter(Mandatory)]
        [string] $ConfigFile
    )

    $resolved = [ordered]@{}
    $violations = [System.Collections.Generic.List[string]]::new()

    foreach ($name in @($Parameters.Keys)) {
        $entry = $Parameters[$name]
        if ($entry -isnot [System.Collections.IDictionary] -or -not $entry.Contains('address')) {
            $resolved[$name] = $entry
            continue
        }

        $otherKeys = @(foreach ($key in $entry.Keys) {
                if ($key -ne 'address') {
                    $key
                }
            })
        if ($otherKeys.Count -gt 0) {
            $violations.Add("parameter '$name' sets 'address' together with '$($otherKeys -join "', '")' — an addressed parameter sets 'address' alone")
            continue
        }

        $address = $entry['address']
        if ($address -isnot [string] -or [string]::IsNullOrWhiteSpace($address)) {
            $violations.Add("parameter '$name' has an 'address' that is not a global config address string (global.<config>.<key>…)")
            continue
        }

        try {
            $value = Get-ConfigValue -Address $address
        }
        catch {
            $violations.Add("parameter '$name' has address '$address', which does not resolve: $($_.Exception.Message)")
            continue
        }
        $resolved[$name] = [ordered]@{ value = $value }
    }

    if ($violations.Count -gt 0) {
        throw "Template config '$ConfigFile' has invalid config-addressed parameters:`n  - $($violations -join "`n  - ")"
    }

    $resolved
}
