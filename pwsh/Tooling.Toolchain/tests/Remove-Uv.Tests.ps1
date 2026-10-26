Describe 'Remove-Uv' -Tag 'L0', 'logic', 'ADR-AUTO-REMOVE-REMOVEREFUSESMANAGED' {
    BeforeEach {
        if (-not $IsWindows) {
            return
        }
        $script:widgetDir = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:widgetDir) | Out-Null
        foreach ($name in 'uv.exe', 'uvx.exe', 'gadget.exe') {
            [System.IO.File]::WriteAllText((Join-Path $script:widgetDir $name), '')
        }
        Mock Get-ToolConfig { @{ command = 'uv'; winget_id = 'widget.uv' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-ExpectedPackageManager { $Path -like '*managed-widget*' } -ModuleName Catzc.Tooling.Toolchain
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'refuses the managed install' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        { Remove-Uv -InstallDir (Join-Path $TestDrive 'managed-widget') -Force } | Should -Throw '*is the managed uv install*'
    }

    It 'only reports the plan without -Force' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Remove-Uv -InstallDir $script:widgetDir
        [System.IO.File]::Exists((Join-Path $script:widgetDir 'uv.exe')) | Should -BeTrue
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 2 -Exactly -ParameterFilter { $Message -like 'Would remove:*' }
    }

    It 'deletes only uv''s own binaries with -Force, keeping the shared folder and its other tools, with no elevation' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Remove-Uv -InstallDir $script:widgetDir -Force
        [System.IO.File]::Exists((Join-Path $script:widgetDir 'uv.exe')) | Should -BeFalse
        [System.IO.File]::Exists((Join-Path $script:widgetDir 'uvx.exe')) | Should -BeFalse
        [System.IO.File]::Exists((Join-Path $script:widgetDir 'gadget.exe')) | Should -BeTrue
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'targets the folder of the uv on PATH by default' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_removal'; return
        }
        Mock Get-Command { [pscustomobject]@{ Source = 'C:\widget\stray\uv.exe' } } -ModuleName Catzc.Tooling.Toolchain
        Remove-Uv
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Message -eq 'No uv binary in C:\widget\stray — nothing to remove' }
    }
}
