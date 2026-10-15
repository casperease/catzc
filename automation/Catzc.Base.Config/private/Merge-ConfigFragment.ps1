<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/private/Merge-ConfigFragment.ps1
    kind: private-function
    module: Catzc.Base.Config
    visibility: private
    adrs:
      - ADR-AUTO-OVERLAY
---
#>

<#
.SYNOPSIS
    Merges a consumer overlay's config fragment onto a bundled config, key by key.
.DESCRIPTION
    A list is replaced whole, never appended to, so the merged result is predictable and neither input changes.
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
