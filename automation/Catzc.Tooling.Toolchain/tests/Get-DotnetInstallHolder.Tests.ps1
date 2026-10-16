<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/tests/Get-DotnetInstallHolder.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Get-DotnetInstallHolder' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:installDir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
    }

    It 'lists nothing when the install has no host resolver folder' {
        [System.IO.Directory]::CreateDirectory($script:installDir) | Out-Null
        Mock Get-FileLockingProcess { throw 'must not be asked' } -ModuleName Catzc.Tooling.Toolchain
        @(InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Dir = $script:installDir } { param($Dir) Get-DotnetInstallHolder -InstallDir $Dir }).Count |
            Should -Be 0
    }

    It 'lists the holders of every host resolver version, each process once' {
        foreach ($version in '8.0.1', '10.0.5') {
            $folder = Join-Path $script:installDir "host/fxr/$version"
            [System.IO.Directory]::CreateDirectory($folder) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $folder 'hostfxr.dll'), '')
        }
        Mock Get-FileLockingProcess {
            [Catzc.Base.Files.FileLockingProcess]::new(4242, 'widget', [datetime]'2026-01-01')
            if ($Path -like '*10.0.5*') {
                [Catzc.Base.Files.FileLockingProcess]::new(4343, 'gadget', [datetime]'2026-01-01')
            }
        } -ModuleName Catzc.Tooling.Toolchain

        $holders = @(InModuleScope Catzc.Tooling.Toolchain -Parameters @{ Dir = $script:installDir } { param($Dir) Get-DotnetInstallHolder -InstallDir $Dir })
        @($holders.ProcessId | Sort-Object) | Should -Be @(4242, 4343)
        Should -Invoke Get-FileLockingProcess -ModuleName Catzc.Tooling.Toolchain -Times 2 -Exactly
    }
}
