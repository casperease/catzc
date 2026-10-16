<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Objects/ConvertTo-SortedDictionary.ps1
    name: convert-to-sorted-dictionary
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Objects/tests/ConvertTo-SortedDictionary.Tests.ps1
  config:
    synopsis: Recursively converts dictionaries to ordered form for stable output.
    description: |-
      OrderedDictionaries keep their original key order.
      Plain Hashtables get their keys sorted alphabetically.
      Nested dictionaries are processed recursively.
    parameters:
      Dictionary: The dictionary to process.
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
