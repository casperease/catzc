<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/ConvertTo-SortedDictionary.ps1
    kind: public-function
    module: Catzc.Base.Objects
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Recursively converts dictionaries to ordered form for stable output.
.DESCRIPTION
    Only a plain hashtable is sorted; an ordered dictionary keeps its key order, which is the order its author chose.
.PARAMETER Dictionary
    The dictionary to process.
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
