<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/tests/Stop-FileLockingProcess.Tests.ps1
    folder: tests
    name: stop-file-locking-process-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Stop-FileLockingProcess' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:holder = {
            param([int] $Id)
            [Catzc.Base.Files.FileLockingProcess]::new($Id, 'widget.exe', [datetime]'2026-10-13 17:51')
        }
        $script:parentId = (Get-Process -Id $PID).Parent.Id
    }

    BeforeEach {
        Mock Write-Message { } -ModuleName Catzc.Base.TypesSystem
        Mock Stop-Process { } -ModuleName Catzc.Base.TypesSystem
        Mock Wait-Process { } -ModuleName Catzc.Base.TypesSystem
        $script:file = Join-Path $TestDrive 'Catzc.Types.deadbeef.dll'
    }

    It 'stops every other holder and announces each stop, naming the file' {
        $holders = @((& $script:holder 900001), (& $script:holder 900002))
        Mock Get-FileLockingProcess { $holders } -ModuleName Catzc.Base.TypesSystem

        InModuleScope Catzc.Base.TypesSystem -Parameters @{ F = $script:file } { param($F) Stop-FileLockingProcess -Path $F }

        Should -Invoke Stop-Process -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter { $Id -eq 900001 -and $Force }
        Should -Invoke Stop-Process -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter { $Id -eq 900002 -and $Force }
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -Times 2 -Exactly -ParameterFilter {
            $Message -like 'Stopping widget.exe (PID 90000*) — it holds Catzc.Types.deadbeef.dll.'
        }
    }

    It 'never stops this session or its parent, and says so' {
        $holders = @((& $script:holder $PID), (& $script:holder $script:parentId))
        Mock Get-FileLockingProcess { $holders } -ModuleName Catzc.Base.TypesSystem

        InModuleScope Catzc.Base.TypesSystem -Parameters @{ F = $script:file } { param($F) Stop-FileLockingProcess -Path $F }

        Should -Invoke Stop-Process -ModuleName Catzc.Base.TypesSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -Times 2 -Exactly -ParameterFilter { $Message -like 'Not stopping *this session or one of its parents*' }
    }

    It 'reports a holder it cannot stop and carries on with the next' {
        $holders = @((& $script:holder 900001), (& $script:holder 900002))
        Mock Get-FileLockingProcess { $holders } -ModuleName Catzc.Base.TypesSystem
        Mock Stop-Process { throw 'Access is denied' } -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Id -eq 900001 }

        InModuleScope Catzc.Base.TypesSystem -Parameters @{ F = $script:file } { param($F) Stop-FileLockingProcess -Path $F }

        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter { $Message -like 'Could not stop widget.exe (PID 900001*Access is denied*' }
        Should -Invoke Stop-Process -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter { $Id -eq 900002 }
    }

    It 'does nothing when nobody holds the file' {
        Mock Get-FileLockingProcess { } -ModuleName Catzc.Base.TypesSystem

        InModuleScope Catzc.Base.TypesSystem -Parameters @{ F = $script:file } { param($F) Stop-FileLockingProcess -Path $F }

        Should -Invoke Stop-Process -ModuleName Catzc.Base.TypesSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -Times 0
    }
}
