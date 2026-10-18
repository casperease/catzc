<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
    folder: private
    name: resolve-config-key-path
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-CONF-ADDRESSING#{2,4,5}
---
#>

function Resolve-ConfigKeyPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowNull()]
        $Node,

        [Parameter(Mandatory, Position = 1)]
        [AllowEmptyCollection()]
        [string[]] $Segment,

        [Parameter(Mandatory, Position = 2)]
        [string] $Address
    )

    $current = $Node
    foreach ($key in $Segment) {
        if ($null -eq $current) {
            throw "Config address '$Address': the node before segment '$key' is null; the path cannot continue."
        }

        if ($current -is [System.Collections.IDictionary]) {
            # Through the interface: a generic or read-only dictionary (a typed config's map) has no public Contains.
            if (-not ([System.Collections.IDictionary] $current).Contains($key)) {
                throw "Config address '$Address': key '$key' does not exist in the config node."
            }
            $current = $current[$key]
            continue
        }

        $property = $current.PSObject.Properties[$key]
        if (-not $property) {
            throw "Config address '$Address': '$key' is neither a dictionary key nor a property on the config node."
        }
        $current = $property.Value
    }

    $current
}
