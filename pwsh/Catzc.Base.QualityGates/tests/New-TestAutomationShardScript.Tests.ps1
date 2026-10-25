<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/New-TestAutomationShardScript.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'New-TestAutomationShardScript' {
    Context 'script generation' -Tag 'L0', 'logic' {
        BeforeAll {
            $script:runDirectory = Join-Path $TestDrive 'run'
            [void][System.IO.Directory]::CreateDirectory($script:runDirectory)

            $script:shard = InModuleScope Catzc.Base.QualityGates -Parameters @{
                Dir = $script:runDirectory
            } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 3 `
                    -TestPath @('C:\repo\a.Tests.ps1', 'C:\repo\b.Tests.ps1') `
                    -RunDirectory $Dir -ExcludeTag @('L2', 'L3') -Verbosity Normal
            }
            $script:content = Get-Content -LiteralPath $script:shard.ScriptPath -Raw
        }

        It 'returns the shard descriptor with index-derived paths' {
            $script:shard.ShardIndex | Should -Be 3
            $script:shard.Label | Should -Be 'shard-3'
            $script:shard.ScriptPath | Should -Be (Join-Path $script:runDirectory 'shard-3.ps1')
            $script:shard.ResultsPath | Should -Be (Join-Path $script:runDirectory 'results-shard-3.xml')
            $script:shard.RowsPath | Should -Be (Join-Path $script:runDirectory 'rows-shard-3.json')
            $script:shard.FilesPath | Should -Be (Join-Path $script:runDirectory 'files-shard-3.json')
            $script:shard.ScriptPath | Should -Exist
        }

        It 'imports the repository, runs the shard files, and writes the run artifacts' {
            $script:content | Should -Match ([regex]::Escape("importer.ps1' -SkipJanitors"))
            # Pester is resolved inside the worker, after its import, from the worker's own code root.
            $script:content | Should -Match ([regex]::Escape("Join-Path (Get-CatzcModulesRoot) '.vendor/Pester'"))
            $script:content | Should -Match ([regex]::Escape("@('C:\repo\a.Tests.ps1', 'C:\repo\b.Tests.ps1')"))
            $script:content | Should -Match ([regex]::Escape("'Normal'"))
            $script:content | Should -Match ([regex]::Escape($script:shard.ResultsPath))
            $script:content | Should -Match ([regex]::Escape($script:shard.RowsPath))
            $script:content | Should -Match 'ConvertTo-TestAutomationRowSet'
            $script:content | Should -Match ([regex]::Escape($script:shard.FilesPath))
            $script:content | Should -Match ([regex]::Escape('$result.Containers'))
        }

        It 'builds its configuration through the one shared builder, strict on' {
            $script:content | Should -Match 'New-PesterRunConfiguration'
            $script:content | Should -Match ([regex]::Escape('Set-StrictMode -Version Latest'))
            $script:content | Should -Not -Match ([regex]::Escape('Set-StrictMode -Off'))
        }

        It 'watches its parent once the modules are loaded, before Pester runs' {
            $entry = $script:content.IndexOf("importer.ps1' -SkipJanitors")
            $watch = $script:content.IndexOf('[Catzc.Base.QualityGates.WorkerParentWatch]::Start(')
            $pester = $script:content.IndexOf('Invoke-Pester')
            $watch | Should -BeGreaterThan $entry
            $watch | Should -BeLessThan $pester
        }

        It 'carries the exclude tags and exits with the not-passed flag' {
            $script:content | Should -Match ([regex]::Escape("@('L2', 'L3')"))
            $script:content | Should -Match ([regex]::Escape('exit ([int]($result.Result -ne ''Passed''))'))
        }

        It 'passes empty exclude and include tag literals when neither is given' {
            $bare = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 4 -TestPath @('C:\repo\a.Tests.ps1') -RunDirectory $Dir
            }
            # order: @(paths) @(excludeTag) @(includeTag) 'Verbosity' — both tag literals empty here.
            (Get-Content -LiteralPath $bare.ScriptPath -Raw) | Should -Match ([regex]::Escape("@() @() 'Detailed'"))
        }

        It 'threads the -Rule include tags into the worker configuration' {
            $ruled = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 5 -TestPath @('C:\repo\a.Tests.ps1') -RunDirectory $Dir `
                    -ExcludeTag @('L3') -IncludeTag @('ADR-FAKE-TURN')
            }
            $content = Get-Content -LiteralPath $ruled.ScriptPath -Raw
            $content | Should -Match ([regex]::Escape("@('L3') @('ADR-FAKE-TURN')"))
            $content | Should -Match ([regex]::Escape('-IncludeTag $includeTag'))
        }

        It 'threads -FullNameFilter into the worker configuration, apostrophes doubled' {
            $filtered = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 6 -TestPath @('C:\repo\a.Tests.ps1') -RunDirectory $Dir `
                    -FullNameFilter "widget's gadget"
            }
            $content = Get-Content -LiteralPath $filtered.ScriptPath -Raw
            $content | Should -Match ([regex]::Escape("'widget''s gadget'"))
            $content | Should -Match ([regex]::Escape('-FullNameFilter $fullNameFilter'))
        }

        It 'loads the source run through the repository importer by default' {
            $script:content | Should -Match ([regex]::Escape(". '$(Get-RepositoryRoot)/importer.ps1' -SkipJanitors"))
            $script:content | Should -Not -Match 'Import-Catzc'
        }

        It 'loads the build run through the given entry script with its named arguments' {
            $built = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 6 -TestPath @('C:\repo\a.Tests.ps1') -RunDirectory $Dir `
                    -EntryScript "C:\build's\Catzc\6.6.666\Import-Catzc.ps1" `
                    -EntryParameter @{ RepositoryRoot = 'C:\repo'; AllowWarnings = $true; Quiet = $false }
            }
            $content = Get-Content -LiteralPath $built.ScriptPath -Raw
            # Quotes doubled, arguments in name order, a $true switch bare, a $false switch omitted.
            $content | Should -Match ([regex]::Escape(". 'C:\build''s\Catzc\6.6.666\Import-Catzc.ps1' -AllowWarnings -RepositoryRoot 'C:\repo'"))
            $content | Should -Not -Match 'importer\.ps1'
            $content | Should -Not -Match '-Quiet'
            # The entry script also reaches the Pester configuration, for the Go bridge.
            $content | Should -Match ([regex]::Escape("-EntryScript `$entryScript"))
            $content | Should -Match ([regex]::Escape("'' 'C:\build''s\Catzc\6.6.666\Import-Catzc.ps1'"))
            # Everything after the load is the same for both runs.
            $content | Should -Match ([regex]::Escape("Join-Path (Get-CatzcModulesRoot) '.vendor/Pester'"))
            $content | Should -Match 'ConvertTo-TestAutomationRowSet'
        }

        It 'hands the tools this session located to the Pester configuration as a hashtable literal, quotes doubled' {
            $built = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 7 -TestPath @('C:\repo\a.Tests.ps1') -RunDirectory $Dir `
                    -LanguageExecutable @{ python = 'C:\widget\uv\uv.exe'; go = "C:\widget's go\bin\go.exe" }
            }
            $content = Get-Content -LiteralPath $built.ScriptPath -Raw
            $content | Should -Match ([regex]::Escape("-LanguageExecutable `$languageExecutable"))
            $content | Should -Match ([regex]::Escape("'' '' @{ 'go' = 'C:\widget''s go\bin\go.exe'; 'python' = 'C:\widget\uv\uv.exe' }"))

            $none = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 8 -TestPath @('C:\repo\a.Tests.ps1') -RunDirectory $Dir
            }
            Get-Content -LiteralPath $none.ScriptPath -Raw | Should -Match ([regex]::Escape("'' '' @{  }"))
        }

        It 'renders a worker script that parses, with the tools hashtable' {
            $built = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 9 -TestPath @('C:\repo\a.Tests.ps1') -RunDirectory $Dir `
                    -LanguageExecutable @{ go = "C:\widget's go\bin\go.exe" }
            }
            $errors = $null
            $null = [System.Management.Automation.Language.Parser]::ParseFile($built.ScriptPath, [ref] $null, [ref] $errors)
            $errors | Should -BeNullOrEmpty
        }
    }

    Context 'worker execution (real pwsh through PesterRunner)' -Tag 'L2', 'integrity', 'greedy', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
        It 'runs a generated shard end to end: results.xml, rows sidecar, and a green exit code' {
            $runDirectory = Join-Path $TestDrive 'live-run'
            [void][System.IO.Directory]::CreateDirectory($runDirectory)

            $fixture = Join-Path $TestDrive 'ShardFixture.Tests.ps1'
            $fixtureContent = @'
Describe 'ShardFixture' -Tag 'L0', 'logic' {
    It 'passes' { 1 | Should -Be 1 }
    It 'passes with Pester from the code root' {
        $vendorRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-CatzcModulesRoot) '.vendor/Pester'))
        [System.IO.Path]::GetFullPath((Get-Module Pester).ModuleBase) | Should -BeLike "$vendorRoot*"
    }
    It 'skips itself' { Set-ItResult -Skipped -Because 'tool_obj_missing'; return }
}
Describe 'ShardFixtureWide' -Tag 'L2', 'logic' {
    It 'is excluded by tag' { 1 | Should -Be 1 }
}
'@
            [System.IO.File]::WriteAllText($fixture, $fixtureContent)

            $shard = InModuleScope Catzc.Base.QualityGates -Parameters @{
                Dir = $runDirectory; Fixture = $fixture
            } {
                param($Dir, $Fixture)
                New-TestAutomationShardScript -ShardIndex 0 -TestPath @($Fixture) -RunDirectory $Dir `
                    -ExcludeTag @('L2') -Verbosity Minimal
            }

            $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
                @($shard.ScriptPath), @($shard.Label), 1, $null, 300, $true)

            $runner.Results[0].ExitCode | Should -Be 0 -Because "worker stderr: $($runner.Results[0].Stderr)"
            $shard.ResultsPath | Should -Exist
            $shard.RowsPath | Should -Exist

            $rows = @(Get-Content -LiteralPath $shard.RowsPath -Raw | ConvertFrom-Json)
            $rows | Should -HaveCount 4
            $passed = @($rows | Where-Object Result -EQ 'Passed')
            $passed | Should -HaveCount 2 -Because "failed rows: $(@($rows | Where-Object Result -EQ 'Failed' | ForEach-Object { $_.ErrorMessage }) -join '; ')"
            $passed.ExpandedPath | Should -Match 'passes'
            ($rows | Where-Object Result -EQ 'Skipped').SkipReason | Should -Be 'tool_obj_missing'
            ($rows | Where-Object Result -EQ 'NotRun').Level | Should -Be 'L2'

            # The files sidecar: the fixture's whole duration, which the next run schedules by.
            $shard.FilesPath | Should -Exist
            $files = @(Get-Content -LiteralPath $shard.FilesPath -Raw | ConvertFrom-Json)
            $files | Should -HaveCount 1
            [System.IO.Path]::GetFullPath($files[0].File) | Should -Be ([System.IO.Path]::GetFullPath($fixture))
            $files[0].DurationMs | Should -BeGreaterThan 0
            # And each file's own outcome: a file that loaded carries no error of its own.
            $files[0].Result | Should -Be 'Passed'
            $files[0].ErrorMessage | Should -BeNullOrEmpty
        }
    }
}
