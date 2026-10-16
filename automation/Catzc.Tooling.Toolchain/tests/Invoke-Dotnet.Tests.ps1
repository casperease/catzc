<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/tests/Invoke-Dotnet.Tests.ps1
    folder: tests
    name: invoke-dotnet-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Invoke-Dotnet' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-Dotnet 'build' -DryRun | Should -Be 'dotnet build'
    }

    It 'builds correct multi-arg command via -DryRun' {
        Invoke-Dotnet 'test --no-build' -DryRun | Should -Be 'dotnet test --no-build'
    }
}
