<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Core/tests/Get-ToolCommandSuffix.Tests.ps1
    folder: tests
    name: get-tool-command-suffix-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-tooling-core/tests/Get-ToolCommandSuffix.Tests.ps1.md
---
#>

Describe 'Get-ToolCommandSuffix' -Tag 'L0', 'logic' {
    It 'maps snake_case key <Tool> to PascalCase suffix <Expected>' -ForEach @(
        @{ Tool = 'python'; Expected = 'Python' }
        @{ Tool = 'dotnet'; Expected = 'Dotnet' }
        @{ Tool = 'az_cli'; Expected = 'AzCli' }
        @{ Tool = 'poetry'; Expected = 'Poetry' }
        @{ Tool = 'node_js'; Expected = 'NodeJs' }
        @{ Tool = 'terraform'; Expected = 'Terraform' }
        @{ Tool = 'java'; Expected = 'Java' }
        @{ Tool = 'py_spark'; Expected = 'PySpark' }
    ) {
        $result = & (Get-Module Catzc.Tooling.Core) { Get-ToolCommandSuffix -Tool $args[0] } $Tool
        $result | Should -Be $Expected
    }
}
