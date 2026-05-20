Describe 'Install-DevBoxTools' -Tag 'L0', 'logic' {
    # Pure orchestration over mocked seams. With an empty install order the version-locked loop is a no-op,
    # so the test focuses on the fixed sequence (de-choco, status, additional installers) and the two
    # decision points that are pure logic: the "usable but unmanaged" report and the missing-installer guard.
    BeforeEach {
        Mock Uninstall-Chocolatey { } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolsStatus { @() } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolInstallOrder { @() } -ModuleName Catzc.Tooling.Provisioning
        Mock Install-Git { } -ModuleName Catzc.Tooling.Provisioning
        Mock Install-Postman { } -ModuleName Catzc.Tooling.Provisioning
    }

    It 'removes Chocolatey, reads status, and installs the additional tools' {
        Install-DevBoxTools
        Should -Invoke Uninstall-Chocolatey -ModuleName Catzc.Tooling.Provisioning -Times 1
        Should -Invoke Get-ToolsStatus -ModuleName Catzc.Tooling.Provisioning -Times 1
        Should -Invoke Install-Git -ModuleName Catzc.Tooling.Provisioning -Times 1
        Should -Invoke Install-Postman -ModuleName Catzc.Tooling.Provisioning -Times 1
    }

    It 'forwards -Force to the additional installers' {
        Install-DevBoxTools -Force
        Should -Invoke Install-Git -ModuleName Catzc.Tooling.Provisioning -Times 1 -ParameterFilter { $Force }
        Should -Invoke Install-Postman -ModuleName Catzc.Tooling.Provisioning -Times 1 -ParameterFilter { $Force }
    }

    It 'reports a tool that is usable but not managed, and leaves it untouched' {
        $usable = [Catzc.Tooling.Provisioning.ToolStatus]::new('beta', '2.x', '2.0', 'Usable', '/bin/beta', 'other', 'user', 'Works, but not managed')
        Mock Get-ToolsStatus { $usable } -ModuleName Catzc.Tooling.Provisioning
        Mock Write-Message { } -ModuleName Catzc.Tooling.Provisioning
        Install-DevBoxTools
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Message -like '*Skipping beta*' }
    }

    It 'throws when a locked tool has no matching Install- function' {
        Mock Get-ToolInstallOrder { @('mystery') } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolCommandSuffix { 'Mystery' } -ModuleName Catzc.Tooling.Provisioning
        { Install-DevBoxTools } | Should -Throw '*No Install-Mystery function found*'
    }
}
