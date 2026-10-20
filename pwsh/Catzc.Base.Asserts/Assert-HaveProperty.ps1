<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Asserts/Assert-HaveProperty.ps1
    name: assert-have-property
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-HaveProperty.Tests.ps1
    docs: "[Assert-HaveProperty.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-HaveProperty.ps1.md)"
---
#>

function Assert-HaveProperty {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [object] $Object,

        [Parameter(Mandatory, Position = 1)]
        [string] $PropertyName
    )

    if (Test-HaveProperty $Object $PropertyName) {
        return
    }

    $current = $Object
    $traversed = @()
    foreach ($segment in $PropertyName -split '\.') {
        if ($null -eq $current -or $segment -notin $current.PSObject.Properties.Name) {
            $path = ($traversed + $segment) -join '.'
            throw "Object does not have property '$path'"
        }
        $traversed += $segment
        $current = $current.$segment
    }
}
