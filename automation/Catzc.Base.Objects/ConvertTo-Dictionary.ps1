<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Objects/ConvertTo-Dictionary.ps1
    name: convert-to-dictionary
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-objects/ConvertTo-Dictionary.ps1.md
    test: automation/Catzc.Base.Objects/tests/ConvertTo-Dictionary.Tests.ps1
  config:
    synopsis: |-
      Converts a typed object, PSCustomObject, or dictionary into a nested, mutable structure of ordered
      dictionaries (default) or PSCustomObjects (-AsPSObject).
    description: |-
      The escape hatch from the native data-model classes back to a dictionary surface. It walks public
      properties via PSObject.Properties — the same channel that exposes a C# class's get-only properties and
      a PSCustomObject's note-properties — recursing through nested objects and arrays; scalars pass through.
      The result is a fresh, mutable copy, so the source object is unchanged.

      Use it at the seam where a frozen typed object must be spliced into a tree you are about to mutate, or
      serialized (e.g. into a per-slot ParametersFile, or to YAML/JSON). Read-only navigation needs no
      conversion — read the typed object's properties directly.

      Keys are the object's property names (snake_case for the config-mirroring data-model types, so a
      round-trip back to YAML stays byte-compatible with the original config).
    parameters:
      InputObject: The object to convert.
      AsPSObject: Emit nested [PSCustomObject] instead of [ordered] dictionaries.
      MaxDepth: Maximum recursion depth (default 10).
    examples:
      - |-
        $env = Get-AzureEnvironment dev -Subscription shared_nonprod | ConvertTo-Dictionary
        $env.subscription.customer = 'override'   # the dict is mutable; the typed object was not
      - Get-BicepTemplate sample | ConvertTo-Dictionary -AsPSObject
---
#>

function ConvertTo-Dictionary {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [AllowNull()]
        $InputObject,

        [switch] $AsPSObject,

        [int] $MaxDepth = 10
    )

    begin {
        function ConvertTo-PSObjectTree {
            param($Node)
            if ($Node -is [System.Collections.IDictionary]) {
                $shaped = [ordered]@{}
                foreach ($key in $Node.Keys) {
                    $shaped[$key] = ConvertTo-PSObjectTree $Node[$key]
                }
                return [PSCustomObject]$shaped
            }
            if ($Node -is [System.Collections.IList]) {
                return @($Node | ForEach-Object { ConvertTo-PSObjectTree $_ })
            }
            $Node
        }
    }

    process {
        $dict = ConvertTo-YamlSafe -Value $InputObject -MaxDepth $MaxDepth
        if ($AsPSObject) {
            ConvertTo-PSObjectTree $dict
        }
        else {
            $dict
        }
    }
}
