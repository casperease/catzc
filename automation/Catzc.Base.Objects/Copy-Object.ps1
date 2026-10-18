<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Objects/Copy-Object.ps1
    name: copy-object
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Objects/tests/Copy-Object.Tests.ps1
---
#>

function Copy-Object {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = '$AcceptWarnings is consumed inside the nested Clone function (it gates the note-properties verbose message), which this rule does not trace across the nested-function boundary')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [AllowNull()]
        $InputObject,

        [switch] $AcceptWarnings
    )

    begin {
        $warned = $false

        function Clone {
            param($Object)
            # Null
            if ($null -eq $Object) {
                return $null
            }

            # Value types (int, bool, datetime, enum, etc.) — copied by value
            if ($Object.GetType().IsValueType) {
                return $Object
            }

            # Strings — immutable, safe to share
            if ($Object -is [string]) {
                return $Object
            }

            # Ordered dictionary — must check before IDictionary
            if ($Object -is [System.Collections.Specialized.OrderedDictionary]) {
                $c = [ordered]@{}
                foreach ($key in $Object.Keys) {
                    $c[$key] = Clone $Object[$key]
                }
                return $c
            }

            # Hashtable / other dictionaries
            if ($Object -is [System.Collections.IDictionary]) {
                $c = @{}
                foreach ($key in $Object.Keys) {
                    $c[$key] = Clone $Object[$key]
                }
                return $c
            }

            # PSCustomObject
            if (@($Object.PSObject.Properties).Count -gt 0 -and
                $Object.GetType().Name -eq 'PSCustomObject') {
                if (-not $warned -and -not $AcceptWarnings) {
                    Write-Verbose 'Only copying note properties'
                    Set-Variable warned $true -Scope 1
                }
                $c = [PSCustomObject]@{}
                foreach ($property in $Object.PSObject.Properties) {
                    $c | Add-Member -NotePropertyName $property.Name -NotePropertyValue (Clone $property.Value)
                }
                return $c
            }

            # Arrays and lists
            if ($Object -is [System.Collections.IList]) {
                $c = [System.Collections.Generic.List[object]]::new($Object.Count)
                foreach ($item in $Object) {
                    $c.Add((Clone $item))
                }
                if ($Object -is [array]) {
                    return @(, $c.ToArray())
                }
                return $c
            }

            # Fallback: return reference for unknown types
            $Object
        }
    }

    process {
        Clone $InputObject
    }
}
