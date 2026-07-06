# The chain is Invoke-Pip → Invoke-Uv → uv pip <args>: uv is the tool that must exist, and it needs a
# discoverable interpreter. There is no `uv pip --version` — `uv pip` is a subcommand group — so the
# end-to-end contract is carried by a real subcommand.
Describe 'Invoke-Pip' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:uvAvailable = Test-Tool 'uv'
        $script:pythonAvailable = Test-Tool 'python'
    }

    It 'lists packages as JSON with accessible properties' {
        if (-not $script:uvAvailable) {
            Set-ItResult -Skipped -Because 'tool_uv_missing'; return
        }
        if (-not $script:pythonAvailable) {
            Set-ItResult -Skipped -Because 'tool_python_missing'; return
        }
        $result = Invoke-Pip 'list --format json' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $packages = $result.Output | ConvertFrom-Json
        $packages.Count | Should -BeGreaterThan 0
        $packages[0].name | Should -Not -BeNullOrEmpty
    }
}
