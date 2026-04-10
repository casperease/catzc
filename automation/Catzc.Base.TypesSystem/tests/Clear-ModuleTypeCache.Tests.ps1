Describe 'Clear-ModuleTypeCache' -Tag 'L0' {
    # The fixture DLL name (BeforeEach) and the real-repo drift check both use the ONE shared hash
    # (Get-CombinedTypeHash, loaded by the importer) — the same function the janitor under test calls, so there is
    # no separate mirror to keep in step. The independent oracle for that function is the cross-language MSBuild
    # stamp (see the Import-CSharpTypes suite's 'IDE project build stamps …' test).

    BeforeEach {
        # Default: not a pipeline, so the function actually runs.
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.TypesSystem
        # Silence + capture the end-state reporting so the 'always reports' assertions can inspect it.
        Mock Write-Message -ModuleName Catzc.Base.TypesSystem { }

        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))

        # Build the fixture with [System.IO] rather than New-Item/Set-Content — the cmdlets carry ~20ms of
        # per-call overhead on Windows, which dominated this per-test setup. CreateDirectory makes parents too.
        foreach ($m in 'Mod.One', 'Mod.Two') {
            [System.IO.Directory]::CreateDirectory((Join-Path $root "$m/types")) | Out-Null
        }
        [System.IO.File]::WriteAllText((Join-Path $root 'Mod.One/types/Alpha.cs'), 'public class Alpha { }')
        [System.IO.File]::WriteAllText((Join-Path $root 'Mod.Two/types/Beta.cs'), 'public class Beta { }')

        $script:compiled = Join-Path $root '.compiled'
        [System.IO.Directory]::CreateDirectory($compiled) | Out-Null
        $hash8 = (Get-CombinedTypeHash $root).CombinedHash
        $script:currentDll = Join-Path $compiled "Catzc.Types.$hash8.dll"
        [System.IO.File]::WriteAllText($currentDll, 'current')
        $script:staleDll = Join-Path $compiled 'Catzc.Types.deadbeef.dll'
        [System.IO.File]::WriteAllText($staleDll, 'stale')

        $script:fakeRoot = $root
    }

    It 'keeps the current-hash build' -Tag 'logic' {
        Clear-ModuleTypeCache -AutomationRoot $fakeRoot
        $currentDll | Should -Exist
    }

    It 'deletes a superseded build' -Tag 'logic' {
        Clear-ModuleTypeCache -AutomationRoot $fakeRoot
        $staleDll | Should -Not -Exist
    }

    It 'prunes every build when no module has sources' -Tag 'logic' {
        Remove-Item (Join-Path $fakeRoot 'Mod.One/types/Alpha.cs') -Force
        Remove-Item (Join-Path $fakeRoot 'Mod.Two/types/Beta.cs') -Force
        Clear-ModuleTypeCache -AutomationRoot $fakeRoot
        @(Get-ChildItem $compiled -Filter '*.dll').Count | Should -Be 0
    }

    It 'with -DryRun lists the superseded build, never the current one, and deletes nothing' -Tag 'logic' {
        $planned = Clear-ModuleTypeCache -AutomationRoot $fakeRoot -DryRun
        @($planned).Count | Should -Be 1
        $planned | Should -Not -Contain $currentDll
        $staleDll | Should -Exist
        $currentDll | Should -Exist
    }

    It 'is a no-op in a pipeline with a single clean build (CI makes no source-control changes)' -Tag 'logic' {
        Remove-Item $staleDll -Force   # one build only, so the two-dll gate below stays quiet
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.TypesSystem
        { Clear-ModuleTypeCache -AutomationRoot $fakeRoot } | Should -Not -Throw
        $currentDll | Should -Exist
    }

    It 'warns when a superseded build sits next to the current one (devbox)' -Tag 'logic' {
        Clear-ModuleTypeCache -AutomationRoot $fakeRoot   # fixture has current + stale = two builds
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Warning }
    }

    It 'throws in a pipeline when a superseded build is committed (two dlls present)' -Tag 'logic' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.TypesSystem
        { Clear-ModuleTypeCache -AutomationRoot $fakeRoot } | Should -Throw '*more than one compiled type assembly*'
        $staleDll | Should -Exist   # CI made no source-control change — it threw before touching anything
    }

    It 'emits the two-dll warning even under -Silent (a locked/stale DLL must surface)' -Tag 'logic' {
        Clear-ModuleTypeCache -AutomationRoot $fakeRoot -Silent
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Warning }
    }

    It 'always reports its end state — even when nothing is superseded' -Tag 'logic' {
        Remove-Item $staleDll -Force   # only the current build remains → removed 0, skipped 0
        Clear-ModuleTypeCache -AutomationRoot $fakeRoot
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Message -match 'already clean' }
    }

    It 'reports the removed/skipped counts when it cleaned something' -Tag 'logic' {
        Clear-ModuleTypeCache -AutomationRoot $fakeRoot   # staleDll present → removed 1
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Message -match 'removed 1' }
    }

    It 'reports the pipeline skip as an end-state message (not silent)' -Tag 'logic' {
        Remove-Item $staleDll -Force   # single build, so it reaches the skip rather than the two-dll throw
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.TypesSystem
        Clear-ModuleTypeCache -AutomationRoot $fakeRoot
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Message -match 'pipeline' }
    }

    It 'reports the plan on -DryRun and returns the list' -Tag 'logic' {
        $planned = Clear-ModuleTypeCache -AutomationRoot $fakeRoot -DryRun
        @($planned).Count | Should -Be 1
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Message -match 'dry run' }
    }

    It 'with -Silent and a single clean build, writes nothing (the importer''s quiet default)' -Tag 'logic' {
        # The two-dll gate warns even under -Silent (covered above), so isolate the quiet path to one build.
        Remove-Item $staleDll -Force
        Clear-ModuleTypeCache -AutomationRoot $fakeRoot -Silent
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -Times 0
        $currentDll | Should -Exist
    }

    It 'never plans the live combined build for deletion (real repo, DryRun)' -Tag 'L1', 'integrity' {
        $h = (Get-CombinedTypeHash (Join-Path $env:RepositoryRoot 'automation')).CombinedHash
        $planned = Clear-ModuleTypeCache -DryRun
        @($planned) | Where-Object { $_ -match "Catzc\.Types\.$h\.dll$" } | Should -BeNullOrEmpty
    }

    It 'skips a locked superseded DLL and removes the rest without stalling' -Tag 'logic' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_file_lock'; return
        }

        # Add a second superseded build so one can be locked and the other still removed.
        $stale2 = Join-Path $compiled 'Catzc.Types.cafef00d.dll'
        Set-Content -Path $stale2 -Value 'stale2'

        Assert-FileIsNotLocked $staleDll                                      # precondition
        $stream = [System.IO.File]::Open($staleDll, 'Open', 'Read', 'None')   # hold an exclusive handle
        try {
            Assert-FileIsLocked $staleDll                                     # the lock is real
            { Clear-ModuleTypeCache -AutomationRoot $fakeRoot } | Should -Not -Throw
            $staleDll | Should -Exist        # locked one survives
            $stale2 | Should -Not -Exist     # unlocked superseded removed
            $currentDll | Should -Exist      # current build kept
        }
        finally {
            $stream.Dispose()
        }
    }

    It 'with -ThrowOnNonReleasedFromClrTypesDll, throws on a still-loaded superseded DLL (after removing the deletable ones)' -Tag 'logic' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_file_lock'; return
        }

        # A second superseded build stays deletable, so the throw only fires AFTER the removable stale is gone.
        $stale2 = Join-Path $compiled 'Catzc.Types.cafef00d.dll'
        Set-Content -Path $stale2 -Value 'stale2'

        $stream = [System.IO.File]::Open($staleDll, 'Open', 'Read', 'None')   # a loaded-DLL analogue: locked handle
        try {
            { Clear-ModuleTypeCache -AutomationRoot $fakeRoot -ThrowOnNonReleasedFromClrTypesDll } |
                Should -Throw '*restart PowerShell*'
            $staleDll | Should -Exist        # the still-loaded one survives (it is named in the throw)
            $stale2 | Should -Not -Exist     # the deletable stale build was removed first
            $currentDll | Should -Exist      # the current build is always kept
        }
        finally {
            $stream.Dispose()
        }
    }

    It 'without the switch, a still-loaded superseded DLL is skipped rather than thrown (importer-safe default)' -Tag 'logic' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_file_lock'; return
        }
        $stream = [System.IO.File]::Open($staleDll, 'Open', 'Read', 'None')
        try {
            { Clear-ModuleTypeCache -AutomationRoot $fakeRoot } | Should -Not -Throw
            $staleDll | Should -Exist
        }
        finally {
            $stream.Dispose()
        }
    }

    It 'skips a file it cannot delete for a non-lock reason without throwing' -Tag 'logic' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_read_only_delete'; return
        }

        $stale2 = Join-Path $compiled 'Catzc.Types.cafef00d.dll'
        Set-Content -Path $stale2 -Value 'stale2'
        Set-ItemProperty -Path $staleDll -Name IsReadOnly -Value $true   # File.Delete throws UnauthorizedAccess
        try {
            { Clear-ModuleTypeCache -AutomationRoot $fakeRoot } | Should -Not -Throw
            $staleDll | Should -Exist        # undeletable one survives, skipped
            $stale2 | Should -Not -Exist     # the deletable one still removed
        }
        finally {
            Set-ItemProperty -Path $staleDll -Name IsReadOnly -Value $false   # so TestDrive teardown can remove it
        }
    }
}
