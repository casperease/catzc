<#
.SYNOPSIS
    Deep clones a PowerShell object.
.DESCRIPTION
    Recursively copies hashtables, ordered dictionaries, PSCustomObjects,
    arrays, and lists. Value types and strings are returned as-is (immutable
    or copied by value). Unknown reference types are returned by reference.

    PSCustomObject cloning only copies NoteProperties. Use -AcceptWarnings
    to suppress the warning about this limitation.

    Does not use BinaryFormatter or any serialization-based approach.
.PARAMETER InputObject
    The object to deep clone.
.PARAMETER AcceptWarnings
    Suppresses warnings about PSCustomObject cloning limitations.
.EXAMPLE
    $clone = Copy-Object $original
.EXAMPLE
    $clone = Copy-Object $original -AcceptWarnings
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
            if ($Object.PSObject.Properties.Count -gt 0 -and
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
