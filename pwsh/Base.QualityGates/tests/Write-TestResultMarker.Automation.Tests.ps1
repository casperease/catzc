Describe 'The test-result files of a Test-Automation run' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repository = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:output = Join-Path $script:repository 'out'
        $script:widget = Join-Path $script:repository 'mods/Widget/tests/Get-Widget.Tests.ps1'
        $script:gadget = Join-Path $script:repository 'mods/Gadget/tests/Get-Gadget.Tests.ps1'
        $script:results = Join-Path $script:output 'test-results'
        $script:location = [pscustomobject]@{ Root = $script:repository; SourceRoot = $script:repository; Mode = 'in-place' }
    }

    Context 'Get-TestRunOutcome' {
        It 'gives one outcome per file that ran, failed by a failed row or file, and none for a NotRun file' {
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Widget = $script:widget; Gadget = $script:gadget; Location = $script:location; Skipped = (Join-Path $script:repository 'mods/Sprocket/tests/Get-Sprocket.Tests.ps1') } {
                param($Widget, $Gadget, $Location, $Skipped)
                $rows = @(
                    [pscustomobject]@{ File = $Widget; Result = 'Failed' }
                    [pscustomobject]@{ File = $Widget; Result = 'Failed' }
                    [pscustomobject]@{ File = $Gadget; Result = 'Passed' }
                    [pscustomobject]@{ File = $Skipped; Result = 'NotRun' }
                )
                $files = @(
                    [pscustomobject]@{ File = $Widget; Result = 'Failed' }
                    [pscustomobject]@{ File = $Gadget; Result = 'Passed' }
                )
                Get-TestRunOutcome -Row $rows -File $files -Location $Location
            }
            @($outcome) | Should -HaveCount 2
            $widget = @($outcome | Where-Object { $_.Path -eq $script:widget })
            $widget.Failed | Should -BeTrue
            $widget.FailedCount | Should -Be 2
            @($outcome | Where-Object { $_.Path -eq $script:gadget }).Failed | Should -BeFalse
        }

        It 'counts every file of a shard that failed with no failed row as failed' {
            $shardFiles = Join-Path $TestDrive 'shard-files.json'
            @([pscustomobject]@{ File = $script:widget }, [pscustomobject]@{ File = $script:gadget }) | ConvertTo-Json | Set-Content -LiteralPath $shardFiles
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Widget = $script:widget; Gadget = $script:gadget; Location = $script:location; ShardFiles = $shardFiles } {
                param($Widget, $Gadget, $Location, $ShardFiles)
                $files = @(
                    [pscustomobject]@{ File = $Widget; Result = 'Passed' }
                    [pscustomobject]@{ File = $Gadget; Result = 'Passed' }
                )
                $shard = [pscustomobject]@{ Label = 'shard-1'; FilesPath = $ShardFiles }
                Get-TestRunOutcome -Row @() -File $files -Shard @($shard) -FailedShardLabel @('shard-1') -Location $Location
            }
            @($outcome | Where-Object { $_.Failed }) | Should -HaveCount 2
        }

        It 'maps a shard file of an isolated run back to the source path' {
            $snapshot = [pscustomobject]@{ Root = (Join-Path $TestDrive 'snapshot'); SourceRoot = $script:repository; Mode = 'snapshot' }
            $shardFiles = Join-Path $TestDrive 'shard-snapshot.json'
            @([pscustomobject]@{ File = (Join-Path $snapshot.Root 'mods/Widget/tests/Get-Widget.Tests.ps1') }) | ConvertTo-Json | Set-Content -LiteralPath $shardFiles
            $outcome = InModuleScope Catzc.Base.QualityGates -Parameters @{ Location = $snapshot; ShardFiles = $shardFiles } {
                param($Location, $ShardFiles)
                $shard = [pscustomobject]@{ Label = 'shard-1'; FilesPath = $ShardFiles }
                Get-TestRunOutcome -Row @() -File @() -Shard @($shard) -FailedShardLabel @('shard-1') -Location $Location
            }
            @($outcome).Path | Should -Be $script:widget
        }
    }

    Context 'Remove-OrphanTestResult' {
        It 'removes the result of a missing file, of a non-test file and an old .failed file, and keeps the live result' {
            foreach ($file in $script:widget, (Join-Path $script:repository 'mods/Widget/Language.Bridge.ps1')) {
                New-Item -ItemType Directory -Path (Split-Path $file) -Force | Out-Null
                Set-Content -LiteralPath $file -Value ''
            }
            $live = Join-Path $script:results 'mods/Widget/tests/Get-Widget.Tests.ps1.result.json'
            $orphans = @(
                Join-Path $script:results 'mods/Gadget/tests/Get-Gadget.Tests.ps1.result.json'
                Join-Path $script:results 'mods/Widget/Language.Bridge.ps1.result.json'
                Join-Path $script:results 'mods/Widget/tests/Get-Widget.Tests.ps1.failed'
            )
            foreach ($file in @($live) + $orphans) {
                New-Item -ItemType Directory -Path (Split-Path $file) -Force | Out-Null
                Set-Content -LiteralPath $file -Value '{}'
            }
            $removed = InModuleScope Catzc.Base.QualityGates -Parameters @{ Repository = $script:repository; Output = $script:output } {
                param($Repository, $Output)
                Remove-OrphanTestResult -RepositoryRoot $Repository -OutputRoot $Output
            }
            @($removed) | Should -HaveCount 3
            Test-Path -LiteralPath $live | Should -BeTrue
            foreach ($file in $orphans) {
                Test-Path -LiteralPath $file | Should -BeFalse
            }
        }

        It 'does nothing when there is no result folder' {
            $removed = InModuleScope Catzc.Base.QualityGates -Parameters @{ Repository = $script:repository; Output = $script:output } {
                param($Repository, $Output)
                Remove-OrphanTestResult -RepositoryRoot $Repository -OutputRoot $Output
            }
            @($removed) | Should -HaveCount 0
        }
    }
}
