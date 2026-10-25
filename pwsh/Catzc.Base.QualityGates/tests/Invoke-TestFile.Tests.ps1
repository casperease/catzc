<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-TestFile.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Invoke-TestFile' -Tag 'L0', 'logic' {
    BeforeAll {
        # The seams every case below shares, mocked once; a case that differs re-mocks its own.
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Enter-TestRunLocation -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Mode = 'in-place' } }
        Mock Exit-TestRunLocation -ModuleName Catzc.Base.QualityGates { }
        Mock Get-TestRunLocationEntry -ModuleName Catzc.Base.QualityGates { @{} }
        Mock Get-LanguageTestExecutable -ModuleName Catzc.Base.QualityGates { @{} }
        Mock Convert-TestRunLocationPath -ModuleName Catzc.Base.QualityGates { $Path }
        # The shard script is the last stop before a real worker spawns: stop there.
        Mock New-TestAutomationShardScript -ModuleName Catzc.Base.QualityGates { throw 'stop before spawning' }
    }

    It 'throws on a missing test file before spawning anything' {
        { Invoke-TestFile (Join-Path $TestDrive 'nope.Tests.ps1') } | Should -Throw
    }

    It 'hands -FullNameFilter to the worker''s shard script' {
        $testFile = Join-Path $TestDrive 'widget.Tests.ps1'
        [System.IO.File]::WriteAllText($testFile, '')
        Mock Resolve-TestRunMaxLevel -ModuleName Catzc.Base.QualityGates { 3 }

        { Invoke-TestFile $testFile -FullNameFilter 'widget''s gadget' } | Should -Throw '*stop before spawning*'

        Should -Invoke New-TestAutomationShardScript -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $FullNameFilter -eq 'widget''s gadget'
        }
        Should -Invoke Exit-TestRunLocation -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'leaves out the opt-in L4 tests by default, and runs them with -MaxLevel 4 (<maxLevel>)' -ForEach @(
        @{ maxLevel = 3; expected = @('L4') }
        @{ maxLevel = 4; expected = @() }
    ) {
        $testFile = Join-Path $TestDrive 'gadget.Tests.ps1'
        [System.IO.File]::WriteAllText($testFile, '')
        Mock Enter-TestRunLocation -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Mode = 'in-place'; SystemTests = $true } }

        { Invoke-TestFile $testFile -MaxLevel $maxLevel } | Should -Throw '*stop before spawning*'

        $expectedTags = $expected
        Should -Invoke New-TestAutomationShardScript -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            "$($ExcludeTag -join ',')" -eq "$($expectedTags -join ',')"
        }
    }

    It 'stamps run.json crashed when the run fails before its worker starts' {
        $testFile = Join-Path $TestDrive 'gizmo.Tests.ps1'
        [System.IO.File]::WriteAllText($testFile, '')
        $outputRoot = Join-Path $TestDrive 'crashed-run'
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { $outputRoot }
        Mock Resolve-TestRunMaxLevel -ModuleName Catzc.Base.QualityGates { 3 }

        { Invoke-TestFile $testFile } | Should -Throw '*stop before spawning*'

        # A run folder holds its manifest directly, one level below test-file; the third level is headroom.
        $manifests = @(Get-ChildPath (Join-Path $outputRoot 'test-file') -File -Filter 'run.json' -Depth 3)
        $manifests | Should -HaveCount 1
        ([System.IO.File]::ReadAllText($manifests[0]) | ConvertFrom-Json).status | Should -Be 'crashed'
    }
}

