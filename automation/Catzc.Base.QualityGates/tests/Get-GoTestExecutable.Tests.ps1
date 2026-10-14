# Get-GoTestExecutable with the Go folder discovery and the tool probe mocked: the source session hands down the
# managed go only when it is found at the pin, and probes nothing when there are no Go tests. Neutral fixture paths
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-GoTestExecutable' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:folders = @([pscustomobject]@{ Folder = 'C:\widget\go\tests\catzc-widget'; Module = 'Catzc.Widget' })
        $script:probe = [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\widget\go\bin\go.exe' }
        Mock Get-GoTestFolders -ModuleName Catzc.Base.QualityGates { $script:folders }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'go' } { $script:probe }
    }

    It 'returns the path of a go found at the pin' {
        InModuleScope Catzc.Base.QualityGates { Get-GoTestExecutable } | Should -Be 'C:\widget\go\bin\go.exe'
    }

    It 'returns empty when <Case>' -ForEach @(
        @{ Case = 'go is not found'; Found = $false; VersionOk = $false }
        @{ Case = 'go misses the pin'; Found = $true; VersionOk = $false }
    ) {
        $script:probe = [pscustomobject]@{ Found = $Found; VersionOk = $VersionOk; Path = 'C:\widget\go\bin\go.exe' }
        InModuleScope Catzc.Base.QualityGates { Get-GoTestExecutable } | Should -BeExactly ''
    }

    It 'returns empty without probing go when the repository has no Go test folder' {
        $script:folders = @()
        InModuleScope Catzc.Base.QualityGates { Get-GoTestExecutable } | Should -BeExactly ''
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }
}
