<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/tests/Invoke-Java.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Invoke-Java' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-Java '--version' -DryRun | Should -Be 'java --version'
    }

    It 'builds correct multi-arg command via -DryRun' {
        Invoke-Java '-jar app.jar --port 8080' -DryRun | Should -Be 'java -jar app.jar --port 8080'
    }
}
