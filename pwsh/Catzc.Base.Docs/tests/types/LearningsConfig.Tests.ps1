Describe 'Catzc.Base.Docs.LearningsConfig' -Tag 'L0', 'logic', 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.Docs.LearningsConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the LearningsConfig constructor to throw'
        }
    }

    It 'declares the defaults once, for an empty file and for no file alike' {
        foreach ($raw in $null, [ordered]@{}) {
            $config = [Catzc.Base.Docs.LearningsConfig]::new($raw)
            $config.folder | Should -BeExactly '.claude/learnings'
            @($config.files, $config.lines_per_file) | Should -Be @(5, 50)
        }
    }

    It 'maps every key' {
        $config = [Catzc.Base.Docs.LearningsConfig]::new([ordered]@{ folder = 'widget/learnings/'; files = 3; lines_per_file = 20 })
        $config.folder | Should -BeExactly 'widget/learnings'
        @($config.files, $config.lines_per_file) | Should -Be @(3, 20)
    }

    It 'rejects <Case>' -ForEach @(
        @{ Case = 'an unknown key'; Raw = [ordered]@{ gadget = 1 }; Expected = "*unknown key 'gadget'*" }
        @{ Case = 'an absolute folder'; Raw = [ordered]@{ folder = 'C:/learnings' }; Expected = "*folder 'C:/learnings'*" }
        @{ Case = 'a climbing folder'; Raw = [ordered]@{ folder = '../learnings' }; Expected = "*folder '../learnings'*" }
        @{ Case = 'no files'; Raw = [ordered]@{ files = 0 }; Expected = "*files '0' must be a whole number from 1 to 100*" }
        @{ Case = 'lines that are no whole number'; Raw = [ordered]@{ lines_per_file = '50' }; Expected = "*lines_per_file '50'*" }
    ) {
        Get-ViolationMessage $Raw | Should -BeLike $Expected
    }
}
