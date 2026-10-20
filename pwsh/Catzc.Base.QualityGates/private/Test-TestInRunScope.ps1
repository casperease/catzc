<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Test-TestInRunScope.ps1
    folder: private
    name: test-test-in-run-scope
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-TestInRunScope.Tests.ps1
    docs: "[Test-TestInRunScope.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Test-TestInRunScope.ps1.md)"
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
