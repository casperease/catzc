<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Tooling.Core
    relatives:
      page: docs/references/automation/catzc-tooling-core/tests/Test-ToolLocationManaged.Tests.ps1.md
      source: automation/Catzc.Tooling.Core/private/Test-ToolLocationManaged.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Test-ToolLocationManaged' -Tag 'L0', 'logic' {
    BeforeEach {
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
            $config = Get-ToolConfig -Tool 'java'
            $loc = Join-Path $env:LOCALAPPDATA 'Programs\Microsoft\jdk-17.0.10.7-hotspot\bin\java.exe'
            Test-ToolLocationManaged -Config $config -Location $loc | Should -BeTrue
        }
    }

    It 'treats a standalone uv under ~/.local/bin as managed' {
        InModuleScope Catzc.Tooling.Core {
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

    It 'treats an MSYS2-package tool at <case> as <expected>' -ForEach @(
        @{ case = 'its usr\bin inside the tree it installs into'; location = 'C:\Users\me\AppData\Local\Gadget\usr\bin\widget.exe'; expected = $true }
        @{ case = 'a machine-scope tree'; location = 'C:\Program Files\Gadget\usr\bin\widget.exe'; expected = $false }
        @{ case = 'a sibling folder sharing the prefix'; location = 'C:\Users\me\AppData\Local\GadgetTwo\usr\bin\widget.exe'; expected = $false }
    ) {
        InModuleScope Catzc.Tooling.Core -Parameters @{ location = $location; expected = $expected } {
            param($location, $expected)
            # Neutral fixture ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
            Mock Get-ScriptInstallDir { 'C:\Users\me\AppData\Local\Gadget' }
            $config = [Catzc.Base.Execution.ToolConfig]::new(@{
                    version = '1'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)'
                    msys2_url = 'https://example.com/widget-1.0-1-x86_64.pkg.tar.zst'; msys2_sha256 = 'a' * 64; windows_install_dir = 'Gadget'
                })
            Test-ToolLocationManaged -Config $config -Location $location | Should -Be $expected
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