Describe 'Invoke-TestFile (real worker)' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }

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
    It 'is a plain passing test' {
        1 | Should -Be 1
    }
}
'@
        [System.IO.File]::WriteAllText($script:fixture, $fixtureContent)
    }

    It 'runs tests strict, and an It-level opt-out runs that test non-strict (the harness parity contract)' {
        { $script:run = Invoke-TestFile $script:fixture -Output Minimal -PassThru } | Should -Not -Throw -Because 'a failing file is a result, not an error'
        $run = $script:run
        $run.Result | Should -Be 'Failed' -Because 'the worker runs tests strict, like every harness shard'
        $run.ExitCode | Should -Be 1
        @($run.Rows) | Should -HaveCount 3
        @($run.Rows | Where-Object ExpandedName -EQ 'reads Count on a scalar without opting out').Result | Should -Be 'Failed'
        @($run.Rows | Where-Object ExpandedName -EQ 'reads Count on a scalar behind an It-level opt-out').Result | Should -Be 'Passed'
    }

    # A file that throws while Pester discovers it holds no test, so it yields no row; the run must still fail.
    It 'fails the run when a test file throws during discovery, though it yields no row' {
        $broken = Join-Path $TestDrive 'Broken.Tests.ps1'
        [System.IO.File]::WriteAllText($broken, "Describe 'Broken' -Tag 'L0', 'logic' {`n    throw 'widget discovery broke'`n    It 'never runs' { }`n}`n")
        $run = Invoke-TestFile $broken -Output Minimal -PassThru
        $run.Result | Should -Be 'Failed'
        $run.ExitCode | Should -Be 1
        @($run.Rows) | Should -HaveCount 0
        ([System.IO.File]::ReadAllText((Join-Path $run.RunDirectory 'run.json')) | ConvertFrom-Json).status | Should -Be 'failed'
    }

    It 'prints the error of a failed BeforeAll in its summary, so a test its setup never ran names the cause' {
        $setup = Join-Path $TestDrive 'Setup.Tests.ps1'
        [System.IO.File]::WriteAllText($setup, "Describe 'Setup' -Tag 'L0', 'logic' {`n    BeforeAll { throw 'widget setup broke' }`n    It 'never runs' { 1 | Should -Be 1 }`n}`n")
        $run = Invoke-TestFile $setup -Output Minimal -PassThru
        $run.Result | Should -Be 'Failed'
        $run.Rows | Select-Object -First 1 -ExpandProperty ErrorMessage | Should -BeLike '*widget setup broke*'
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { "$Message" -like '*widget setup broke*' }
    }

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
            (Get-CatzcModuleRoot 'tests/Convert-TestRunLocationPath.Tests.ps1' -Module Catzc.Base.QualityGates))

        $run = Invoke-TestFile $fixture, $repositoryTest -Isolated -Output Minimal -PassThru

        $run.Result | Should -Be 'Passed'
        $run.Location | Should -Be 'snapshot'
        $run.RunDirectory | Should -BeLike "$(Get-OutputRoot)*" -Because 'the report lands in the working folder''s out/'
        $observation = [System.IO.File]::ReadAllText($probe) | ConvertFrom-Json
        $observation.Root | Should -BeLike '*catzc-run-*'
        $observation.ModuleBase | Should -BeLike "$($observation.Root)*" -Because 'the worker loads the snapshot''s modules, not the working folder''s'
        [System.IO.Directory]::Exists($observation.Root) | Should -BeFalse -Because 'the snapshot is removed after the run'
        $manifest = [System.IO.File]::ReadAllText((Join-Path $run.RunDirectory 'run.json')) | ConvertFrom-Json
        $manifest.status | Should -Be 'passed'
        $manifest.location | Should -Be 'snapshot' -Because 'the run.json a reader finds at home names where the run executed'
        $manifest.snapshot.path | Should -Be $observation.Root
        $manifest.snapshot.kept | Should -BeFalse
        [System.IO.File]::Exists($systemProbe) | Should -BeFalse -Because 'a snapshot run skips the L3 system tests'
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like 'Skipping L3:*' }
        @($run.Rows | Where-Object File -EQ $repositoryTest).Count | Should -BeGreaterThan 0 -Because 'row paths map back to the working folder'
    }
}
