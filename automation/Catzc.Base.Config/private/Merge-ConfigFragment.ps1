<#
.SYNOPSIS
    Merges a consumer overlay's config fragment onto a bundled config, key by key.
.DESCRIPTION
    A fragment states only the keys that differ: - a map merges into the bundled map recursively; - a scalar or a...
    [ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)
    [comment:1](/docs/references/automation/catzc-base-config/private/Merge-ConfigFragment.ps1.md#comment1)
.PARAMETER Base
    The parsed bundled config.
.PARAMETER Fragment
    The parsed overlay fragment.
#>
function Merge-ConfigFragment {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Base,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Fragment
    )

    $merged = [ordered]@{}
    foreach ($key in $Base.Keys) {
        $merged[$key] = $Base[$key]
    }
    foreach ($key in $Fragment.Keys) {
        $value = $Fragment[$key]
        if ($null -eq $value) {
            $merged.Remove($key)
        }
        elseif ($value -is [System.Collections.IDictionary] -and $merged[$key] -is [System.Collections.IDictionary]) {
            $merged[$key] = Merge-ConfigFragment -Base $merged[$key] -Fragment $value
        }
        else {
            $merged[$key] = $value
        }
    }
    $merged
}
