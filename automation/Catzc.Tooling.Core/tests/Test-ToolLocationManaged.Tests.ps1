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

    It 'treats a winget user-scope installer package (%LOCALAPPDATA%\Programs, e.g. OpenJDK) as managed' {
        InModuleScope Catzc.Tooling.Core {
            # winget installs Microsoft.OpenJDK user-scope under %LOCALAPPDATA%\Programs, NOT under
            # \Microsoft\WinGet\Packages — so this root must count or a winget-managed JDK reads as foreign.
            $config = Get-ToolConfig -Tool 'java'
            $loc = Join-Path $env:LOCALAPPDATA 'Programs\Microsoft\jdk-17.0.10.7-hotspot\bin\java.exe'
            Test-ToolLocationManaged -Config $config -Location $loc | Should -BeTrue
        }
    }

    It 'treats a standalone uv under ~/.local/bin as managed' {
        InModuleScope Catzc.Tooling.Core {
            # Install-Uv treats a uv on PATH outside the winget root (its standalone/user bin) as a managed,
            # self-updating install, so the janitor must agree rather than flag it foreign.
            $config = Get-ToolConfig -Tool 'uv'
            $loc = Join-Path $env:USERPROFILE '.local\bin\uv.exe'
            Test-ToolLocationManaged -Config $config -Location $loc | Should -BeTrue
        }
    }

    It 'treats a machine-scope Program Files install as unmanaged (the coarse-advisory boundary)' {
        InModuleScope Catzc.Tooling.Core {
            # Machine-scope installs stay foreign by design — only user-scope roots are trusted here.
            $config = Get-ToolConfig -Tool 'java'
            Test-ToolLocationManaged -Config $config -Location 'C:\Program Files\Microsoft\jdk-17.0.10.7-hotspot\bin\java.exe' |
                Should -BeFalse
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
            $config = Get-ToolConfig -Tool 'poetry'
            $loc = Join-Path $env:USERPROFILE '.local\bin\poetry.exe'
            Test-ToolLocationManaged -Config $config -Location $loc | Should -BeTrue
        }
    }

    It 'treats a uv-venv tool (az_cli) under the venv root as managed' {
        InModuleScope Catzc.Tooling.Core {
            $config = Get-ToolConfig -Tool 'az_cli'
            $loc = Join-Path $env:LOCALAPPDATA 'catzc\venvs\az_cli\Scripts\az.bat'
            Test-ToolLocationManaged -Config $config -Location $loc | Should -BeTrue
        }
    }

    It 'treats a system-provided tool (winget) as managed wherever it resolves' {
        InModuleScope Catzc.Tooling.Core {
            $config = Get-ToolConfig -Tool 'winget'
            $loc = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\winget.exe'
            Test-ToolLocationManaged -Config $config -Location $loc | Should -BeTrue
        }
    }

    It 'treats a uv-venv tool outside the venv root (e.g. a machine-scope MSI) as unmanaged' {
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
