Describe 'Catzc.Tooling.Claude.EditorClaimsConfig' -Tag 'L0', 'logic', 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Tooling.Claude.EditorClaimsConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the EditorClaimsConfig constructor to throw'
        }
    }

    It 'declares every default once, for an empty file and for no file alike' {
        foreach ($raw in $null, [ordered]@{}) {
            [Catzc.Tooling.Claude.EditorClaimsConfig]::new($raw).shared_configs | Should -Be @('timeouts', 'dependencies')
        }
    }

    It 'maps every key' {
        [Catzc.Tooling.Claude.EditorClaimsConfig]::new([ordered]@{ shared_configs = @('widget', 'gadget-parts') }).shared_configs |
            Should -Be @('widget', 'gadget-parts')
    }

    It 'rejects <Case>' -ForEach @(
        @{ Case = 'an unknown key'; Raw = [ordered]@{ widget = 1 }; Expected = "*unknown key 'widget'*" }
        @{ Case = 'a single name in place of a list'; Raw = [ordered]@{ shared_configs = 'widget' }; Expected = '*shared_configs must be a list*' }
        @{ Case = 'a name that is not a config name'; Raw = [ordered]@{ shared_configs = @('Widget.yml') }; Expected = "*entry 'Widget.yml' is not a config name*" }
        @{ Case = 'a name listed twice'; Raw = [ordered]@{ shared_configs = @('widget', 'widget') }; Expected = "*names 'widget' twice*" }
    ) {
        Get-ViolationMessage $Raw | Should -BeLike $Expected
    }

    It 'reports every violation at once' {
        $message = Get-ViolationMessage ([ordered]@{ widget = 1; shared_configs = @('Gadget') })
        $message | Should -BeLike '*widget*'
        $message | Should -BeLike '*Gadget*'
    }
}
