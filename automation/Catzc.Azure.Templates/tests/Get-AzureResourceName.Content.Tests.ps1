<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/tests/Get-AzureResourceName.Content.Tests.ps1
    folder: tests
    name: get-azure-resource-name-content-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure-templates/tests/Get-AzureResourceName.Content.Tests.ps1.md
---
#>

Describe 'Get-AzureResourceName (tests/assets/Get-AzureResourceName.Content.yml)' -Tag 'L0', 'logic' {
    BeforeDiscovery {
        $contentFile = Join-Path $PSScriptRoot 'assets/Get-AzureResourceName.Content.yml'
        $cases = @((Get-Content $contentFile -Raw | ConvertFrom-Yaml -Ordered).cases)

        # Wrap each case so the It title can bind <name>, while the case rides along as $case.
        $script:okCases = @(
            $cases | Where-Object { $_.Contains('expected') } | ForEach-Object { @{ name = $_.name; case = $_ } }
        )
        $script:errorCases = @(
            $cases | Where-Object { $_.Contains('error') } | ForEach-Object { @{ name = $_.name; case = $_ } }
        )
    }

    It 'generates the expected name: <name>' -ForEach $okCases {
        $splat = @{}
        foreach ($key in $case.input.Keys) {
            $splat[$key] = $case.input[$key]
        }
        Get-AzureResourceName @splat | Should -Be $case.expected
    }

    It 'rejects bad input: <name>' -ForEach $errorCases {
        $splat = @{}
        foreach ($key in $case.input.Keys) {
            $splat[$key] = $case.input[$key]
        }
        { Get-AzureResourceName @splat } | Should -Throw $case.error
    }
}
