<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Assert-PipelineEmpty.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Asserts
    relatives:
      source: automation/Catzc.Base.Asserts/Assert-PipelineEmpty.ps1
---
#>

Describe 'Assert-PipelineEmpty' -Tag 'L0', 'logic' {
    It 'passes when pipeline is empty' {
        { @() | Assert-PipelineEmpty } | Should -Not -Throw
    }

    It 'throws when pipeline has objects' {
        { @(1) | Assert-PipelineEmpty } | Should -Throw
    }

    It 'throws on first object without waiting' {
        { 1, 2, 3 | Assert-PipelineEmpty } | Should -Throw
    }

    It 'throws when called with direct input' {
        { Assert-PipelineEmpty -InputObject 'x' } | Should -Throw -ExpectedMessage '*pipeline*'
    }
}
