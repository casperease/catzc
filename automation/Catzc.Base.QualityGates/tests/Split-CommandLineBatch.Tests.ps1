<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Split-CommandLineBatch.Tests.ps1
    folder: tests
    name: split-command-line-batch-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Split-CommandLineBatch' -Tag 'L0', 'logic' {
    It 'keeps every batch under the limit, counting the quotes and the separator, in order' {
        $batches = InModuleScope Catzc.Base.QualityGates {
            @(Split-CommandLineBatch -Item @('widget', 'gadget', 'sprocket', 'gizmo') -MaxLength 20)
        }
        # widget and gadget cost 9 each (18); sprocket (11) would pass 20, so it opens the next batch, which gizmo (8) joins.
        $batches | Should -HaveCount 2
        $batches[0] | Should -Be @('widget', 'gadget')
        $batches[1] | Should -Be @('sprocket', 'gizmo')
    }

    It 'gives an item longer than the limit a batch of its own, and returns no batch for no items' {
        $batches = InModuleScope Catzc.Base.QualityGates {
            @(Split-CommandLineBatch -Item @('widget', ('g' * 50), 'gadget') -MaxLength 20)
        }
        $batches | Should -HaveCount 3
        $batches[1] | Should -Be @('g' * 50)
        InModuleScope Catzc.Base.QualityGates { @(Split-CommandLineBatch -Item @()) } | Should -HaveCount 0
    }

    It 'returns one batch, as an array, for a short list, so a caller''s foreach walks the batch whole' {
        $shape = InModuleScope Catzc.Base.QualityGates {
            $batches = @(Split-CommandLineBatch -Item @('widget', 'gadget'))
            '{0}:{1}' -f $batches.Count, $batches[0].GetType().Name
        }
        $shape | Should -Be '1:String[]'
    }
}
