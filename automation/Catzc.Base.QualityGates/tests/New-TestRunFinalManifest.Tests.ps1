# New-TestRunFinalManifest over fixture inputs: the terminal run.json record, with and without a context, a worker
# run, and an opt-out tag.
Describe 'New-TestRunFinalManifest' -Tag 'L0', 'logic' {
    It 'records the run, its context, and the opt-out exclusion' {
        InModuleScope Catzc.Base.QualityGates {
            $manifest = New-TestRunFinalManifest -Status passed -StartedAt '2026-01-01T00:00:00Z' -MinLevel 0 -MaxLevel 2 `
                -Category Both -Modules @('TstWidget') -FailedCount 0 -Context ([ordered]@{ slot = 'in-place' }) `
                -WorkerRun $null -OptOutTag @('source-only') -OptOutExcludedCount 3
            $manifest.status | Should -Be 'passed'
            $manifest.maxLevel | Should -Be 2
            $manifest.modules | Should -Be @('TstWidget')
            $manifest.context.slot | Should -Be 'in-place'
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
