Describe 'Test-ToolLocationManaged' -Tag 'L0', 'logic' {
    # Prefix logic keyed on Windows paths; the Unix branches are analogous and not exercised here.
    BeforeAll {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_paths'
        }
    }

    It 'treats a location under the winget Packages root as managed' {
        InModuleScope Catzc.Tooling.Core {
            $config = Get-ToolConfig -Tool 'node_js'
            $loc = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages\OpenJS.NodeJS.24_x\node.exe'
            Test-ToolLocationManaged -Config $config -Location $loc | Should -BeTrue
        }
    }

    It 'treats an nvm-managed location as unmanaged' {
        InModuleScope Catzc.Tooling.Core {
            $config = Get-ToolConfig -Tool 'node_js'
            Test-ToolLocationManaged -Config $config -Location 'C:\Users\me\AppData\Roaming\nvm\v19.1.0\node.exe' |
                Should -BeFalse
        }
    }

    It 'treats a script-installed tool under its install dir as managed' {
        InModuleScope Catzc.Tooling.Core {
            Mock Get-ScriptInstallDir { 'C:\Users\me\AppData\Local\dotnet' }
            $config = Get-ToolConfig -Tool 'dotnet'
            Test-ToolLocationManaged -Config $config -Location 'C:\Users\me\AppData\Local\dotnet\dotnet.exe' |
                Should -BeTrue
        }
    }

    It 'treats a script-installed tool outside its install dir as unmanaged' {
        InModuleScope Catzc.Tooling.Core {
            Mock Get-ScriptInstallDir { 'C:\Users\me\AppData\Local\dotnet' }
            $config = Get-ToolConfig -Tool 'dotnet'
            Test-ToolLocationManaged -Config $config -Location 'C:\Program Files\dotnet\dotnet.exe' |
                Should -BeFalse
        }
    }

    It 'treats a uv-tool under the uv shim bin (~/.local/bin) as managed' {
        InModuleScope Catzc.Tooling.Core {
            $config = Get-ToolConfig -Tool 'az_cli'
            $loc = Join-Path $env:USERPROFILE '.local\bin\az.exe'
            Test-ToolLocationManaged -Config $config -Location $loc | Should -BeTrue
        }
    }

    It 'treats a uv-tool outside the uv shim bin as unmanaged' {
        InModuleScope Catzc.Tooling.Core {
            $config = Get-ToolConfig -Tool 'az_cli'
            Test-ToolLocationManaged -Config $config -Location 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd' |
                Should -BeFalse
        }
    }

    It 'treats uv-provisioned python (uv data dir) as managed' {
        InModuleScope Catzc.Tooling.Core {
            $config = Get-ToolConfig -Tool 'python'
            $loc = Join-Path $env:APPDATA 'uv\python\cpython-3.14.0\python.exe'
            Test-ToolLocationManaged -Config $config -Location $loc | Should -BeTrue
        }
    }

    It 'treats a system-installed python as unmanaged' {
        InModuleScope Catzc.Tooling.Core {
            $config = Get-ToolConfig -Tool 'python'
            Test-ToolLocationManaged -Config $config -Location 'C:\Users\me\AppData\Local\Programs\Python\Python311\python.exe' |
                Should -BeFalse
        }
    }
}
