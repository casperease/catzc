Describe 'Write-TestResultMarker' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repository = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:output = Join-Path $script:repository 'out'
        $script:test = Join-Path $script:repository 'mods/Widget/tests/Get-Widget.Tests.ps1'
        $script:result = Join-Path $script:output 'test-results/mods/Widget/tests/Get-Widget.Tests.ps1.result.json'
        # Records one outcome of the widget test file; the scope is the run's, the default being L0-L2 unfiltered.
        $script:record = {
            param([bool] $Failed, [hashtable] $Scope = @{})
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Test = $script:test; Repository = $script:repository; Output = $script:output; Failed = $Failed; Scope = $Scope } {
                param($Test, $Repository, $Output, $Failed, $Scope)
                $outcome = [pscustomobject]@{ Path = $Test; Failed = $Failed; FailedCount = [int] $Failed }
                Write-TestResultMarker -Outcome @($outcome) -RunDirectory 'run-widget' -Runner 'Invoke-TestFile' -StartedAt '2026-10-30T10:00:00.0000000+00:00' `
                    -RepositoryRoot $Repository -OutputRoot $Output @Scope
            }
        }
        $script:read = { Get-Content -LiteralPath $script:result -Raw | ConvertFrom-Json }
    }

    It 'writes the failing file result at its repository path under test-results, with every field' {
        $written = & $script:record $true @{ MinLevel = 0; MaxLevel = 3; Category = 'Logic'; Isolated = $true }
        $written | Should -Be $script:result
        $json = & $script:read
        $json.result | Should -Be 'failed'
        $json.failedCount | Should -Be 1
        # ConvertFrom-Json reads the ISO text as a date; the instant is what matters.
        ([DateTimeOffset] $json.startedAt).ToUnixTimeSeconds() | Should -Be ([DateTimeOffset]::new(2026, 10, 30, 10, 0, 0, [TimeSpan]::Zero)).ToUnixTimeSeconds()
        $json.runner | Should -Be 'Invoke-TestFile'
        $json.pid | Should -Be $PID
        $json.isolated | Should -BeTrue
        $json.runDirectory | Should -Be 'run-widget'
        $json.scope.minLevel | Should -Be 0
        $json.scope.maxLevel | Should -Be 3
        $json.scope.category | Should -Be 'Logic'
        $json.scope.filtered | Should -BeFalse
        @($json.scope.rule) | Should -HaveCount 0
    }

    It 'records the rule of the run in the scope' {
        & $script:record $true @{ Rule = @('widget-rule'); Filtered = $true } | Out-Null
        $json = & $script:read
        @($json.scope.rule) | Should -Be @('widget-rule')
        $json.scope.filtered | Should -BeTrue
    }

    It 'replaces the failure with a passed result when a pass covers its scope, and leaves no temporary file' {
        & $script:record $true @{ MaxLevel = 2 } | Out-Null
        & $script:record $false @{ MaxLevel = 3 } | Out-Null
        (& $script:read).result | Should -Be 'passed'
        @(Get-ChildPath -Path (Split-Path $script:result) -Depth 1 -File -Filter '*.tmp') | Should -HaveCount 0
    }

    It 'keeps the failure when a pass is narrower than the failed run' {
        & $script:record $true @{ MaxLevel = 3 } | Out-Null
        & $script:record $false @{ MaxLevel = 2 } | Out-Null
        (& $script:read).result | Should -Be 'failed'
        & $script:record $false @{ MinLevel = 1; MaxLevel = 3 } | Out-Null
        (& $script:read).result | Should -Be 'failed' -Because 'a pass from L1 says nothing of L0'
        & $script:record $true @{ Category = 'Both' } | Out-Null
        & $script:record $false @{ Category = 'Logic' } | Out-Null
        (& $script:read).result | Should -Be 'failed' -Because 'a pass of one category says nothing of the other'
    }

    It 'writes no result for a filtered pass, since it ran only some of the tests' {
        & $script:record $false @{ Filtered = $true } | Out-Null
        Test-Path -LiteralPath $script:result | Should -BeFalse
        & $script:record $true | Out-Null
        & $script:record $false @{ Filtered = $true } | Out-Null
        (& $script:read).result | Should -Be 'failed'
    }

    It 'treats an unreadable stored result as no result' {
        [void][System.IO.Directory]::CreateDirectory((Split-Path $script:result))
        Set-Content -LiteralPath $script:result -Value '{ broken'
        & $script:record $false | Out-Null
        (& $script:read).result | Should -Be 'passed'
    }

    It 'writes no result for a test file outside the repository' {
        $written = InModuleScope Catzc.Base.QualityGates -Parameters @{ Repository = $script:repository; Output = $script:output; Outside = (Join-Path $TestDrive 'elsewhere/Get-Gadget.Tests.ps1') } {
            param($Repository, $Output, $Outside)
            Write-TestResultMarker -Outcome @([pscustomobject]@{ Path = $Outside; Failed = $true; FailedCount = 1 }) -RunDirectory 'run-gadget' `
                -Runner 'Test-Automation' -StartedAt '2026-10-30T10:00:00.0000000+00:00' -RepositoryRoot $Repository -OutputRoot $Output
        }
        @($written) | Should -HaveCount 0
    }
}
