<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Asserts/Assert-TypeIs.ps1
    name: assert-type-is
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: automation/Catzc.Base.Asserts/tests/Assert-TypeIs.Tests.ps1
---
#>

function Assert-TypeIs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Object,

        [Parameter(Mandatory, Position = 1)]
        [string] $TypeFullName
    )

    if ($Object.GetType().FullName -ne $TypeFullName) {
        throw "Object is not a $TypeFullName (actual: $($Object.GetType().FullName))"
    }
}
