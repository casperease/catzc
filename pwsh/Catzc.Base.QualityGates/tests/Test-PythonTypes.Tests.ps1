Describe 'Test-PythonTypes' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:checkOutput = '{ "generalDiagnostics": [] }'
        $script:checkExit = 0
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-PythonCheckScope -ModuleName Catzc.Base.QualityGates { Join-Path $script:repo 'python/tests/catzc-widget' }
        Mock Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Execution.CliResult]::new($script:checkOutput, '', $script:checkExit)
        }
        $script:reportFolder = Join-Path $TestDrive 'python-types'
        $script:widget = (Join-Path $script:repo 'python/tests/catzc-widget/test_widget.py').Replace('\', '\\')
    }

    It 'passes when pyright finds nothing, checking every path in scope with the workspace project' {
        $result = Test-PythonTypes -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 0
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'pyright --outputjson' -and $ConfigOption -eq '--project'
        }
    }

    It 'reports each error and warning with its repository-relative file and one-based position, skipping information' -Tag 'ADR-AUTO-TEST#35' {
        $script:checkOutput = @"
{ "generalDiagnostics": [
  { "file": "$script:widget", "severity": "error", "rule": "reportOptionalMemberAccess",
    "message": "\"split\" is not a known attribute of \"None\"", "range": { "start": { "line": 2, "character": 7 } } },
  { "file": "$script:widget", "severity": "warning", "message": "Import \"gadget\" could not be resolved\n  from source",
    "range": { "start": { "line": 0, "character": 0 } } },
  { "file": "$script:widget", "severity": "information", "message": "unreachable", "range": { "start": { "line": 9, "character": 0 } } }
] }
"@
        $script:checkExit = 1
        $result = Test-PythonTypes -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @(
            'python/tests/catzc-widget/test_widget.py:3:8: error reportOptionalMemberAccess "split" is not a known attribute of "None"'
            'python/tests/catzc-widget/test_widget.py:1:1: warning Import "gadget" could not be resolved from source'
        )
    }

    It 'reads the report past any notice pyright prints before it' {
        $script:checkOutput = "WARNING: there is a new pyright version available`n" +
        "{ `"generalDiagnostics`": [ { `"file`": `"$script:widget`", `"severity`": `"error`", `"message`": `"gadget`", `"range`": { `"start`": { `"line`": 0, `"character`": 0 } } } ] }"
        $script:checkExit = 1
        (Test-PythonTypes -PassThru -OutputFolder $script:reportFolder).Issues | Should -Be @('python/tests/catzc-widget/test_widget.py:1:1: error gadget')
    }

    It 'throws once listing every finding without -PassThru' {
        $script:checkOutput = "{ `"generalDiagnostics`": [ { `"file`": `"$script:widget`", `"severity`": `"error`", `"message`": `"gadget`", `"range`": { `"start`": { `"line`": 0, `"character`": 0 } } } ] }"
        $script:checkExit = 1
        { Test-PythonTypes -OutputFolder $script:reportFolder } | Should -Throw 'Test-PythonTypes failed: 1 issue(s)*'
    }

    It 'throws when pyright itself fails' {
        $script:checkOutput = 'Config file could not be parsed'
        $script:checkExit = 3
        { Test-PythonTypes -PassThru -OutputFolder $script:reportFolder } | Should -Throw '*pyright could not check the Python files (exit 3)*'
    }

    It 'needs no uv when the repository holds no Python' {
        Mock Get-PythonCheckScope -ModuleName Catzc.Base.QualityGates { }
        (Test-PythonTypes -PassThru -OutputFolder $script:reportFolder).IssueCount | Should -Be 0
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 0
    }
}

Describe 'Repository Python type integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'every Python file passes pyright (Test-PythonTypes)' {
        $uv = Resolve-ToolExecutable -Tool uv
        $python = Resolve-ToolExecutable -Tool python
        if (-not ($uv.Found -and $uv.VersionOk -and $python.Found -and $python.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_uv_missing'
            return
        }
        $result = Test-PythonTypes -PassThru -OutputFolder (Join-Path $TestDrive 'python-types')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
