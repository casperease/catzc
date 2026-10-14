# Drives Install-Dotnet to the point where it resolves the vendored install script, then reads the REAL script
# shipped in the loaded module (the lookup is not mocked), so it runs in both the source run and the build run
# ([ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3)). The environment
# boundaries are mocked so nothing is downloaded or installed, and the
# script's presence check is the stop point: it records the resolved path and halts before the script runs.
Describe 'Install-Dotnet — shipped install scripts' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    BeforeAll {
        $script:installDirectory = Join-Path $TestDrive 'dotnet-widget'
        $script:resolvedScripts = [System.Collections.Generic.List[string]]::new()

        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'dotnet-widget'; version = '10.0'; version_pattern = '(?<ver>\d+\.\d+)' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ScriptInstallDir { $script:installDirectory } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
        Mock Assert-PathExist {
            $script:resolvedScripts.Add($Path)
            throw 'stop before the install script runs'
        } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Path -like '*dotnet-install*' }

        { Install-Dotnet } | Should -Throw '*stop before the install script runs*'
        $script:scriptPath = $script:resolvedScripts[0]
    }

    It 'resolves the platform install script inside the loaded module' {
        $script:scriptPath | Should -Exist
        $expectedName = if ($IsWindows) {
            'dotnet-install.ps1'
        }
        else {
            'dotnet-install.sh'
        }
        [System.IO.Path]::GetFileName($script:scriptPath) | Should -Be $expectedName
        $moduleRoot = [System.IO.Path]::GetFullPath((Get-CatzcModuleRoot -Module Catzc.Tooling.Toolchain))
        [System.IO.Path]::GetFullPath($script:scriptPath) | Should -BeLike "$moduleRoot*"
    }

    It 'ships the install script of every platform in the loaded module' {
        Get-CatzcModuleRoot 'assets/scripts/dotnet-install.ps1' -Module Catzc.Tooling.Toolchain | Should -Exist
        Get-CatzcModuleRoot 'assets/scripts/dotnet-install.sh' -Module Catzc.Tooling.Toolchain | Should -Exist
    }

    It 'the shipped script accepts the channel, install-dir and quality options Install-Dotnet passes' {
        if ($IsWindows) {
            $tokens = $null
            $parseErrors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($script:scriptPath, [ref]$tokens, [ref]$parseErrors)
            $parameterNames = @($ast.ParamBlock.Parameters | ForEach-Object { $_.Name.VariablePath.UserPath })
            $parameterNames | Should -Contain 'Channel'
            $parameterNames | Should -Contain 'InstallDir'
            $parameterNames | Should -Contain 'Quality'
        }
        else {
            $text = [System.IO.File]::ReadAllText($script:scriptPath)
            $text | Should -Match '--channel'
            $text | Should -Match '--install-dir'
            $text | Should -Match '--quality'
        }
    }
}

# Hermetic logic (L1): the install script, the version probes, the PATH seam (Add-PermanentPath) and the persistent
# variable seam (Set-PermanentEnvironmentVariable) are mocked or fixtures under $TestDrive — nothing is downloaded,
# and the real user environment is never touched (its round trip is the seam's L3 test).
Describe 'Install-Dotnet' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:savedDotnetRoot = $env:DOTNET_ROOT
    }
    AfterAll {
        $env:DOTNET_ROOT = $script:savedDotnetRoot
    }
    BeforeEach {
        $env:DOTNET_ROOT = $null
        # A fresh install dir per test; a test that wants "already installed" drops a binary into it.
        $script:installDir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:installDir) | Out-Null
        $binaryName = 'dotnet'
        if ($IsWindows) {
            $binaryName = 'dotnet.exe'
        }
        $script:binary = Join-Path $script:installDir $binaryName
        # The fixture install script records how it was called instead of downloading anything.
        $script:installLog = Join-Path $TestDrive "install-$([guid]::NewGuid().ToString('N')).txt"
        $script:fixtureScript = Join-Path $TestDrive 'dotnet-install-widget.ps1'
        [System.IO.File]::WriteAllText($script:fixtureScript, "param(`$Channel, `$InstallDir, `$Quality) [System.IO.File]::WriteAllText(`$env:CATZC_WIDGET_INSTALL_LOG, `"`$Channel|`$InstallDir|`$Quality`")")
        $env:CATZC_WIDGET_INSTALL_LOG = $script:installLog

        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolConfig {
            [Catzc.Base.Execution.ToolConfig]::new(@{ version = '10.0'; command = 'dotnet'; version_command = 'dotnet --version'; version_pattern = '(?<ver>\d+\.\d+\.\d+)' })
        } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ScriptInstallDir { $script:installDir } -ModuleName Catzc.Tooling.Toolchain
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Full = '10.0.201'; Output = '10.0.201' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolVersion { $null } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-CatzcModuleRoot { $script:fixtureScript } -ModuleName Catzc.Tooling.Toolchain
        Mock Add-PermanentPath { } -ModuleName Catzc.Tooling.Toolchain
        Mock Set-PermanentEnvironmentVariable { } -ModuleName Catzc.Tooling.Toolchain
        Mock Assert-Command { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }
    AfterEach {
        $env:CATZC_WIDGET_INSTALL_LOG = $null
    }

    It 'refuses to run in a pipeline, pointing at the native task' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Tooling.Toolchain
        { Install-Dotnet } | Should -Throw '*UseDotNet@2*'
        Should -Invoke Add-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'skips the download when its own dir holds the locked version, and still converges the environment' {
        [System.IO.File]::WriteAllText($script:binary, '')
        Install-Dotnet
        [System.IO.File]::Exists($script:installLog) | Should -BeFalse -Because 'the install script must not run'
        $env:DOTNET_ROOT | Should -Be $script:installDir
        Should -Invoke Add-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Path -eq $script:installDir -and $Prepend }
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 0 -ParameterFilter { $Message -like '*installed successfully*' }
    }

    It 'refuses a different version in its own dir without -Force' {
        [System.IO.File]::WriteAllText($script:binary, '')
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Full = '8.0.404'; Output = '8.0.404' } } -ModuleName Catzc.Tooling.Toolchain
        { Install-Dotnet } | Should -Throw '*version mismatch*8.0.404*Install-Dotnet -Force*'
        Should -Invoke Add-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'leaves a correct dotnet found elsewhere on PATH alone, touching no environment' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolVersion { '10.0.100' } -ModuleName Catzc.Tooling.Toolchain
        Install-Dotnet
        [System.IO.File]::Exists($script:installLog) | Should -BeFalse
        $env:DOTNET_ROOT | Should -BeNullOrEmpty
        Should -Invoke Add-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'runs the install script for the locked channel and persists DOTNET_ROOT through the seam (Windows)' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_persistent_user_env'
            return
        }
        Install-Dotnet
        [System.IO.File]::ReadAllText($script:installLog) | Should -Be "10.0|$script:installDir|ga"
        Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'DOTNET_ROOT' -and $Value -eq $script:installDir
        }
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Message -like 'Dotnet 10.0 installed successfully*' }
    }
}
