Describe 'Remove-Dotnet' -Tag 'L0', 'logic', 'ADR-AUTO-REMOVE#3' {
    BeforeEach {
        if (-not $IsWindows) {
            return
        }
        $script:widgetDir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:widgetDir) | Out-Null
        Mock Get-ToolConfig { @{ command = 'dotnet'; script_install = $true } } -ModuleName Catzc.Tooling.Toolchain
        # Only the managed folder counts as managed — whatever is on PATH.
        Mock Test-ExpectedPackageManager { $Path -like '*managed-widget*' } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-RegisteredInstallProduct { } -ModuleName Catzc.Tooling.Toolchain
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-SystemInstallation { $true } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'refuses the managed install, judged for the folder it would remove' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        { Remove-Dotnet -InstallDir (Join-Path $TestDrive 'managed-widget') -Force } | Should -Throw '*is the managed .NET install*Uninstall-Dotnet*'
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'removes a stray install even while the managed one is first on PATH' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Remove-Dotnet -InstallDir $script:widgetDir -Force
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $InstallDir -eq [System.IO.Path]::GetFullPath($script:widgetDir).TrimEnd('\', '/')
        }
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly
    }

    It 'only reports the plan without -Force' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Remove-Dotnet -InstallDir $script:widgetDir
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Message -like 'Would remove:*' }
    }

    It 'never deletes a machine folder registered products own, and names their uninstall commands' -Tag 'ADR-AUTO-REMOVE#7' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Mock Get-RegisteredInstallProduct {
            [pscustomobject]@{ DisplayName = 'Microsoft .NET SDK 6.0.428 (x64)'; DisplayVersion = '6.4.2824.52403'; ProductCode = '{00000000-widget}' }
        } -ModuleName Catzc.Tooling.Toolchain
        $machine = 'C:\Program Files\dotnet'
        if (-not [System.IO.Directory]::Exists($machine)) {
            Set-ItResult -Skipped -Because 'no_machine_dotnet_folder'; return
        }
        Remove-Dotnet -InstallDir $machine -Force
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Message -like '*winget uninstall --product-code*{00000000-widget}*' }
    }

    It 'does not look for registered products outside the machine-wide folders' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Remove-Dotnet -InstallDir $script:widgetDir -Force
        Should -Invoke Get-RegisteredInstallProduct -ModuleName Catzc.Tooling.Toolchain -Times 0
    }
}

Describe 'Resolve-DotnetRemovalTarget' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-ToolConfig { @{ command = 'dotnet'; script_install = $true } } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'is the machine-wide folder when the dotnet on PATH is the managed install' {
        Mock Get-Command { [pscustomobject]@{ Source = 'C:\widget\managed\dotnet.exe' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-ExpectedPackageManager { $true } -ModuleName Catzc.Tooling.Toolchain
        InModuleScope Catzc.Tooling.Toolchain { Resolve-DotnetRemovalTarget } | Should -Be 'C:\Program Files\dotnet'
    }

    It 'is the folder of the dotnet on PATH when that is off-config' {
        Mock Get-Command { [pscustomobject]@{ Source = 'C:\widget\stray\dotnet.exe' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-ExpectedPackageManager { $false } -ModuleName Catzc.Tooling.Toolchain
        InModuleScope Catzc.Tooling.Toolchain { Resolve-DotnetRemovalTarget } | Should -Be 'C:\widget\stray'
    }
}
