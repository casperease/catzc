Describe 'Invoke-TestAutomationSuite' -Tag 'L0', 'logic' {
    BeforeAll {
        # A fixture tests/ folder with two files: widget mixes a source-only test with a runnable one; gadget is
        # source-only throughout. Discovery is faked over them (the Pester test shape Get-TestBlockTag walks).
        $script:testsDir = Join-Path $TestDrive 'widget/tests'
        [void][System.IO.Directory]::CreateDirectory($script:testsDir)
        $script:widgetFile = Join-Path $script:testsDir 'Get-Widget.Tests.ps1'
        $script:gadgetFile = Join-Path $script:testsDir 'Get-Gadget.Tests.ps1'
        [System.IO.File]::WriteAllText($script:widgetFile, '# fixture')
        [System.IO.File]::WriteAllText($script:gadgetFile, '# fixture')

        $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
        $newTest = {
            param([string] $File, [string] $Name, [string[]] $BlockTags)
            [pscustomobject]@{
                Tag          = @()
                Block        = [pscustomobject]@{ IsRoot = $false; Tag = @($BlockTags); Parent = $root }
                ExpandedPath = $Name
                ScriptBlock  = [pscustomobject]@{ File = $File }
            }
        }
        $script:discovery = [pscustomobject]@{
            Tests = @(
                (& $newTest $script:widgetFile 'Widget.reads files' @('L0', 'integrity', 'source-only'))
                (& $newTest $script:widgetFile 'Widget.runs code' @('L0', 'logic'))
                (& $newTest $script:gadgetFile 'Gadget.reads files' @('L1', 'integrity', 'source-only'))
            )
        }

        function Invoke-Suite {
            param([hashtable] $Arguments)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ A = $Arguments } {
                param($A)
                Invoke-TestAutomationSuite @A
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
                Rows = @([pscustomobject]@{ Result = 'Passed'; Level = 'L0'; DurationMs = 1 })
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
    }

    Context 'the source suite (no opt-out tag, default entry script)' {
        It 'runs every file through the default importer and excludes nothing beyond the tier/category filter' {
            $summary = Invoke-Suite @{ OutputFolder = $script:outputFolder; PassThru = $true }

            Should -Invoke Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $ExcludeTag -notcontains 'source-only' -and -not $EntryScript -and
                @($ParallelFiles).Count -eq 2
            }
            Should -Invoke Write-TestAutomationHeader -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $Title -eq 'Test Automation'
            }
            $summary.PSObject.Properties['ExcludedTests'] | Should -BeNullOrEmpty
            Get-ChildItem -LiteralPath $summary.RunDirectory -Filter 'excluded-tests.csv' | Should -BeNullOrEmpty
        }
    }

    Context 'the build suite (source-only opt-out, build entry script)' -Tag 'ADR-AUTO-TEST#30', 'ADR-AUTO-TEST#31' {
        BeforeAll {
            $script:buildArguments = @{
                Suite           = 'Test-CatzcBuild'
                Title           = 'Catzc Build Suite'
                SuiteExcludeTag = @('source-only')
                EntryScript     = 'C:\build\Catzc\6.6.666\Import-Catzc.ps1'
                EntryParameter  = @{ RepositoryRoot = 'C:\repo' }
                PassThru        = $true
            }
        }

        It 'excludes the tag, drops fully excluded files, and swaps the entry script' {
            $arguments = $script:buildArguments.Clone()
            $arguments['OutputFolder'] = $script:outputFolder
            Invoke-Suite $arguments | Out-Null

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
            $summary = Invoke-Suite $arguments

            @($summary.ExcludedTests.ExpandedPath) | Should -Be @('Widget.reads files', 'Gadget.reads files')
            $csv = @(Import-Csv -LiteralPath (Join-Path $summary.RunDirectory 'excluded-tests.csv'))
            @($csv.ExpandedPath) | Should -Be @('Widget.reads files', 'Gadget.reads files')
            $manifest = Get-Content -LiteralPath (Join-Path $summary.RunDirectory 'run.json') -Raw | ConvertFrom-Json
            $manifest.suiteExcludedCount | Should -Be 2
            Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter {
                $Message -like "2 test(s) in 2 file(s) excluded by 'source-only'*"
            }
        }

        It 'writes its reports under the suite''s own folder by default' {
            Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
            $summary = Invoke-Suite $script:buildArguments

            $summary.RunDirectory | Should -BeLike (Join-Path $TestDrive 'test-catzc-build*')
            Should -Invoke Write-TestAutomationHeader -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $Title -eq 'Catzc Build Suite'
            }
        }

        It 'keys protection on the suite, so a source-suite green never skips the build suite' {
            $arguments = $script:buildArguments.Clone()
            $arguments['OutputFolder'] = $script:outputFolder
            Invoke-Suite $arguments | Out-Null

            Should -Invoke Select-ProtectedTestFile -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $ProtectionKey -like 'test-catzc-build|*'
            }
        }

        It 'names the suite when the run fails' {
            Mock Invoke-TestAutomationWorkers -ModuleName Catzc.Base.QualityGates {
                [pscustomobject]@{
                    Rows = @([pscustomobject]@{ Result = 'Failed'; Level = 'L0'; DurationMs = 1 })
                    FailedShardLabels = @('shard-0'); ShardExitCodes = @{}; DurationSeconds = 0.1; Shards = @(); WorkerSummaries = @(); Location = $null
                }
            }
            $arguments = $script:buildArguments.Clone()
            $arguments['OutputFolder'] = $script:outputFolder
            $arguments['PassThru'] = $false

            { Invoke-Suite $arguments } | Should -Throw 'Test-CatzcBuild failed*'
        }
    }
}
