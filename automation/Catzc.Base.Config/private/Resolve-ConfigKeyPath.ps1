<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
    kind: private-function
    module: Catzc.Base.Config
    visibility: private
    adrs:
      - ADR-CONF-ADDRESSING#2
      - ADR-CONF-ADDRESSING#4
      - ADR-CONF-ADDRESSING#5
---
#>

<#
.SYNOPSIS
    Walks a key path into an already-loaded config node and returns the addressed node.
.DESCRIPTION
    A segment is a dictionary key first, else a property, so raw and typed configs traverse alike.
.PARAMETER Node
    The config node to walk into — the object Get-Config returned for the config name.
.PARAMETER Segment
    The ordered key segments to walk (may be empty to address the node itself).
.PARAMETER Address
    The full global config address, used only to make traversal errors self-locating.
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
