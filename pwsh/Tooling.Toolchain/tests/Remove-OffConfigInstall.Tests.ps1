Describe 'Remove-OffConfigInstall' -Tag 'L0', 'logic', 'ADR-AUTO-REMOVE-THREEPLATFORMCORES' {
    BeforeEach {
        if (-not $IsWindows) {
            return
        }
        $script:widgetDir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:widgetDir) | Out-Null
        $script:bundle = [pscustomobject]@{ DisplayName = 'Widget Runtime'; DisplayVersion = '1.0'; ProductCode = '{widget-bundle}'; Kind = 'Bundle'; UninstallCommand = '"C:\cache\widget.exe" /uninstall /quiet' }
        $script:msi = [pscustomobject]@{ DisplayName = 'Widget Runtime'; DisplayVersion = '1.0'; ProductCode = '{widget-msi}'; Kind = 'Msi'; UninstallCommand = 'msiexec /x {widget-msi} /qn /norestart' }
        # The registration read: the bundle and its MSI first, then nothing, as a working uninstaller leaves it.
        $script:reads = 0
        Mock Get-RegisteredInstallProduct {
            $script:reads++
            if ($script:reads -eq 1) {
                $script:bundle
                $script:msi
            }
        } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-ExpectedPackageManager { $false } -ModuleName Catzc.Tooling.Toolchain
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-TimeoutSeconds { 42 } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-OutputRoot { $TestDrive } -ModuleName Catzc.Tooling.Toolchain
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Full = 'widget uninstalled' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-SystemInstallation { $true } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
        $script:call = @{
            Config = @{ command = 'widget' }; Label = 'Widget'; Tool = 'Widget'; InstallDir = $script:widgetDir
            MachineFolders = @([System.IO.Path]::GetFullPath($script:widgetDir).TrimEnd('\', '/')); ProductPattern = '^Widget'
        }
    }

    It 'with -Force runs only the bundle''s uninstaller, bounded, then re-reads the registration and removes the folder' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        $call = $script:call
        InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Call = $call } { param($Call) Remove-OffConfigInstall @Call -Force }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Command -eq '"C:\cache\widget.exe" /uninstall /quiet' -and $TimeoutSeconds -eq 42
        }
        Should -Invoke Get-RegisteredInstallProduct -ModuleName Catzc.Tooling.Toolchain -Times 2 -Exactly
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly
        (Get-ChildItem (Join-Path $TestDrive 'remove-widget') -Filter *.log | Get-Content -Raw) | Should -BeLike '*widget uninstalled*exit 0*'
    }

    It 'stops on an uninstaller that fails, naming the transcript, and deletes nothing' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 1603; Full = 'widget failed' } } -ModuleName Catzc.Tooling.Toolchain
        $call = $script:call
        { InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Call = $call } { param($Call) Remove-OffConfigInstall @Call -Force } } |
            Should -Throw '*Widget Runtime exited 1603. Transcript:*'
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'accepts a reboot-pending exit as removed' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 3010; Full = 'widget needs restart' } } -ModuleName Catzc.Tooling.Toolchain
        $call = $script:call
        InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Call = $call } { param($Call) Remove-OffConfigInstall @Call -Force }
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Message -like '*wants a restart*' }
    }

    It 'gives up after three rounds of a product that stays registered' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Mock Get-RegisteredInstallProduct { $script:msi } -ModuleName Catzc.Tooling.Toolchain
        $call = $script:call
        { InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Call = $call } { param($Call) Remove-OffConfigInstall @Call -Force } } |
            Should -Throw '*still registered after 3 rounds: Widget Runtime*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 3 -Exactly
        Should -Invoke Remove-SystemInstallation -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'without -Force runs no uninstaller and asks for no elevation' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        $call = $script:call
        InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Call = $call } { param($Call) Remove-OffConfigInstall @Call }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Toolchain -Times 0
    }
}
