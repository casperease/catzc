Describe 'Write-TestResultMarker' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repository = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:output = Join-Path $script:repository 'out'
        $script:test = Join-Path $script:repository 'mods/Widget/tests/Get-Widget.Tests.ps1'
        $script:marker = Join-Path $script:output 'test-results/mods/Widget/tests/Get-Widget.Tests.ps1.failed'
        # Records one outcome of the widget test file the way Invoke-TestFile does.
        $script:record = {
            param([bool] $Failed, [switch] $KeepPassing)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Test = $script:test; Repository = $script:repository; Output = $script:output; Failed = $Failed; Keep = [bool] $KeepPassing } {
                param($Test, $Repository, $Output, $Failed, $Keep)
                $outcome = [pscustomobject]@{ Path = $Test; Failed = $Failed; FailedCount = [int] $Failed }
                Write-TestResultMarker -Outcome @($outcome) -RunDirectory 'run-widget' -KeepPassing:$Keep -RepositoryRoot $Repository -OutputRoot $Output
            }
        }
    }

    It 'writes the marker of a failing test file at its repository path under test-results' {
        $written = & $script:record $true
        $written | Should -Be $script:marker
        Get-Content -LiteralPath $script:marker -Raw | Should -Be "1 failed; run run-widget`n"
    }

    It 'deletes the marker once the file passes, and a passing file leaves none' {
        & $script:record $true | Out-Null
        @(& $script:record $false) | Should -HaveCount 0
        Test-Path -LiteralPath $script:marker | Should -BeFalse
        & $script:record $false | Out-Null
        Test-Path -LiteralPath $script:marker | Should -BeFalse -Because 'a re-passing file stays without a marker'
    }

    It 'keeps the marker when a filtered run passes, since it ran only some of the tests' {
        & $script:record $true | Out-Null
        & $script:record $false -KeepPassing | Out-Null
        Test-Path -LiteralPath $script:marker | Should -BeTrue
    }

    It 'writes no marker for a test file outside the repository' {
        $written = InModuleScope Catzc.Base.QualityGates -Parameters @{ Repository = $script:repository; Output = $script:output; Outside = (Join-Path $TestDrive 'elsewhere/Get-Gadget.Tests.ps1') } {
            param($Repository, $Output, $Outside)
            Write-TestResultMarker -Outcome @([pscustomobject]@{ Path = $Outside; Failed = $true; FailedCount = 1 }) -RunDirectory 'run-gadget' -RepositoryRoot $Repository -OutputRoot $Output
        }
        @($written) | Should -HaveCount 0
    }
}
