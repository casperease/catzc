Describe 'Remove-LinuxToolInstall' -Tag 'L1', 'logic' {
    BeforeEach {
        # A neutral fixture tool (ADR-AUTO-TEST:3) — never a real tool identity.
        $script:config = [pscustomobject]@{ command = 'widget'; pip_package = 'widgetlib' }

        Mock Write-Message { } -ModuleName Catzc.Tooling.Core
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Core
        Mock Get-Command { [pscustomobject]@{ Source = '/usr/bin/widget' } } -ParameterFilter { $Name -eq 'widget' } -ModuleName Catzc.Tooling.Core

        # Defaults: the tool is on PATH; dpkg / uv are absent; every external probe reports "not found".
        # Individual tests enable the mechanism they exercise.
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Mock Test-Command { $true } -ParameterFilter { $Command -eq 'widget' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 1; Output = '' } } -ModuleName Catzc.Tooling.Core
    }

    It 'removes an apt-owned shadow via its owning package and asserts root' -Tag 'ADR-AUTO-REMOVE#6', 'ADR-AUTO-REMOVE#7' {
        Mock Test-Command { $true } -ParameterFilter { $Command -eq 'dpkg' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = 'gadget-cli: /usr/bin/widget' } } -ParameterFilter { $Command -like 'dpkg -S*' } -ModuleName Catzc.Tooling.Core

        Remove-LinuxToolInstall -Config $config | Should -BeTrue
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Core -Times 1
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter { $Command -eq 'sudo apt-get remove -y gadget-cli' }
    }

    It 'refuses the apt path when not elevated — apt needs root' -Tag 'ADR-AUTO-REMOVE#6' {
        Mock Test-Command { $true } -ParameterFilter { $Command -eq 'dpkg' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = 'gadget-cli: /usr/bin/widget' } } -ParameterFilter { $Command -like 'dpkg -S*' } -ModuleName Catzc.Tooling.Core
        Mock Assert-IsAdministrator { throw 'needs root' } -ModuleName Catzc.Tooling.Core

        { Remove-LinuxToolInstall -Config $config } | Should -Throw '*needs root*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 0 -ParameterFilter { $Command -like 'sudo apt-get remove*' }
    }

    It 'removes a uv-Python pip shadow user-space, without asserting root' -Tag 'ADR-AUTO-REMOVE#6', 'ADR-AUTO-REMOVE#7' {
        Mock Test-Command { $true } -ParameterFilter { $Command -eq 'uv' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = 'Name: widgetlib' } } -ParameterFilter { $Command -like 'uv pip show*' } -ModuleName Catzc.Tooling.Core

        Remove-LinuxToolInstall -Config $config | Should -BeTrue
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter { $Command -eq 'uv pip uninstall --system widgetlib' }
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'apt ownership wins over a uv-pip shadow (precedence)' -Tag 'ADR-AUTO-REMOVE#7' {
        Mock Test-Command { $true } -ParameterFilter { $Command -eq 'dpkg' } -ModuleName Catzc.Tooling.Core
        Mock Test-Command { $true } -ParameterFilter { $Command -eq 'uv' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = 'gadget-cli: /usr/bin/widget' } } -ParameterFilter { $Command -like 'dpkg -S*' } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = 'Name: widgetlib' } } -ParameterFilter { $Command -like 'uv pip show*' } -ModuleName Catzc.Tooling.Core

        Remove-LinuxToolInstall -Config $config | Should -BeTrue
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter { $Command -like 'sudo apt-get remove*' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 0 -ParameterFilter { $Command -like 'uv pip uninstall*' }
    }

    It 'deletes a stray on-PATH binary no manager owns, user-space' -Tag 'ADR-AUTO-REMOVE#6', 'ADR-AUTO-REMOVE#7' {
        # dpkg / uv both absent (defaults) — fall through to the stray-file delete. Point the command at a real
        # file under TestDrive so the delete has something to remove.
        $strayPath = Join-Path $TestDrive 'widget'
        [System.IO.File]::WriteAllText($strayPath, 'binary')
        Mock Get-Command { [pscustomobject]@{ Source = $strayPath } } -ParameterFilter { $Name -eq 'widget' } -ModuleName Catzc.Tooling.Core

        Remove-LinuxToolInstall -Config $config | Should -BeTrue
        $strayPath | Should -Not -Exist
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'returns false and touches nothing when the tool is not on PATH' -Tag 'ADR-AUTO-REMOVE#3' {
        Mock Test-Command { $false } -ParameterFilter { $Command -eq 'widget' } -ModuleName Catzc.Tooling.Core

        Remove-LinuxToolInstall -Config $config | Should -BeFalse
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 0
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Core -Times 0
    }
}
