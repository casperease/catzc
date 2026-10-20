<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Objects/ConvertTo-SortedDictionary.ps1
    name: convert-to-sorted-dictionary
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Objects/tests/ConvertTo-SortedDictionary.Tests.ps1
    docs: "[ConvertTo-SortedDictionary.ps1.md](docs/references/pwsh/catzc-base-objects/ConvertTo-SortedDictionary.ps1.md)"
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
