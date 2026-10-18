<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Objects/ConvertTo-Dictionary.ps1
    name: convert-to-dictionary
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
    page: docs/references/automation/catzc-base-objects/ConvertTo-Dictionary.ps1.md
    test: automation/Catzc.Base.Objects/tests/ConvertTo-Dictionary.Tests.ps1
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
