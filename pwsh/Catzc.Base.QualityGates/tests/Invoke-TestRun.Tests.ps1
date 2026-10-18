Describe 'Invoke-TestRun' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:testsDir = Join-Path $TestDrive 'widget/tests'
        [void][System.IO.Directory]::CreateDirectory($script:testsDir)
        $script:widgetFile = Join-Path $script:testsDir 'Get-Widget.Tests.ps1'
        $script:gadgetFile = Join-Path $script:testsDir 'Get-Gadget.Tests.ps1'
        [System.IO.File]::WriteAllText($script:widgetFile, '# fixture')
        [System.IO.File]::WriteAllText($script:gadgetFile, '# fixture')

        $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
        # The fields ConvertTo-TestAutomationRowSet reads too, as a discovery pass leaves them: never run.
        $newTest = {
            param([string] $File, [string] $Name, [string[]] $BlockTags)
            [pscustomobject]@{
                Tag          = @()
                Block        = [pscustomobject]@{ IsRoot = $false; Tag = @($BlockTags); Parent = $root }
                ExpandedPath = $Name
                ExpandedName = $Name
                Result       = 'NotRun'
                Duration     = [timespan]::Zero
                ScriptBlock  = [pscustomobject]@{ File = $File; StartPosition = [pscustomobject]@{ StartLine = 1 } }
            }
        }
        $script:discovery = [pscustomobject]@{
            Tests = @(
                (& $newTest $script:widgetFile 'Widget.reads files' @('L0', 'integrity', 'source-only'))
                (& $newTest $script:widgetFile 'Widget.runs code' @('L0', 'logic'))
                (& $newTest $script:gadgetFile 'Gadget.reads files' @('L1', 'integrity', 'source-only'))
            )
        }

        # The entry points pass their own limit; a test that does not care gives every phase the devbox one.
        function Invoke-Run {
            param([hashtable] $Arguments)
            if (-not $Arguments.ContainsKey('TimeoutSeconds')) {
                $Arguments['TimeoutSeconds'] = 360
            }
            InModuleScope Catzc.Base.QualityGates -Parameters @{ A = $Arguments } {
                param($A)
                Invoke-TestRun @A
            }
        }
    }

    BeforeEach {
        $script:outputFolder = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        Mock Get-TestAutomationTestPaths -ModuleName Catzc.Base.QualityGates { $script:testsDir }
        Mock Get-TestDiscovery -ModuleName Catzc.Base.QualityGates { $script:discovery }
        Mock Get-TestTagViolations -ModuleName Catzc.Base.QualityGates { , @() }
        Mock Select-ProtectedTestFile -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{
                ParallelFiles = @($ParallelFiles); GreedyFiles = @($GreedyFiles); SerialFiles = @($SerialFiles)
                ProtectedModules = @(); Candidates = @()
            }
        }
        Mock Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{
                Rows = @([pscustomobject]@{ Result = 'Passed'; Level = 'L0'; DurationMs = 1 }); Files = @()
                FailedShardLabels = @(); ShardExitCodes = @{}; DurationSeconds = 0.1; Shards = @(); WorkerSummaries = @(); Location = $null
            }
        }
        Mock Write-TestAutomationHeader -ModuleName Catzc.Base.QualityGates { }
        Mock Write-TestAutomationWorkerSummary -ModuleName Catzc.Base.QualityGates { }
        Mock Protect-TestedModule -ModuleName Catzc.Base.QualityGates { }
        Mock Write-TestAutomationTimingReport -ModuleName Catzc.Base.QualityGates { $false }
        Mock Write-TestAutomationArtifacts -ModuleName Catzc.Base.QualityGates { }
        Mock Get-TestAutomationVerdict -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Result = $RunResult; Summary = "verdict $RunResult" }
        }
        Mock Write-TestAutomationVerdict -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        # The location: in place by default; a test that needs a snapshot run sets the mode.
        $script:locationMode = 'in-place'
        Mock Enter-TestRunLocation -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{
                Mode = $script:locationMode; SourceRoot = 'C:\repo'; Root = 'C:\repo'; Mutex = $null; LockPath = $null; Holder = $null; Snapshot = $null
                KeepSandbox = $false; SystemTests = $script:locationMode -eq 'in-place'; SystemTestLock = $null; SystemTestHolder = $null
            }
        }
        Mock Exit-TestRunLocation -ModuleName Catzc.Base.QualityGates { }
    }

    Context 'the whole-run budget' {
        BeforeEach {
            # A green run of 200 s against a 180 s budget: only the budget can fail it.
            Mock Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates {
                [pscustomobject]@{
                    Rows = @([pscustomobject]@{ Result = 'Passed'; Level = 'L0'; DurationMs = 1 }); Files = @()
                    FailedShardLabels = @(); ShardExitCodes = @{}; DurationSeconds = $script:runSeconds; Shards = @(); WorkerSummaries = @(); Location = $null
                }
            }
            Mock Get-TestTimeLimits -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ LevelMs = @{}; RunSeconds = 180 } }
            Mock Get-TestAutomationVerdict -ModuleName Catzc.Base.QualityGates {
                $result = if ($BudgetFailure) {
                    'Failed'
                }
                else {
                    $RunResult
                }
                [pscustomobject]@{ Result = $result; Summary = "budget failure: $([bool] $BudgetFailure)" }
            }
            $script:runSeconds = 200
        }

        It 'fails a devbox run that outlasts its budget, and says so' {
            Mock Test-IsRunningInPipeline -ModuleName Catzc.Base.QualityGates { $false }

            { Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $false } } | Should -Throw '*budget failure: True*'
            Should -Invoke Get-TestAutomationVerdict -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $BudgetFailure -and $RunBudgetSeconds -eq 180 }
            Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like 'Run took 200*over its 180s budget*the run fails.' }
        }

        It 'leaves a pipeline run to its stage''s own limit' {
            Mock Test-IsRunningInPipeline -ModuleName Catzc.Base.QualityGates { $true }

            { Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $false } } | Should -Not -Throw
            Should -Invoke Get-TestAutomationVerdict -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { -not $BudgetFailure }
        }

        It 'passes a devbox run inside its budget' {
            Mock Test-IsRunningInPipeline -ModuleName Catzc.Base.QualityGates { $false }
            $script:runSeconds = 150

            { Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $false } } | Should -Not -Throw
        }
    }

    Context 'the location decides the top tier (ADR-AUTO-TEST-SYSTEMTESTSATLTHREE)' {
        It 'runs every tier, L3 included, in place by default' {
            Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $true } | Out-Null

            Should -Invoke Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $ExcludeTag -notcontains 'L3' -and $Location.Mode -eq 'in-place'
            }
            Should -Invoke Write-TestAutomationHeader -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $MaxLevel -eq 3 }
        }

        It 'skips L3 in a snapshot, says so, and records the level it ran' {
            $script:locationMode = 'snapshot'
            $summary = Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $true }

            Should -Invoke Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $ExcludeTag -contains 'L3' }
            Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like 'Skipping L3:*' }
            $manifest = Get-Content -LiteralPath (Join-Path $summary.RunDirectory 'run.json') -Raw | ConvertFrom-Json
            $manifest.maxLevel | Should -Be 2
            $manifest.context.location | Should -Be 'snapshot'
            $manifest.context.tiersRequested | Should -Be 'L0-L3'
            $manifest.context.tiersRunning | Should -Be 'L0-L2'
            $manifest.context.tierCap | Should -Be 'L3 skipped: snapshot location'
            Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like '  tiers *asked L0-L3 · running L0-L2*' }
        }

        It 'names a test suite in the context it records' -Tag 'ADR-AUTO-TEST-TESTSUITE' {
            $summary = Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $true; Suite = 'widget'; Modules = @('TstWidget') }
            $manifest = Get-Content -LiteralPath (Join-Path $summary.RunDirectory 'run.json') -Raw | ConvertFrom-Json
            $manifest.context.selection | Should -Be 'suite widget; modules: TstWidget'
            $manifest.context.run | Should -Be 'source'
            $manifest.context.entryPoint | Should -Be 'Test-Automation'
        }

        It 'keeps an explicit lower level as given' {
            Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $true; MaxLevel = 1 } | Out-Null

            Should -Invoke Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $ExcludeTag -contains 'L2' -and $ExcludeTag -contains 'L3'
            }
        }

        It 'refuses an L3-only run in a snapshot, and still releases the location' {
            $script:locationMode = 'snapshot'
            { Invoke-Run @{ OutputFolder = $script:outputFolder; MinLevel = 3 } } | Should -Throw '*snapshot, which skips L3*'
            Should -Invoke Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates -Times 0
            Should -Invoke Exit-TestRunLocation -ModuleName Catzc.Base.QualityGates -Times 1
        }

        It 'releases the location after a normal run' {
            Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $true } | Out-Null
            Should -Invoke Exit-TestRunLocation -ModuleName Catzc.Base.QualityGates -Times 1
        }
    }

    # The fixture's widget file holds only L0 tests and gadget one L1 test, so a run from L1 up has nothing in widget.
    Context 'the tier and category scope keeps out-of-scope files from the workers' {
        It 'sends only the files holding an in-scope test to the workers' {
            Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $true; MinLevel = 1 } | Out-Null

            Should -Invoke Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                (@($ParallelFiles) -join ',') -eq $script:gadgetFile
            }
        }

        It 'reports the dropped file''s tests as NotRun rows, exactly once' {
            Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $true; MinLevel = 1 } | Out-Null

            Should -Invoke Write-TestAutomationArtifacts -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $notRun = @($Rows | Where-Object { $_.Result -eq 'NotRun' })
                $notRun.Count -eq 2 -and
                (@($notRun.ExpandedPath) -join ',') -eq 'Widget.reads files,Widget.runs code' -and
                @($notRun | Where-Object { $_.Level -eq 'L0' }).Count -eq 2 -and
                @($Rows | Where-Object { $_.Result -eq 'Passed' }).Count -eq 1
            }
        }

        It 'promotes protection from the workers'' rows only' {
            Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $true; MinLevel = 1 } | Out-Null

            Should -Invoke Protect-TestedModule -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                @($Rows | Where-Object { $_.Result -eq 'NotRun' }).Count -eq 0
            }
        }

        It 'says no test is in scope and runs no worker when no file holds one' {
            Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $true; MinLevel = 3; MaxLevel = 3 } | Out-Null

            Should -Invoke Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates -Times 0
            Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $Message -eq 'No test in scope at L3-L3 — nothing to run.'
            }
            Should -Invoke Write-TestAutomationArtifacts -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                @($Rows | Where-Object { $_.Result -eq 'NotRun' }).Count -eq 3
            }
        }
    }

    Context 'the source run (no opt-out tag, default entry script)' {
        It 'runs every file through the default importer and excludes nothing beyond the tier/category filter' -Tag 'ADR-AUTO-TEST-ALLTESTS' {
            $summary = Invoke-Run @{ OutputFolder = $script:outputFolder; PassThru = $true }

            Should -Invoke Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $ExcludeTag -notcontains 'source-only' -and -not $EntryScript -and
                @($ParallelFiles).Count -eq 2
            }
            Should -Invoke Write-TestAutomationHeader -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $Title -eq 'Test Automation'
            }
            $summary.ExcludedTests.Count | Should -Be 0
            [System.IO.File]::Exists((Join-Path $summary.RunDirectory 'excluded-tests.csv')) | Should -BeFalse
        }
    }

    Context 'the build run (source-only opt-out, build entry script)' -Tag 'ADR-AUTO-TEST-SAMETESTSBOTHRUNS', 'ADR-AUTO-TEST-SOURCEONLYTAG' {
        BeforeAll {
            $script:buildArguments = @{
                EntryPoint     = 'Test-CatzcBuild'
                Title          = 'Catzc Build Run'
                OptOutTag      = @('source-only')
                EntryScript    = 'C:\build\Catzc\6.6.666\Import-Catzc.ps1'
                EntryParameter = @{ RepositoryRoot = 'C:\repo' }
                PassThru       = $true
            }
        }

        It 'excludes the tag, drops fully excluded files, and swaps the entry script' {
            $arguments = $script:buildArguments.Clone()
            $arguments['OutputFolder'] = $script:outputFolder
            Invoke-Run $arguments | Out-Null

            Should -Invoke Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $ExcludeTag -contains 'source-only' -and
                $EntryScript -eq 'C:\build\Catzc\6.6.666\Import-Catzc.ps1' -and
                $EntryParameter['RepositoryRoot'] -eq 'C:\repo' -and
                (@($ParallelFiles) -join ',') -eq $script:widgetFile
            }
        }

        It 'counts and lists every excluded test in the summary, excluded-tests.csv, and run.json' {
            $arguments = $script:buildArguments.Clone()
            $arguments['OutputFolder'] = $script:outputFolder
            $summary = Invoke-Run $arguments

            @($summary.ExcludedTests.ExpandedPath) | Should -Be @('Widget.reads files', 'Gadget.reads files')
            $csv = @(Import-Csv -LiteralPath (Join-Path $summary.RunDirectory 'excluded-tests.csv'))
            @($csv.ExpandedPath) | Should -Be @('Widget.reads files', 'Gadget.reads files')
            $manifest = Get-Content -LiteralPath (Join-Path $summary.RunDirectory 'run.json') -Raw | ConvertFrom-Json
            $manifest.optOutExcludedCount | Should -Be 2
            Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter {
                $Message -like "2 test(s) in 2 file(s) excluded by 'source-only'*"
            }
        }

        It 'writes its reports under the run''s own folder by default' -Tag 'ADR-AUTO-TEST-TESTRUN' {
            Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
            $summary = Invoke-Run $script:buildArguments

            $summary.RunDirectory | Should -BeLike (Join-Path $TestDrive 'test-catzc-build*')
            Should -Invoke Write-TestAutomationHeader -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $Title -eq 'Catzc Build Run'
            }
        }

        It 'keys protection on the run, so a green source run never skips the build run' {
            $arguments = $script:buildArguments.Clone()
            $arguments['OutputFolder'] = $script:outputFolder
            Invoke-Run $arguments | Out-Null

            Should -Invoke Select-ProtectedTestFile -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $ProtectionKey -like 'test-catzc-build|*'
            }
        }

        It 'names the entry point when the run fails' {
            Mock Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates {
                [pscustomobject]@{
                    Rows = @([pscustomobject]@{ Result = 'Failed'; Level = 'L0'; DurationMs = 1; ExpandedPath = 'Widget.fits'; ErrorMessage = 'gadget too wide' }); Files = @()
                    FailedShardLabels = @('shard-0'); ShardExitCodes = @{}; DurationSeconds = 0.1; Shards = @(); WorkerSummaries = @(); Location = $null
                }
            }
            Mock Write-TestRunFailures -ModuleName Catzc.Base.QualityGates { }
            $arguments = $script:buildArguments.Clone()
            $arguments['OutputFolder'] = $script:outputFolder
            $arguments['PassThru'] = $false

            { Invoke-Run $arguments } | Should -Throw 'Test-CatzcBuild failed*'
            Should -Invoke Write-TestRunFailures -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
                @($Rows).Count -eq 1 -and $Rows[0].ErrorMessage -eq 'gadget too wide'
            }
        }
    }
}
