<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-types-system/tests/Clear-ModuleTypeCache.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Clear-ModuleTypeCache' -Tag 'L0' {

    BeforeEach {
        # Default: source mode, not a pipeline, so the function actually runs (in the source and build runs).
        Mock Get-CatzcRunMode { 'source' } -ModuleName Catzc.Base.TypesSystem
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.TypesSystem
        # Silence + capture the end-state reporting so the 'always reports' assertions can inspect it.
        Mock Write-Message -ModuleName Catzc.Base.TypesSystem { }

        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))

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
        $script:currentManifest = [System.IO.Path]::ChangeExtension($currentDll, 'json')
        $script:staleManifest = [System.IO.Path]::ChangeExtension($staleDll, 'json')
        [System.IO.File]::WriteAllText($currentManifest, '{}')
        [System.IO.File]::WriteAllText($staleManifest, '{}')

        $script:fakeRoot = $root
    }

    It 'removes a superseded build''s manifest with it and keeps the current manifest' -Tag 'logic' {
        Clear-ModuleTypeCache -ModulesRoot $fakeRoot
        $staleManifest | Should -Not -Exist
        $currentManifest | Should -Exist
    }

    It 'with -DryRun leaves every manifest in place' -Tag 'logic' {
        Clear-ModuleTypeCache -ModulesRoot $fakeRoot -DryRun | Out-Null
        $staleManifest | Should -Exist
    }

    It 'keeps the current-hash build' -Tag 'logic' {
        Clear-ModuleTypeCache -ModulesRoot $fakeRoot
        $currentDll | Should -Exist
    }

    It 'deletes a superseded build' -Tag 'logic' {
        Clear-ModuleTypeCache -ModulesRoot $fakeRoot
        $staleDll | Should -Not -Exist
    }

    It 'prunes every build when no module has sources' -Tag 'logic' {
        Remove-Item (Join-Path $fakeRoot 'Mod.One/types/Alpha.cs') -Force
        Remove-Item (Join-Path $fakeRoot 'Mod.Two/types/Beta.cs') -Force
        Clear-ModuleTypeCache -ModulesRoot $fakeRoot
        @(Get-ChildPath $compiled -File -Filter '*.dll' -Depth 1).Count | Should -Be 0
    }

    It 'with -DryRun lists the superseded build, never the current one, and deletes nothing' -Tag 'logic' {
        $planned = Clear-ModuleTypeCache -ModulesRoot $fakeRoot -DryRun
        @($planned).Count | Should -Be 1
        $planned | Should -Not -Contain $currentDll
        $staleDll | Should -Exist
        $currentDll | Should -Exist
    }

    It 'is a no-op in a pipeline with a single clean build (CI makes no source-control changes)' -Tag 'logic' {
        Remove-Item $staleDll -Force   # one build only, so the two-dll guard below stays quiet
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.TypesSystem
        { Clear-ModuleTypeCache -ModulesRoot $fakeRoot } | Should -Not -Throw
        $currentDll | Should -Exist
    }

    It 'throws in a pipeline when a superseded build is committed (two dlls present)' -Tag 'logic' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.TypesSystem
        { Clear-ModuleTypeCache -ModulesRoot $fakeRoot } | Should -Throw '*more than one compiled type assembly*'
        $staleDll | Should -Exist   # CI made no source-control change — it threw before touching anything
    }

    It 'always reports its end state — even when nothing is superseded' -Tag 'logic' {
        Remove-Item $staleDll -Force   # only the current build remains → removed 0, skipped 0
        Clear-ModuleTypeCache -ModulesRoot $fakeRoot
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Message -match 'already clean' }
    }

    It 'reports the removed/skipped counts when it cleaned something' -Tag 'logic' {
        Clear-ModuleTypeCache -ModulesRoot $fakeRoot   # staleDll present → removed 1
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Message -match 'removed 1' }
    }

    It 'reports the pipeline skip as an end-state message (not silent)' -Tag 'logic' {
        Remove-Item $staleDll -Force   # single build, so it reaches the skip rather than the two-dll throw
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.TypesSystem
        Clear-ModuleTypeCache -ModulesRoot $fakeRoot
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Message -match 'pipeline' }
    }

    It 'reports the plan on -DryRun and returns the list' -Tag 'logic' {
        $planned = Clear-ModuleTypeCache -ModulesRoot $fakeRoot -DryRun
        @($planned).Count | Should -Be 1
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Message -match 'dry run' }
    }

    It 'with -Silent, writes nothing while it cleans (the importer''s quiet default)' -Tag 'logic' {
        Clear-ModuleTypeCache -ModulesRoot $fakeRoot -Silent
        $staleDll | Should -Not -Exist
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -Times 0
        $currentDll | Should -Exist
    }

    It 'is a no-op in build mode on the loaded package root — it never deletes inside an installed build' -Tag 'logic' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.TypesSystem
        Mock Get-CatzcModulesRoot { $fakeRoot } -ModuleName Catzc.Base.TypesSystem
        $planned = Clear-ModuleTypeCache -DryRun
        @($planned).Count | Should -Be 0
        Clear-ModuleTypeCache
        $staleDll | Should -Exist
        Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { "$Message" -like '*built Catzc package*' }
    }

    It 'still cleans an explicit root other than the loaded package in build mode' -Tag 'logic' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.TypesSystem
        Mock Get-CatzcModulesRoot { Join-Path $TestDrive 'widget-build' } -ModuleName Catzc.Base.TypesSystem
        Clear-ModuleTypeCache -ModulesRoot $fakeRoot
        $staleDll | Should -Not -Exist
        $currentDll | Should -Exist
    }

    It 'never plans the live combined build for deletion (real repo, DryRun)' -Tag 'L1', 'integrity', 'source-only' {
        $h = (Get-CombinedTypeHash (Get-CatzcModulesRoot)).CombinedHash
        $planned = Clear-ModuleTypeCache -DryRun
        @($planned) | Where-Object { $_ -match "Catzc\.Types\.$h\.dll$" } | Should -BeNullOrEmpty
    }

    It 'keeps a held superseded DLL, names its holder in one yellow line, and never throws, stops or waits' -Tag 'logic' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_file_lock'; return
        }

        # A second superseded build stays deletable, so the held one is the only survivor.
        $stale2 = Join-Path $compiled 'Catzc.Types.cafef00d.dll'
        [System.IO.File]::WriteAllText($stale2, 'stale2')
        Mock Start-Sleep { throw 'the janitor never waits on a holder' } -ModuleName Catzc.Base.TypesSystem

        $stream = [System.IO.File]::Open($staleDll, 'Open', 'Read', 'None')   # a session's bound instance
        try {
            { Clear-ModuleTypeCache -ModulesRoot $fakeRoot } | Should -Not -Throw
            $staleDll | Should -Exist        # the held one survives until its holder exits
            $stale2 | Should -Not -Exist     # the deletable stale build was removed
            $currentDll | Should -Exist      # the current build is always kept
            Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -Times 1 -Exactly -ParameterFilter {
                $Message -like "*still open*Catzc.Types.deadbeef.dll, held by this session (PID $PID)*holder exits*" -and $ForegroundColor -eq 'Yellow'
            }
        }
        finally {
            $stream.Dispose()
        }
    }

    It 'with -Silent, keeps a held superseded DLL without a word' -Tag 'logic' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_file_lock'; return
        }

        $stream = [System.IO.File]::Open($staleDll, 'Open', 'Read', 'None')
        try {
            { Clear-ModuleTypeCache -ModulesRoot $fakeRoot -Silent } | Should -Not -Throw
            $staleDll | Should -Exist
            Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -Times 0
        }
        finally {
            $stream.Dispose()
        }
    }

    It 'reports the delete error when the holder lookup finds nobody or fails' -Tag 'logic' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_read_only_delete'; return
        }

        Mock Get-FileLockingProcess { throw 'widget lookup failure' } -ModuleName Catzc.Base.TypesSystem
        Set-ItemProperty -Path $staleDll -Name IsReadOnly -Value $true   # File.Delete throws UnauthorizedAccess
        try {
            { Clear-ModuleTypeCache -ModulesRoot $fakeRoot } | Should -Not -Throw
            $staleDll | Should -Exist
            Should -Invoke Write-Message -ModuleName Catzc.Base.TypesSystem -ParameterFilter { $Message -like '*Catzc.Types.deadbeef.dll (*' }
        }
        finally {
            Set-ItemProperty -Path $staleDll -Name IsReadOnly -Value $false   # so TestDrive teardown can remove it
        }
    }
}
