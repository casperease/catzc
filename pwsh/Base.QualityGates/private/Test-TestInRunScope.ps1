<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Test-TestInRunScope.ps1.md"
  header: "generated"
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
