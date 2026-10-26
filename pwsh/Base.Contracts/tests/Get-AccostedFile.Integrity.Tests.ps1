Describe 'Get-AccostedFile over the shipped contracts.accosted.yml' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:path = Join-Path (Get-CatzcModulesRoot) 'Catzc.Base.Contracts/accosted/contracts.accosted.yml'
    }

    It 'loads the shipped file as its typed model, every command contracted, harmless and called with fitting literals' {
        $file = Get-AccostedFile -Path $script:path
        $file | Should -BeOfType ([Catzc.Base.Contracts.AccostedFile])
    }

    It 'holds runs that each hold at least one command' {
        $file = Get-AccostedFile -Path $script:path
        $file.runs.Count | Should -BeGreaterThan 0
        foreach ($run in $file.runs) {
            @($run.commands).Count | Should -BeGreaterThan 0
        }
    }
}
