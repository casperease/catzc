Describe 'Test-PythonTests' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:results = @()
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Language = 'python'; Module = 'Catzc.Widget'; Folder = Join-Path $script:repo 'python/widget/tests'; Name = 'widget' }
            [pscustomobject]@{ Language = 'python'; Module = 'Catzc.Gadget'; Folder = Join-Path $script:repo 'python/tests/gadget'; Name = 'gadget' }
            [pscustomobject]@{ Language = 'go'; Module = 'Catzc.Sprocket'; Folder = Join-Path $script:repo 'go/tests/sprocket'; Name = 'sprocket' }
        }
        Mock Invoke-PythonTest -ModuleName Catzc.Base.QualityGates { $script:results }
        $script:reportFolder = Join-Path $TestDrive 'python-tests'
    }

    It 'runs only the named folder and passes when every test passes' {
        $script:results = @([Catzc.Base.Languages.PythonTestResult]::new('test_widget', 'test_widget_root', 'pass', 0.1, ''))
        $result = Test-PythonTests -Path 'python/widget/tests' -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 0
        Should -Invoke Invoke-PythonTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Module -eq 'Catzc.Widget'
        }
    }

    It 'runs every Python test folder and no other language when no path is named' {
        $result = Test-PythonTests -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 0
        Should -Invoke Invoke-PythonTest -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly
    }

    It 'reports a failed test with its folder, package, name and first output line' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $script:results = @(
            [Catzc.Base.Languages.PythonTestResult]::new('test_widget', 'test_widget_root', 'fail', 0.1, "`nAssertionError: 1 != 2`nmore")
            [Catzc.Base.Languages.PythonTestResult]::new('test_widget', 'test_widget_leaf', 'pass', 0.1, '')
        )
        $result = Test-PythonTests -Path 'python/tests/gadget' -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @('python/tests/gadget: test_widget test_widget_root failed: AssertionError: 1 != 2')
    }

    It 'throws once listing the findings without -PassThru' {
        $script:results = @([Catzc.Base.Languages.PythonTestResult]::new('test_widget', 'test_widget_root', 'fail', 0.1, 'boom'))
        { Test-PythonTests -Path 'python/widget/tests' -OutputFolder $script:reportFolder } | Should -Throw 'Test-PythonTests failed: 1 issue(s)*'
    }

    It 'rejects a path that is not a Python test folder' {
        { Test-PythonTests -Path 'go/tests/sprocket' -PassThru -OutputFolder $script:reportFolder } |
            Should -Throw "*'go/tests/sprocket' is not a Python test folder*"
        Should -Invoke Invoke-PythonTest -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
