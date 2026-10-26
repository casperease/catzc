Describe 'Remove-Go' -Tag 'L0', 'logic', 'ADR-AUTO-REMOVE-REMOVEREFUSESMANAGED' {
    BeforeEach {
        if (-not $IsWindows) {
            return
        }
        $script:widgetDir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:widgetDir) | Out-Null
        Mock Get-ToolConfig { @{ command = 'go'; script_install = $true } } -ModuleName Catzc.Tooling.Toolchain
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
        { Remove-Go -InstallDir (Join-Path $TestDrive 'managed-widget') -Force } |
            Should -Throw '*is the managed Go install*Uninstall-Go*'
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'removes a stray install with its bin off the machine PATH, asserting elevation for that step only' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Remove-Go -InstallDir $script:widgetDir -Force
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $InstallDir -eq [System.IO.Path]::GetFullPath($script:widgetDir).TrimEnd('\', '/') -and $ExtraPathDirs -contains 'bin'
        }
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly
    }

    It 'only reports the plan without -Force, and asks for no elevation' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Remove-Go -InstallDir $script:widgetDir
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Message -like 'Would remove:*' }
    }

    It 'never deletes a machine folder a registered installer owns, and names its uninstall command' -Tag 'ADR-AUTO-REMOVE-THREEPLATFORMCORES' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Mock Get-RegisteredInstallProduct {
            [pscustomobject]@{ DisplayName = 'Go Programming Language widget'; DisplayVersion = '1.0'; ProductCode = '{widget}'; Kind = 'Msi'; UninstallCommand = 'msiexec /x {widget} /qn /norestart' }
        } -ModuleName Catzc.Tooling.Toolchain
        Remove-Go -InstallDir 'C:\Program Files\Go' -Force
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Get-RegisteredInstallProduct -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $NamePattern -eq '^Go Programming Language\b' }
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Message -like '  msiexec /x {widget} /qn /norestart*`[Msi`]' }
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Message -like 'Then re-run Remove-Go*' }
    }

    It 'does not look for registered products outside the machine-wide folders' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Remove-Go -InstallDir $script:widgetDir -Force
        Should -Invoke Get-RegisteredInstallProduct -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'targets the off-config go on PATH by default, the folder above its bin' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Mock Get-Command { [pscustomobject]@{ Source = 'C:\widget\stray\bin\go.exe' } } -ModuleName Catzc.Tooling.Toolchain
        Remove-Go
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Message -eq 'Directory not found: C:\widget\stray — nothing to remove' }
    }

    It 'targets the machine-wide folder by default when the go on PATH is the managed one' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Mock Get-Command { [pscustomobject]@{ Source = 'C:\managed-widget\bin\go.exe' } } -ModuleName Catzc.Tooling.Toolchain
        Remove-Go
        Should -Invoke Get-RegisteredInstallProduct -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly
    }
}
