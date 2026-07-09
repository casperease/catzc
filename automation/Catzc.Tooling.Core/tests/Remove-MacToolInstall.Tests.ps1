Describe 'Remove-MacToolInstall' -Tag 'L1', 'logic' {
    BeforeEach {
        # A neutral fixture tool (ADR-AUTO-TEST:3) — never a real tool identity.
        $script:config = [pscustomobject]@{ command = 'widget'; pip_package = 'widgetlib' }

        Mock Write-Message { } -ModuleName Catzc.Tooling.Core
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Core
        Mock Get-Command { [pscustomobject]@{ Source = '/opt/homebrew/bin/widget' } } -ParameterFilter { $Name -eq 'widget' } -ModuleName Catzc.Tooling.Core

        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Mock Test-Command { $true } -ParameterFilter { $Command -eq 'widget' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 1; Output = '' } } -ModuleName Catzc.Tooling.Core
    }

    It 'uninstalls a Homebrew-owned shadow by its formula, user-space' -Tag 'ADR-AUTO-REMOVE#6', 'ADR-AUTO-REMOVE#7' {
        Mock Test-Command { $true } -ParameterFilter { $Command -eq 'brew' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = '/opt/homebrew' } } -ParameterFilter { $Command -eq 'brew --prefix' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = '../Cellar/gadget-formula/1.2.3/bin/widget' } } -ParameterFilter { $Command -like 'readlink *' } -ModuleName Catzc.Tooling.Core

        Remove-MacToolInstall -Config $config | Should -BeTrue
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter { $Command -eq 'brew uninstall --force gadget-formula' }
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'falls through to the uv-pip shadow when brew does not own the binary' -Tag 'ADR-AUTO-REMOVE#7' {
        Mock Test-Command { $true } -ParameterFilter { $Command -eq 'brew' } -ModuleName Catzc.Tooling.Core
        Mock Test-Command { $true } -ParameterFilter { $Command -eq 'uv' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = '/opt/homebrew' } } -ParameterFilter { $Command -eq 'brew --prefix' } -ModuleName Catzc.Tooling.Core
        # Binary lives outside the brew prefix — not brew-owned.
        Mock Get-Command { [pscustomobject]@{ Source = '/usr/local/other/widget' } } -ParameterFilter { $Name -eq 'widget' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = 'Name: widgetlib' } } -ParameterFilter { $Command -like 'uv pip show*' } -ModuleName Catzc.Tooling.Core

        Remove-MacToolInstall -Config $config | Should -BeTrue
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter { $Command -eq 'uv pip uninstall --system widgetlib' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 0 -ParameterFilter { $Command -like 'brew uninstall*' }
    }

    It 'deletes a stray binary when no manager owns it, user-space' -Tag 'ADR-AUTO-REMOVE#6' {
        $strayPath = Join-Path $TestDrive 'widget'
        [System.IO.File]::WriteAllText($strayPath, 'binary')
        Mock Get-Command { [pscustomobject]@{ Source = $strayPath } } -ParameterFilter { $Name -eq 'widget' } -ModuleName Catzc.Tooling.Core

        Remove-MacToolInstall -Config $config | Should -BeTrue
        $strayPath | Should -Not -Exist
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'returns false and touches nothing when the tool is not on PATH' -Tag 'ADR-AUTO-REMOVE#3' {
        Mock Test-Command { $false } -ParameterFilter { $Command -eq 'widget' } -ModuleName Catzc.Tooling.Core
        Remove-MacToolInstall -Config $config | Should -BeFalse
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 0
    }
}
