# Drives Install-Dotnet to the point where it resolves the vendored install script, then reads the REAL script
# shipped in the loaded module (the lookup is not mocked), so it runs in both the source suite and the build suite
# (ADR-AUTO-ASSETDEP:3). The environment boundaries are mocked so nothing is downloaded or installed, and the
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
