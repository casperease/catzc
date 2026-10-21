<#
---
catzc:
  immutable:
    with_body_sha: "31fa0b10eb01"
  edges:
    code: pwsh/Catzc.Tooling.Toolchain/Invoke-Go.ps1
---
#>

Describe 'Invoke-Go' -Tag 'L0', 'logic' {
    It 'builds the command via -DryRun' {
        Invoke-Go 'version' -DryRun | Should -Be 'go version'
    }

    It 'asserts the tool, then runs the executable the check located' {
        Mock Assert-Tool { } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-Tool { [Catzc.Base.Execution.ExecutableProbe]::new('go', '/opt/widget/go/bin/go', 'probe', '1.27.2', '1.27', $true, 1, 0, 'Person') } -ModuleName Catzc.Tooling.Toolchain
        Mock Invoke-Executable { } -ModuleName Catzc.Tooling.Toolchain
        Invoke-Go 'env GOROOT' -PassThru
        Should -Invoke Assert-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Tool -eq 'go' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Command -eq '"/opt/widget/go/bin/go" env GOROOT' -and $PassThru
        }
    }
}
