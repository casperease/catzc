<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/tests/Stop-DotnetInstallHolder.Tests.ps1
    folder: tests
    name: stop-dotnet-install-holder-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Stop-DotnetInstallHolder' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:installDir = Join-Path $TestDrive 'widget-dotnet'
        $script:widget = [Catzc.Base.Files.FileLockingProcess]::new(4242, 'widget', [datetime]'2026-01-01')
        # A stand-in for the running process: WaitForExit is all the function asks of it.
        $script:running = [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name WaitForExit -Value { $true } -PassThru
        Mock Get-Process { $script:running } -ModuleName Catzc.Tooling.Toolchain
        Mock Stop-Process { } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-DotnetInstallHolder { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'stops exactly the named process ids, announcing each' {
        $gadget = [Catzc.Base.Files.FileLockingProcess]::new(4343, 'gadget', [datetime]'2026-01-01')
        InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Dir = $script:installDir; Holders = @($script:widget, $gadget) } {
            param($Dir, $Holders) Stop-DotnetInstallHolder -InstallDir $Dir -Holder $Holders
        }
        Should -Invoke Stop-Process -ModuleName Catzc.Tooling.Toolchain -Times 2 -Exactly
        Should -Invoke Stop-Process -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Id -eq 4242 }
        Should -Invoke Stop-Process -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Id -eq 4343 }
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Message -like 'Stopping widget (PID 4242*' }
    }

    It 'skips a holder that already exited' {
        Mock Get-Process { } -ModuleName Catzc.Tooling.Toolchain
        InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Dir = $script:installDir; Holders = @($script:widget) } {
            param($Dir, $Holders) Stop-DotnetInstallHolder -InstallDir $Dir -Holder $Holders
        }
        Should -Invoke Stop-Process -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'refuses to stop the calling session and stops nothing' {
        $self = [Catzc.Base.Files.FileLockingProcess]::new($PID, 'pwsh', [datetime]'2026-01-01')
        {
            InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Dir = $script:installDir; Holders = @($script:widget, $self) } {
                param($Dir, $Holders) Stop-DotnetInstallHolder -InstallDir $Dir -Holder $Holders
            }
        } | Should -Throw '*this session*holds*'
        Should -Invoke Stop-Process -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'throws when the install is still held after stopping the named processes' {
        $gadget = [Catzc.Base.Files.FileLockingProcess]::new(4343, 'gadget', [datetime]'2026-01-01')
        Mock Get-DotnetInstallHolder { $gadget } -ModuleName Catzc.Tooling.Toolchain
        {
            InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Dir = $script:installDir; Holders = @($script:widget) } {
                param($Dir, $Holders) Stop-DotnetInstallHolder -InstallDir $Dir -Holder $Holders
            }
        } | Should -Throw '*still held open*gadget (PID 4343*'
    }
}
