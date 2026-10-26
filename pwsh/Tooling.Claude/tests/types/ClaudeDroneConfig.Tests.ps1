Describe 'Catzc.Tooling.Claude.ClaudeDroneConfig' -Tag 'L0', 'logic', 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Tooling.Claude.ClaudeDroneConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the ClaudeDroneConfig constructor to throw'
        }
    }

    It 'declares every default once, for an empty file and for no file alike' {
        foreach ($raw in $null, [ordered]@{}) {
            [Catzc.Tooling.Claude.ClaudeDroneConfig]::new($raw).launcher | Should -BeExactly 'windows-terminal'
        }
    }

    It 'maps every key' {
        [Catzc.Tooling.Claude.ClaudeDroneConfig]::new([ordered]@{ launcher = 'pwsh' }).launcher | Should -BeExactly 'pwsh'
    }

    It 'rejects <Case>' -ForEach @(
        @{ Case = 'an unknown key'; Raw = [ordered]@{ widget = 1 }; Expected = "*unknown key 'widget'*" }
        @{ Case = 'the agent key, since a skill picks its drone'; Raw = [ordered]@{ agent = 'widget-agent' }; Expected = "*unknown key 'agent'*" }
        @{ Case = 'an unknown launcher'; Raw = [ordered]@{ launcher = 'gadget' }; Expected = "*launcher 'gadget' must be one of: windows-terminal, pwsh*" }
    ) {
        Get-ViolationMessage $Raw | Should -BeLike $Expected
    }

    It 'reports every violation at once' {
        $message = Get-ViolationMessage ([ordered]@{ widget = 1; launcher = 'gadget' })
        $message | Should -BeLike '*widget*'
        $message | Should -BeLike '*launcher*'
    }
}
