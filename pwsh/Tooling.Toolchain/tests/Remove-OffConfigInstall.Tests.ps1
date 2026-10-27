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

    It 'prints each uninstall line pwsh-safe: pasted into pwsh it parses as one command with the GUID a string argument' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        $script:reads = 0
        Mock Get-RegisteredInstallProduct {
            [pscustomobject]@{ DisplayName = 'Gadget'; DisplayVersion = '1.0'; ProductCode = '{6AD6E700-0510-000D-0C70-C0DE00000000}'; Kind = 'Msi'
                UninstallCommand = 'msiexec /x {6AD6E700-0510-000D-0C70-C0DE00000000} /qn /norestart'
            }
            [pscustomobject]@{ DisplayName = 'Gadget Setup'; DisplayVersion = '1.0'; ProductCode = '{gadget}'; Kind = 'Other'
                UninstallCommand = '"C:\gadget\setup.exe" /uninstall /quiet'
            }
        } -ModuleName Catzc.Tooling.Toolchain
        $script:printed = [System.Collections.Generic.List[string]]::new()
        Mock Write-Message { if ($Message -like '  *#*') {
                $script:printed.Add($Message)
            } } -ModuleName Catzc.Tooling.Toolchain
        $call = $script:call
        InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Call = $call } { param($Call) Remove-OffConfigInstall @Call }
        $script:printed.Count | Should -Be 2
        foreach ($message in $script:printed) {
            $errors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($message.Trim(), [ref]$null, [ref]$errors)
            $errors.Count | Should -Be 0
            $command = $ast.EndBlock.Statements[0].PipelineElements[0]
            $command | Should -BeOfType ([System.Management.Automation.Language.CommandAst])
            @($command.CommandElements | Where-Object { $_ -is [System.Management.Automation.Language.ScriptBlockExpressionAst] }).Count | Should -Be 0
        }
        $guid = $ast = [System.Management.Automation.Language.Parser]::ParseInput($script:printed[0].Trim(), [ref]$null, [ref]$null)
        $guid.EndBlock.Statements[0].PipelineElements[0].CommandElements[2].Value | Should -Be '{6AD6E700-0510-000D-0C70-C0DE00000000}'
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

# The real limit lookup, unmocked: a lookup that cannot resolve from inside the module throws here, as it did on a real run.
Describe 'Remove-OffConfigInstall time limit' -Tag 'L0', 'logic' {
    It 'bounds each uninstaller by the declared msiexec limit, read for real' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        $widgetDir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($widgetDir) | Out-Null
        $script:reads = 0
        Mock Get-RegisteredInstallProduct {
            $script:reads++
            if ($script:reads -eq 1) {
                [pscustomobject]@{ DisplayName = 'Widget'; DisplayVersion = '1.0'; ProductCode = '{widget}'; Kind = 'Msi'; UninstallCommand = 'msiexec /x {widget} /qn' }
            }
        } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-ExpectedPackageManager { $false } -ModuleName Catzc.Tooling.Toolchain
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-OutputRoot { $TestDrive } -ModuleName Catzc.Tooling.Toolchain
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Full = 'ok' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-SystemInstallation { $true } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
        $expected = Get-TimeoutSeconds -Executable 'msiexec'
        $call = @{ Config = @{ command = 'widget' }; Label = 'Widget'; Tool = 'Widget'; InstallDir = $widgetDir
            MachineFolders = @([System.IO.Path]::GetFullPath($widgetDir).TrimEnd('\', '/')); ProductPattern = '^Widget'
        }
        InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Call = $call } { param($Call) Remove-OffConfigInstall @Call -Force }
        $expected | Should -BeGreaterThan 60
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $TimeoutSeconds -eq $expected }
    }
}
