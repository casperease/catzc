<#
---
catzc:
  immutable:
    with_body_sha: "7a95c185a802"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-TestInRunScope.Tests.ps1
    docs: "[Test-TestInRunScope.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Test-TestInRunScope.ps1.md)"
---
#>

function Test-TestInRunScope {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        $Test,

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @()
    )

    $level = Get-TestBlockTag -Test $Test -Valid ([Catzc.Base.Timeouts.TestTiers]::Names)
    $category = Get-TestBlockTag -Test $Test -Valid 'logic', 'integrity'
    @(@($level) + @($category) | Where-Object { $_ -in $ExcludeTag }).Count -eq 0
}
