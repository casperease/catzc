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
            $config = [Catzc.Tooling.Claude.ClaudeDroneConfig]::new($raw)
            $config.agent | Should -BeExactly 'catzc-drone'
            $config.launcher | Should -BeExactly 'windows-terminal'
        }
    }

    It 'maps every key' {
        $config = [Catzc.Tooling.Claude.ClaudeDroneConfig]::new([ordered]@{ agent = 'widget-agent'; launcher = 'pwsh' })
        $config.agent | Should -BeExactly 'widget-agent'
        $config.launcher | Should -BeExactly 'pwsh'
    }

    It 'rejects <Case>' -ForEach @(
        @{ Case = 'an unknown key'; Raw = [ordered]@{ widget = 1 }; Expected = "*unknown key 'widget'*" }
        @{ Case = 'an agent that is not kebab-case'; Raw = [ordered]@{ agent = 'Widget Agent' }; Expected = "*agent 'Widget Agent' must be a kebab-case agent name*" }
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
