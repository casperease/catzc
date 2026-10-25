<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-config/private/Merge-ConfigFragment.ps1.md"
  header: "generated"
---
#>

function Merge-ConfigFragment {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Base,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Fragment,

        # The parts of one split config are disjoint: a key two parts both set as a value is an error, never an override.
        [switch] $Disjoint
    )

    $merged = [ordered]@{}
    foreach ($key in $Base.Keys) {
        $merged[$key] = $Base[$key]
    }
    foreach ($key in $Fragment.Keys) {
        $value = $Fragment[$key]
        $bothMaps = $value -is [System.Collections.IDictionary] -and $merged[$key] -is [System.Collections.IDictionary]
        if ($Disjoint -and $merged.Contains($key) -and -not $bothMaps) {
            throw "Config parts overlap: key '$key' is set by more than one part; each key belongs to one part."
        }
        if ($null -eq $value) {
            $merged.Remove($key)
        }
        elseif ($bothMaps) {
            $merged[$key] = Merge-ConfigFragment -Base $merged[$key] -Fragment $value -Disjoint:$Disjoint
        }
        else {
            $merged[$key] = $value
        }
    }
    $merged
}
