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
