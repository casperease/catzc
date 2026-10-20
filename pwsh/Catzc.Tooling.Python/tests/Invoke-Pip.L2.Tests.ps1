<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Python/tests/Invoke-Pip.L2.Tests.ps1
    folder: tests
    name: invoke-pip-l2-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Invoke-Pip.L2.Tests.ps1.md](docs/references/pwsh/catzc-tooling-python/tests/Invoke-Pip.L2.Tests.ps1.md)"
---
#>

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
