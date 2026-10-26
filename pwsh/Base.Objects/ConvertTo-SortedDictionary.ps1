<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-objects/ConvertTo-SortedDictionary.ps1.md"
  header: "generated"
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
