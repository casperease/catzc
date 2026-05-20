Describe 'Get-ToolCommandSuffix' -Tag 'L0', 'logic' {
    # Each snake_case tools.yml key must map to the PascalCase suffix of its
    # Install-/Uninstall-/Invoke- commands. (Existence of those commands per
    # tool is covered in Get-ToolConfig.Tests.)
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
