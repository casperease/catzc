Describe 'Invoke-TestFile' -Tag 'L0', 'logic' {
    It 'throws on a missing test file before spawning anything' {
        { Invoke-TestFile (Join-Path $TestDrive 'nope.Tests.ps1') } | Should -Throw
    }
}

# L2: drives a real child pwsh worker through the same generator + runner chain as the harness.
Describe 'Invoke-TestFile (real worker)' -Tag 'L2', 'integrity' {
    BeforeAll {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }

        # The regression that motivated the function (ADR-TEST:25 parity): from an importer session the
        # top scope is strict, so a bare Invoke-Pester runs tests strict — a '<token>' It title throws at
        # Pester's name expansion and scalar .Count access throws. Through the worker chain the same file
        # must run green, exactly as it does under Test-Automation.
        $script:fixture = Join-Path $TestDrive 'StrictHostile.Tests.ps1'
        $fixtureContent = @'
Describe 'StrictHostile' -Tag 'L0', 'logic' {
    It 'has a template-looking <token> in its title' {
        $scalar = 'one'
        $scalar.Count | Should -Be 1
    }
    It 'is a second test the filter can exclude' {
        1 | Should -Be 1
    }
}
'@
        [System.IO.File]::WriteAllText($script:fixture, $fixtureContent)
    }

    It 'runs a strict-hostile test file green (the harness parity contract)' {
        $run = Invoke-TestFile $script:fixture -Output Minimal -PassThru
        $run.Result | Should -Be 'Passed' -Because 'the worker runs tests without strict mode, like every harness shard'
        $run.ExitCode | Should -Be 0
        @($run.Rows) | Should -HaveCount 2
    }

    It 'honours -FullNameFilter and returns the rows for just the matched test' {
        $run = Invoke-TestFile $script:fixture -FullNameFilter 'second test' -Output Minimal -PassThru
        $run.Result | Should -Be 'Passed'
        @($run.Rows | Where-Object Result -EQ 'Passed') | Should -HaveCount 1
    }

    It 'reports a failing file as Failed without throwing' {
        $failing = Join-Path $TestDrive 'Failing.Tests.ps1'
        [System.IO.File]::WriteAllText($failing, @'
Describe 'Failing' -Tag 'L0', 'logic' {
    It 'fails' { 1 | Should -Be 2 }
}
'@)
        $run = Invoke-TestFile $failing -Output Minimal -PassThru
        $run.Result | Should -Be 'Failed'
        $run.ExitCode | Should -Be 1
    }
}
