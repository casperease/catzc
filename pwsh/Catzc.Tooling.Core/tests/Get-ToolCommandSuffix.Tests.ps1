<#
---
catzc:
  immutable:
    with_body_sha: aaf2c8ce54de
  edges:
    docs: "[Get-ToolCommandSuffix.Tests.ps1.md](docs/references/pwsh/catzc-tooling-core/tests/Get-ToolCommandSuffix.Tests.ps1.md)"
    code: pwsh/Catzc.Tooling.Core/Get-ToolCommandSuffix.ps1
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
