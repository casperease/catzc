<#
---
catzc:
  immutable:
    with_body_sha: "84a877614729"
  edges:
    test: pwsh/Catzc.Base.Objects/tests/ConvertTo-SortedDictionary.Tests.ps1
    docs: "[ConvertTo-SortedDictionary.ps1.md](../../docs/references/pwsh/catzc-base-objects/ConvertTo-SortedDictionary.ps1.md)"
---
#>

function ConvertTo-SortedDictionary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [System.Collections.IDictionary] $Dictionary
    )

    $alreadyOrdered = $Dictionary -is [System.Collections.Specialized.OrderedDictionary]
    $keys = if ($alreadyOrdered) {
        $Dictionary.Keys
    }
    else {
        $Dictionary.Keys | Sort-Object
    }

    $ret = [ordered]@{}
    foreach ($key in $keys) {
        $value = $Dictionary[$key]
        if ($value -is [System.Collections.IDictionary]) {
            $ret[$key] = ConvertTo-SortedDictionary $value
        }
        else {
            $ret[$key] = $value
        }
    }
    $ret
}
