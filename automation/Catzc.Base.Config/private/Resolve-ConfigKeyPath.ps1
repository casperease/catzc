<#
.SYNOPSIS
    Walks a key path into an already-loaded config node and returns the addressed node.
.DESCRIPTION
    The traversal seam behind Get-ConfigValue (see ADR config-value-addressing). Given a config node — a raw
    ordered dictionary or a typed/validated object returned by Get-Config — and an ordered list of key
    segments, it walks one segment at a time and returns the node reached (a leaf value or a subtree).

    Each segment resolves as a dictionary key when the current node is an IDictionary, otherwise as a property
    on the node (so a typed C# config object and a raw dictionary traverse the same way, ADR-CFGADDR:2). Any segment
    that resolves at neither throws, naming the full address and the failing segment (ADR-CFGADDR:4) — there is no
    silent $null. An empty segment list returns the node unchanged (addressing the whole config).

    The returned node may be a live reference into the config cache and must be treated as read-only (ADR-CFGADDR:5).
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
            if (-not $current.Contains($key)) {
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
