# Data-driven coverage for Get-AzureResourceName, sourced from tests/assets/Get-AzureResourceName.Content.yml.
# Each case is an input splat + an expected name (or an expected error). `input` is read via
# $case.input (NOT bound as a -ForEach variable) because $input is a PowerShell automatic variable.

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
