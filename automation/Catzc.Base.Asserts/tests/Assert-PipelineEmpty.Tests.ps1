<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/tests/Assert-PipelineEmpty.Tests.ps1
    folder: tests
    name: assert-pipeline-empty-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
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
