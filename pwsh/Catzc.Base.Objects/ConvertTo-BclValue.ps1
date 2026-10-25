<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-objects/ConvertTo-BclValue.ps1.md"
  header: "generated"
---
#>

function ConvertTo-BclValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowNull()]
        $InputObject
    )

    function Expand-WrappedValue {
        param($Object)

        if ($Object -is [psobject]) {
            $Object = $Object.psobject.BaseObject
        }
        if ($null -eq $Object -or $Object -is [string] -or $Object.GetType().IsValueType) {
            return $Object
        }

        if ($Object -is [hashtable]) {
            # Clone keeps the table's key comparer; the values are then replaced on the copy, never on the caller's table.
            $copy = $Object.Clone()
            foreach ($key in @($copy.Keys)) {
                $copy[$key] = Expand-WrappedValue $copy[$key]
            }
            return , $copy
        }

        if ($Object -is [System.Collections.IDictionary]) {
            $copy = [ordered]@{}
            foreach ($key in $Object.Keys) {
                $copy.Add((Expand-WrappedValue $key), (Expand-WrappedValue $Object[$key]))
            }
            return , $copy
        }

        if ($Object -is [System.Collections.IList]) {
            $copy = [System.Collections.Generic.List[object]]::new($Object.Count)
            foreach ($item in $Object) {
                $copy.Add((Expand-WrappedValue $item))
            }
            if ($Object -is [array]) {
                return , $copy.ToArray()
            }
            return , $copy
        }

        $Object
    }

    Expand-WrappedValue $InputObject
}
