<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Repository/tests/Assert-SourceTree.Tests.ps1
    folder: tests
    name: assert-source-tree-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Assert-SourceTree' -Tag 'L0', 'logic' {
    It 'is silent in source mode' {
        Mock Get-CatzcRunMode { 'source' } -ModuleName Catzc.Base.Repository
        { Assert-SourceTree -Command 'Format-Widget' } | Should -Not -Throw
    }

    It 'throws in build mode, naming the command and the loaded code root' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        Mock Get-CatzcModulesRoot { 'C:/widget/build/Catzc/6.6.666' } -ModuleName Catzc.Base.Repository
        { Assert-SourceTree -Command 'Format-Widget' } |
            Should -Throw '*Format-Widget operates on the catzc source tree*C:/widget/build/Catzc/6.6.666*'
    }
}
