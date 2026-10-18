Describe 'Get-TrackedFile' -Tag 'L0', 'logic' {
    It "returns the whole repository's tracked set from Get-GitTrackedPath" {
        Mock Get-GitTrackedPath { @('a.txt', 'src/b.cs') } -ModuleName Catzc.Base.Globs

        InModuleScope Catzc.Base.Globs { Get-TrackedFile } | Should -Be @('a.txt', 'src/b.cs')
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Globs -Times 1 -Exactly -ParameterFilter { $Path -eq '.' }
    }
}

Describe 'Get-TrackedFile (real index)' -Tag 'L1', 'integrity', 'source-only' {
    It 'lists this repository''s tracked files as /-separated repo-relative paths' {
        $files = @(InModuleScope Catzc.Base.Globs { Get-TrackedFile })
        $files.Count | Should -BeGreaterThan 100
        $files | Should -Contain 'importer.ps1'
        @($files | Where-Object { $_ -like '*\*' }).Count | Should -Be 0
    }
}
