Describe 'Assert-DevBoxToolsStatus' -Tag 'L0', 'logic' {
    # Get-ToolsStatus is the only boundary — mock it to return fabricated ToolStatus rows and assert the
    # pass/throw decision. The rows use deliberately non-production tool names.
    BeforeAll {
        $script:ok = [Catzc.Tooling.Provisioning.ToolStatus]::new('alpha', '1.x', '1.2', 'OK', '/bin/alpha', 'winget', 'user', 'None')
        $script:usable = [Catzc.Tooling.Provisioning.ToolStatus]::new('beta', '2.x', '2.0', 'Usable', '/bin/beta', 'other', 'user', 'Works, but not managed')
        $script:missing = [Catzc.Tooling.Provisioning.ToolStatus]::new('gamma', '3.x', $null, 'Missing', $null, $null, $null, 'Run Install-Gamma')
        $script:wrong = [Catzc.Tooling.Provisioning.ToolStatus]::new('delta', '4.x', '3.9', 'WrongVersion', '/bin/delta', 'winget', 'user', 'Run Install-Delta -Force')
    }

    It 'does not throw when every tool is OK or Usable' {
        Mock Get-ToolsStatus { $script:ok, $script:usable } -ModuleName Catzc.Tooling.Provisioning
        { Assert-DevBoxToolsStatus } | Should -Not -Throw
    }

    It 'throws when a tool is Missing' {
        Mock Get-ToolsStatus { $script:ok, $script:missing } -ModuleName Catzc.Tooling.Provisioning
        { Assert-DevBoxToolsStatus } | Should -Throw '*Tools not ready*'
    }

    It 'throws when a tool is at the wrong version' {
        Mock Get-ToolsStatus { $script:wrong } -ModuleName Catzc.Tooling.Provisioning
        { Assert-DevBoxToolsStatus } | Should -Throw '*Tools not ready*'
    }

    It 'names the failing tool, its locked/found versions, and its action in the message' {
        Mock Get-ToolsStatus { $script:missing, $script:wrong } -ModuleName Catzc.Tooling.Provisioning
        $message = $null
        try {
            Assert-DevBoxToolsStatus
        }
        catch {
            $message = $_.Exception.Message
        }
        $message | Should -BeLike '*gamma*'
        $message | Should -BeLike '*not installed*'      # Missing tool has no Installed version
        $message | Should -BeLike '*Run Install-Gamma*'
        $message | Should -BeLike '*delta*'
        $message | Should -BeLike '*3.9*'                # WrongVersion tool reports what was found
    }
}
