Describe 'Uninstall-Dotnet' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'dotnet' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ScriptInstallDir { Join-Path ([IO.Path]::GetTempPath()) 'fake-dotnet' } -ModuleName Catzc.Tooling.Toolchain
        # Not installed → the managed body hits "nothing to do" and touches no env state.
        Mock Test-Path { $false } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-Dotnet { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'runs the managed uninstall only, by default' {
        Uninstall-Dotnet
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'escalates to Remove-Dotnet -Force with -Remove -Force' -Tag 'ADR-AUTO-REMOVE#5' {
        Uninstall-Dotnet -Remove -Force
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Force -eq $true }
    }

    It 'escalates as a dry-run when -Remove has no -Force' -Tag 'ADR-AUTO-REMOVE#4' {
        Uninstall-Dotnet -Remove
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { -not $Force }
    }

    It 'still evicts when the managed uninstall fails' -Tag 'ADR-AUTO-REMOVE#5' {
        Mock Get-ScriptInstallDir { throw 'boom' } -ModuleName Catzc.Tooling.Toolchain
        Uninstall-Dotnet -Remove -Force
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 1
    }

    It 'propagates a managed failure when not escalating' {
        Mock Get-ScriptInstallDir { throw 'boom' } -ModuleName Catzc.Tooling.Toolchain
        { Uninstall-Dotnet } | Should -Throw '*boom*'
    }
}
