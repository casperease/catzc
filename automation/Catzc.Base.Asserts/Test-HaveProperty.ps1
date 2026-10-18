<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Asserts/Test-HaveProperty.ps1
    name: test-have-property
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: automation/Catzc.Base.Asserts/tests/Test-HaveProperty.Tests.ps1
---
#>

function Test-HaveProperty {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [object] $Object,

        [Parameter(Mandatory, Position = 1)]
        [string] $PropertyName
    )

    $current = $Object
    foreach ($segment in $PropertyName -split '\.') {
        if ($null -eq $current -or $segment -notin $current.PSObject.Properties.Name) {
            return $false
        }
        $current = $current.$segment
    }

    $true
}
