Describe 'Invoke-TestFile' -Tag 'L0', 'logic' {
    It 'throws on a missing test file before spawning anything' {
        { Invoke-TestFile (Join-Path $TestDrive 'nope.Tests.ps1') } | Should -Throw
    }
}

# L2: drives a real child pwsh worker through the same generator + runner chain as the harness.
# greedy: each It spawns a full importer-loading pwsh worker — stacked on the parallel pool that
# oversubscribes the box (see the test-automation ADR's greedy tag).
Describe 'Invoke-TestFile (real worker)' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }

        # The strict contract (ADR-AUTO-TEST:25): the worker runs every test strict, and a test that genuinely
        # needs non-strict semantics opts out locally, in its own It body. The fixture holds the same strict-hostile
        # read (.Count on a scalar) twice — bare, and behind the opt-out — plus a plain test for the filter.
        $script:fixture = Join-Path $TestDrive 'StrictHostile.Tests.ps1'
        $fixtureContent = @'
Describe 'StrictHostile' -Tag 'L0', 'logic' {
    It 'reads Count on a scalar without opting out' {
        $scalar = 'one'
        $scalar.Count | Should -Be 1
    }
    It 'reads Count on a scalar behind an It-level opt-out' {
        # non-strict IS the behaviour under test here: scalar .Count
        Set-StrictMode -Off
        $scalar = 'one'
        $scalar.Count | Should -Be 1
    }
    It 'is a plain test the filter can isolate' {
        1 | Should -Be 1
    }
}
'@
        [System.IO.File]::WriteAllText($script:fixture, $fixtureContent)
    }

    It 'runs tests strict, and an It-level opt-out runs that test non-strict (the harness parity contract)' {
        $run = Invoke-TestFile $script:fixture -Output Minimal -PassThru
        $run.Result | Should -Be 'Failed' -Because 'the worker runs tests strict, like every harness shard'
        $run.ExitCode | Should -Be 1
        @($run.Rows) | Should -HaveCount 3
        @($run.Rows | Where-Object ExpandedName -EQ 'reads Count on a scalar without opting out').Result | Should -Be 'Failed'
        @($run.Rows | Where-Object ExpandedName -EQ 'reads Count on a scalar behind an It-level opt-out').Result | Should -Be 'Passed'
    }

    It 'honours -FullNameFilter and returns the rows for just the matched test' {
        $run = Invoke-TestFile $script:fixture -FullNameFilter 'plain test' -Output Minimal -PassThru
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

    # The walking skeleton of the snapshot path (ADR-AUTO-TEST:32): a real snapshot, primed, a real worker
    # loading it. -Isolated takes the path deterministically; when it is taken because another run holds the
    # working folder is Enter-TestRunSlot's L0 concern.
    # The fixture also carries an L3 block, so the same worker spawn proves a snapshot skips the vertical system
    # tests (Resolve-TestRunMaxLevel, ADR-AUTO-TEST:33).
    It 'runs in a snapshot: the worker loads the snapshot, the report and the rows come home, the snapshot is removed' {
        Mock Write-Message -ModuleName Catzc.Base.Git { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        $probe = Join-Path $TestDrive 'probe.json'
        $systemProbe = Join-Path $TestDrive 'system-probe.txt'
        $fixture = Join-Path $TestDrive 'Probe.Tests.ps1'
        [System.IO.File]::WriteAllText($fixture, @"
Describe 'Probe' -Tag 'L0', 'logic' {
    It 'records the root it runs in' {
        `$observation = @{ Root = (Get-RepositoryRoot); ModuleBase = (Get-Module Catzc.Base.Git).ModuleBase }
        [System.IO.File]::WriteAllText('$probe', (ConvertTo-Json -InputObject `$observation))
    }
}
Describe 'SystemProbe' -Tag 'L3', 'logic' {
    It 'would change state outside the repository' {
        [System.IO.File]::WriteAllText('$systemProbe', 'ran')
    }
}
"@)
        $repositoryTest = [System.IO.Path]::GetFullPath(
            (Join-Path (Get-RepositoryRoot) 'automation/Catzc.Base.QualityGates/tests/Convert-TestRunSlotPath.Tests.ps1'))

        $run = Invoke-TestFile $fixture, $repositoryTest -Isolated -Output Minimal -PassThru

        $run.Result | Should -Be 'Passed'
        $run.Location | Should -Be 'snapshot'
        $run.RunDirectory | Should -BeLike "$(Get-OutputRoot)*" -Because 'the report lands in the working folder''s out/'
        $observation = [System.IO.File]::ReadAllText($probe) | ConvertFrom-Json
        $observation.Root | Should -BeLike '*catzc-run-*'
        $observation.ModuleBase | Should -BeLike "$($observation.Root)*" -Because 'the worker loads the snapshot''s modules, not the working folder''s'
        [System.IO.Directory]::Exists($observation.Root) | Should -BeFalse -Because 'the snapshot is removed after the run'
        [System.IO.File]::Exists($systemProbe) | Should -BeFalse -Because 'a snapshot run skips the L3 system tests'
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like 'Skipping L3:*' }
        @($run.Rows | Where-Object File -EQ $repositoryTest).Count | Should -BeGreaterThan 0 -Because 'row paths map back to the working folder'
    }
}
