<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Test-PythonLint.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Test-PythonLint' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:checkOutput = ''
        $script:checkExit = 0
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new(@{ root = 'python'; dependencies = @{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } })
        }
        Mock Get-PythonCheckScope -ModuleName Catzc.Base.QualityGates { Join-Path $script:repo 'python/tests/catzc-widget' }
        Mock Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Execution.CliResult]::new($script:checkOutput, '', $script:checkExit)
        }
        $script:reportFolder = Join-Path $TestDrive 'python-lint'
    }

    It 'passes when ruff finds nothing, checking every path in scope with the concise format' {
        $result = Test-PythonLint -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 0
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'ruff check --output-format concise'
        }
    }

    It 'reports each finding with its repository-relative file' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $script:checkOutput = "tests\catzc-widget\test_widget.py:3:8: F401 [*] ``os`` imported but unused`nFound 1 error."
        $script:checkExit = 1
        $result = Test-PythonLint -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @('python/tests/catzc-widget/test_widget.py:3:8: F401 [*] `os` imported but unused')
    }

    It 'throws once listing every finding without -PassThru' {
        $script:checkOutput = @(
            'tests\catzc-widget\test_widget.py:3:8: F401 unused'
            'tests\catzc-widget\test_widget.py:9:1: E731 lambda'
        ) -join "`n"
        $script:checkExit = 1
        { Test-PythonLint -OutputFolder $script:reportFolder } | Should -Throw 'Test-PythonLint failed: 2 issue(s)*'
    }

    It 'throws when ruff itself fails' {
        $script:checkOutput = 'error: Failed to parse pyproject.toml'
        $script:checkExit = 2
        { Test-PythonLint -PassThru -OutputFolder $script:reportFolder } | Should -Throw '*ruff could not check the Python files (exit 2)*'
    }

    It 'needs no uv when the repository holds no Python' {
        Mock Get-PythonCheckScope -ModuleName Catzc.Base.QualityGates { }
        (Test-PythonLint -PassThru -OutputFolder $script:reportFolder).IssueCount | Should -Be 0
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 0
    }
}

Describe 'Repository Python lint integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'every Python file passes ruff check (Test-PythonLint)' {
        $uv = Resolve-ToolExecutable -Tool uv
        $python = Resolve-ToolExecutable -Tool python
        if (-not ($uv.Found -and $uv.VersionOk -and $python.Found -and $python.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_uv_missing'
            return
        }
        $result = Test-PythonLint -PassThru -OutputFolder (Join-Path $TestDrive 'python-lint')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
