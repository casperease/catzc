<#
---
catzc:
  immutable:
    with_body_sha: "5a37cd0beedb"
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Test-HaveProperty.Tests.ps1
    docs: "[Test-HaveProperty.ps1.md](../../docs/references/pwsh/catzc-base-asserts/Test-HaveProperty.ps1.md)"
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
