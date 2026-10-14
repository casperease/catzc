Describe 'Get-RegisteredInstallProduct' -Tag 'L0', 'logic', 'ADR-AUTO-REMOVE#7' {
    BeforeEach {
        # Two uninstall-registry views: the bundle registers only in the 32-bit one, its MSI in the 64-bit one, under the
        # same display name — the shape the .NET runtime installers leave.
        $script:entries = @{
            '{widget-msi}'    = [pscustomobject]@{ DisplayName = 'Microsoft Widget Runtime - 6.0 (x64)'; DisplayVersion = '48.1'; WindowsInstaller = 1 }
            '{widget-bundle}' = [pscustomobject]@{
                DisplayName = 'Microsoft Widget Runtime - 6.0 (x64)'; DisplayVersion = '6.0.1'; BundleCachePath = 'C:\cache\widget.exe'
                QuietUninstallString = '"C:\cache\widget.exe" /uninstall /quiet'; UninstallString = '"C:\cache\widget.exe" /uninstall'
            }
            '{gadget-exe}'    = [pscustomobject]@{ DisplayName = 'Microsoft Gadget Tool'; UninstallString = '"C:\gadget\remove.exe"' }
            '{unrelated}'     = [pscustomobject]@{ DisplayName = 'Contoso Widget' }
            '{nameless}'      = [pscustomobject]@{ SystemComponent = 1 }
        }
        Mock Get-ChildItem -ModuleName Catzc.Tooling.Toolchain {
            $codes = if ($LiteralPath -like '*WOW6432Node*') {
                '{widget-bundle}', '{unrelated}'
            }
            else {
                '{widget-msi}', '{gadget-exe}', '{nameless}'
            }
            foreach ($code in $codes) {
                [pscustomobject]@{ PSChildName = $code; PSPath = "registry::$code" }
            }
        }
        Mock Get-ItemProperty -ModuleName Catzc.Tooling.Toolchain { $script:entries[$LiteralPath -replace '^registry::'] }
    }

    It 'keeps a bundle and the MSI it installed apart although they share a display name' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_registry'; return
        }
        $products = @(InModuleScope Catzc.Tooling.Toolchain { Get-RegisteredInstallProduct '^Microsoft (Widget|Gadget)' })
        $products.ProductCode | Sort-Object | Should -Be @('{gadget-exe}', '{widget-bundle}', '{widget-msi}')
    }

    It 'classifies each entry and carries the command that removes it by its own installer' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_registry'; return
        }
        $byCode = @{}
        InModuleScope Catzc.Tooling.Toolchain { Get-RegisteredInstallProduct '^Microsoft (Widget|Gadget)' } | ForEach-Object { $byCode[$_.ProductCode] = $_ }
        $byCode['{widget-bundle}'].Kind | Should -Be 'Bundle'
        $byCode['{widget-bundle}'].UninstallCommand | Should -Be '"C:\cache\widget.exe" /uninstall /quiet'
        $byCode['{widget-msi}'].Kind | Should -Be 'Msi'
        $byCode['{widget-msi}'].UninstallCommand | Should -Be 'msiexec /x {widget-msi} /qn /norestart'
        $byCode['{gadget-exe}'].Kind | Should -Be 'Other'
        $byCode['{gadget-exe}'].UninstallCommand | Should -Be '"C:\gadget\remove.exe"'
        $byCode['{gadget-exe}'].DisplayVersion | Should -Be ''
    }

    It 'returns nothing for a pattern no entry matches' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_registry'; return
        }
        @(InModuleScope Catzc.Tooling.Toolchain { Get-RegisteredInstallProduct '^Unmatched' }).Count | Should -Be 0
    }
}
