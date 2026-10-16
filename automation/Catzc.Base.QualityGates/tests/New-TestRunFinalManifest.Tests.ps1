<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1
    folder: tests
    name: new-test-run-final-manifest-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/New-TestRunFinalManifest.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#32
---
#>

Describe 'New-TestRunFinalManifest' -Tag 'L0', 'logic' {
    It 'records the run, its context, and the opt-out exclusion' {
        InModuleScope Catzc.Base.QualityGates {
            $manifest = New-TestRunFinalManifest -Status passed -StartedAt '2026-01-01T00:00:00Z' -MinLevel 0 -MaxLevel 2 `
                -Category Both -Modules @('TstWidget') -FailedCount 0 -Context ([ordered]@{ location = 'in-place' }) `
                -WorkerRun $null -OptOutTag @('source-only') -OptOutExcludedCount 3
            $manifest.status | Should -Be 'passed'
            $manifest.maxLevel | Should -Be 2
            $manifest.modules | Should -Be @('TstWidget')
            $manifest.context.location | Should -Be 'in-place'
            $manifest.durationSeconds | Should -Be 0
            $manifest.optOutTag | Should -Be @('source-only')
            $manifest.optOutExcludedCount | Should -Be 3
        }
    }

    It 'omits the context and the opt-out entries a crashed run never reached' {
        InModuleScope Catzc.Base.QualityGates {
            $manifest = New-TestRunFinalManifest -Status crashed -Context $null -WorkerRun $null
            $manifest.Contains('context') | Should -BeFalse
            $manifest.Contains('optOutTag') | Should -BeFalse
            $manifest.status | Should -Be 'crashed'
        }
    }
}

Describe 'New-TestRunFinalManifest — a snapshot run, written and read back' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:runDirectory = Join-Path $TestDrive 'run-widget'
        [void][System.IO.Directory]::CreateDirectory($script:runDirectory)
        $script:written = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
            param($Dir)
            $workerRun = [pscustomobject]@{
                ShardExitCodes  = [ordered]@{ 'shard-0' = 0 }
                DurationSeconds = 4.5
                Location        = [pscustomobject]@{
                    Mode        = 'snapshot'
                    Root        = 'C:\tmp\catzc-run-gadget'
                    KeepSandbox = $false
                    Holder      = [pscustomobject]@{ Description = 'Test-Automation (pid 4242, run widget-run)' }
                    Snapshot    = [pscustomobject]@{
                        Path = 'C:\tmp\catzc-run-gadget'; SourceRoot = 'C:\widget'; Commit = '0a69309f00d'; Modified = 1; Untracked = 0; Deleted = 0
                    }
                }
            }
            $manifest = New-TestRunFinalManifest -Status passed -StartedAt 'stamp-001' -MaxLevel 2 -Context ([ordered]@{ suite = 'gadget' }) -WorkerRun $workerRun
            Write-TestRunManifest -RunDirectory $Dir -Manifest $manifest
        }
        $script:run = Get-Content -LiteralPath $script:written -Raw | ConvertFrom-Json
    }

    It 'records the snapshot location with its path, its source, and the run that held the working folder' {
        $script:run.location | Should -Be 'snapshot'
        $script:run.snapshot.path | Should -Be 'C:\tmp\catzc-run-gadget'
        $script:run.snapshot.sourceRoot | Should -Be 'C:\widget'
        $script:run.snapshot.holder | Should -Be 'Test-Automation (pid 4242, run widget-run)'
    }

    It 'records that a snapshot not claimed with -KeepSandbox was not kept' {
        $script:run.snapshot.kept | Should -BeFalse
    }

    It 'keeps the context and the shard exit codes beside the location' {
        $script:run.context.suite | Should -Be 'gadget'
        $script:run.shardExitCodes.'shard-0' | Should -Be 0
        $script:run.durationSeconds | Should -Be 4.5
    }
}
