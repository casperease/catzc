Describe 'Remove-TokenFromHistory' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock -ModuleName Catzc.Tooling.Github Assert-Command {}
        Mock -ModuleName Catzc.Tooling.Github Write-Message {}
    }

    It 'builds the filter-repo command without running anything in -DryRun' {
        $result = Remove-TokenFromHistory -Token 'old-name' -RepositoryPath 'TestDrive:/' -DryRun
        $result.DryRun | Should -BeTrue
        $result.Command | Should -BeLike 'git filter-repo *--replace-text*'
        $result.Command | Should -BeLike '*--replace-message*'
        $result.Command | Should -BeLike '*--force'
        $result.Expression | Should -Be 'old-name==>***REMOVED***'
    }

    It 'omits --replace-message when -SkipMessages is set' {
        $result = Remove-TokenFromHistory -Token 'old-name' -RepositoryPath 'TestDrive:/' -SkipMessages -DryRun
        $result.Command | Should -Not -BeLike '*--replace-message*'
        $result.Command | Should -BeLike '*--replace-text*'
    }

    It 'honours a custom -ReplaceWith placeholder' {
        (Remove-TokenFromHistory -Token 'secret' -ReplaceWith 'GONE' -RepositoryPath 'TestDrive:/' -DryRun).Expression | Should -Be 'secret==>GONE'
    }

    It 'launches nothing during -DryRun' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { throw 'should not run' }
        Remove-TokenFromHistory -Token 'old-name' -RepositoryPath 'TestDrive:/' -DryRun | Out-Null
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 0
    }

    It 'throws a helpful error when git-filter-repo is not installed' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 1; Output = ''; Errors = 'unknown command' } } -ParameterFilter { $Command -eq 'git filter-repo --version' }
        { Remove-TokenFromHistory -Token 'old-name' -RepositoryPath 'TestDrive:/' } | Should -Throw '*not installed*'
    }
}
