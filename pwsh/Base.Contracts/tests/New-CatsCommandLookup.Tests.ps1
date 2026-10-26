Describe 'New-CatsCommandLookup — the real contracts' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CMDCONTRACT-ONEREADER' {
    BeforeAll {
        $script:text = New-CatsCommandLookup
        $script:rows = @($script:text -split "`n" | Where-Object { $_ -match "`t" })
    }

    It 'is a sourced shell file that sets the one lookup variable' {
        $script:text | Should -BeLike '# shellcheck shell=bash*'
        $script:text | Should -Match "(?m)^_catzc_commands='$"
        $script:text.TrimEnd() | Should -BeLike "*'"
    }

    It 'writes one row per contracted parameter, keyed by the normal form, with its kebab and PowerShell renderings' {
        $script:rows |
            Should -Contain ("get_path_file_type`tpath`tstring`t0`t1`t0`tcontracts/catzc/0.1.0/catzc.base.languages/get_path_file_type.command.yml`t`t`tget-path-file-type`tpath`tGet-PathFileType`tPath")
        $script:rows |
            Should -Contain ("get_contract_check_results`tasset`tcatzc.base.contracts.contract_asset`t1`t0`t1`tcontracts/catzc/0.1.0/catzc.base.contracts/get_contract_check_results.command.yml`t`t`tget-contract-check-results`tasset`tGet-ContractCheckResults`tAsset")
        $script:rows |
            Should -Contain ("get_inspiration`tcount`tint`t0`t1`t0`tcontracts/catzc/0.1.0/catzc.tooling.inspiration/get_inspiration.command.yml`trandom`tall`tget-inspiration`tcount`tGet-Inspiration`tCount")
    }

    It 'renders every command to a function the module system exports' {
        $exported = @(Get-Command -Module 'Catzc.*' -CommandType Function | ForEach-Object Name)
        foreach ($name in @($script:rows | ForEach-Object { ($_ -split "`t")[11] } | Select-Object -Unique)) {
            $exported | Should -Contain $name
        }
    }

    It 'covers every command contract, and no row holds a quote that would end the variable' {
        $commands = @($script:rows | ForEach-Object { ($_ -split "`t")[0] } | Select-Object -Unique)
        $commands.Count | Should -Be @(Get-CommandContract).Count
        @($script:rows | Where-Object { $_.Contains("'") }).Count | Should -Be 0
    }
}
