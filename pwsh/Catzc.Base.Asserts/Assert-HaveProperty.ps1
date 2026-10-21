<#
---
catzc:
  immutable:
    with_body_sha: "77da06c4837c"
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
