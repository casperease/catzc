# This whole file is `integrity` — it binds the REAL shipped config (the live-identity set is derived from it),
# so it also names live identities (e.g. 'apex') as fixture data; the integrity tag is both correct (ADR-TEST:1)
# and what exempts this file from the gate's own self-scan.
Describe 'Test-LogicTestIdentity' -Tag 'L1', 'integrity' {
    It 'the automation test tree is free of live-identity leaks in logic tests' {
        $result = Test-LogicTestIdentity -PassThru
        $leaks = @($result.Findings | ForEach-Object { "$(ConvertTo-RepoRelativePath $_.File):$($_.Line) -> $($_.Token)" })
        $result.FindingCount | Should -Be 0 -Because "logic tests must use fixtures, not live identities (ADR-LANG):`n$($leaks -join "`n")"
    }

    It 'catches a live customer planted in a logic-test file' {
        $path = Join-Path $TestDrive 'Planted.Tests.ps1'
        [System.IO.File]::WriteAllText($path, "Describe 'X' -Tag 'L0', 'logic' { It 'a' { Do-Thing -Customer 'apex' | Should -Be 1 } }")
        $result = Test-LogicTestIdentity -Path $path -PassThru
        $result.FindingCount | Should -BeGreaterThan 0
        $result.Findings[0].Token | Should -Be 'apex'
        $result.Findings[0].Suggest | Should -Match 'fixture'
    }

    It 'passes a planted fixture-only logic-test file' {
        $path = Join-Path $TestDrive 'Clean.Tests.ps1'
        [System.IO.File]::WriteAllText($path, "Describe 'X' -Tag 'L0', 'logic' { It 'a' { Do-Thing -Customer 'acme' | Should -Be 1 } }")
        (Test-LogicTestIdentity -Path $path -PassThru).FindingCount | Should -Be 0
    }
}
