Describe 'New-CatsCommandLookup — the real contracts' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CMDCONTRACT#5' {
    BeforeAll {
        $script:text = New-CatsCommandLookup
        $script:rows = @($script:text -split "`n" | Where-Object { $_ -match "`t" })
    }

    It 'is a sourced shell file that sets the one lookup variable' {
        $script:text | Should -BeLike '# shellcheck shell=bash*'
        $script:text | Should -Match "(?m)^_catzc_commands='$"
        $script:text.TrimEnd() | Should -BeLike "*'"
    }

    It 'writes one row per contracted parameter: command, parameter, type, list, mandatory, pipeline, asset, sets and default set' {
        $script:rows | Should -Contain ("Get-PathFileType`tPath`tstring`t0`t1`t0`tcontracts/catzc/0.0.0/Catzc.Base.Languages/Get-PathFileType.command.yml`t`t")
        $script:rows | Should -Contain ("Get-ContractCheckResults`tAsset`tCatzc.Base.Contracts.ContractAsset`t1`t0`t1`tcontracts/catzc/0.0.0/Catzc.Base.Contracts/Get-ContractCheckResults.command.yml`t`t")
        $script:rows | Should -Contain ("Get-Inspiration`tCount`tint`t0`t1`t0`tcontracts/catzc/0.0.0/Catzc.Tooling.Inspiration/Get-Inspiration.command.yml`tRandom`tAll")
    }

    It 'covers every command contract, and no row holds a quote that would end the variable' {
        $commands = @($script:rows | ForEach-Object { ($_ -split "`t")[0] } | Select-Object -Unique)
        $commands.Count | Should -Be @(Get-CommandContract).Count
        @($script:rows | Where-Object { $_.Contains("'") }).Count | Should -Be 0
    }
}
