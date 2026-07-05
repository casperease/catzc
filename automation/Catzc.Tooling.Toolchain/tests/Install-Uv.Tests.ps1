Describe 'Install-Uv' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'uv'; version = '0.11' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Install-Tool { } -ModuleName Catzc.Tooling.Toolchain
        Mock Invoke-Executable { } -ModuleName Catzc.Tooling.Toolchain
        Mock Sync-SessionPath { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolVersion { '0.11.26' } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'bootstraps via winget when uv is absent' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Toolchain
        Install-Uv
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'is idempotent when already at the locked version' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Toolchain
        Install-Uv
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'self-updates a standalone uv that is off-pin' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolVersion { '0.9.5' } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-Command { [pscustomobject]@{ Source = 'C:\Users\me\.local\bin\uv.exe' } } -ParameterFilter { $Name -eq 'uv' } -ModuleName Catzc.Tooling.Toolchain
        Install-Uv
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Command -eq 'uv self update' }
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'routes a winget-installed uv through the winget upgrade path' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolVersion { '0.9.5' } -ModuleName Catzc.Tooling.Toolchain
        $wingetUv = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages\astral-sh.uv_x\uv.exe'
        Mock Get-Command { [pscustomobject]@{ Source = $wingetUv } } -ParameterFilter { $Name -eq 'uv' } -ModuleName Catzc.Tooling.Toolchain
        Install-Uv -Force
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 0
    }
}
