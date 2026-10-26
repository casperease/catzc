# A backstop for the registry: every shipped config must have a registered type and load through it, or the run fails here.
Describe 'Config conventions' -Tag 'L0', 'integrity' {
    It 'every shipped config has a registered type and loads through it' {
        # The gate lives in a module that depends on this one, so the test calls it and never re-implements its checks.
        $result = Test-ShippedConfigs -PassThru -OutputFolder (Join-Path $TestDrive 'shipped-configs')
        $result.Facts['Configs'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
