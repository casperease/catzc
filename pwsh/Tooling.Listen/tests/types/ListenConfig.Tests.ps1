Describe 'Catzc.Tooling.Listen.ListenConfig' -Tag 'L0', 'logic', 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Tooling.Listen.ListenConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the ListenConfig constructor to throw'
        }
    }

    Context 'defaults' {
        It 'declares every default once, for an empty file and for no file alike' {
            foreach ($raw in $null, [ordered]@{}) {
                $config = [Catzc.Tooling.Listen.ListenConfig]::new($raw)
                $config.watch | Should -BeExactly 'docs'
                $config.output | Should -BeExactly 'out/listen'
                @($config.poll_milliseconds, $config.quiet_seconds, $config.change_wait_seconds,
                    $config.note_wait_seconds) | Should -Be @(1000, 20, 3600, 300)
                @($config.tiers.name) | Should -Be @('rule', 'docs')
                $config.rest_tier | Should -BeExactly 'code'
            }
        }

        It 'keeps the processor''s wait under the background roof of the time safeguard' {
            [Catzc.Tooling.Listen.ListenConfig]::DefaultNoteWaitSeconds | Should -BeLessThan 360
        }
    }

    Context 'mapping' {
        It 'maps every key, trimming a trailing slash from the folders' {
            $config = [Catzc.Tooling.Listen.ListenConfig]::new([ordered]@{
                    watch               = 'widget/docs/'
                    output              = 'out/gadget'
                    poll_milliseconds   = 250
                    quiet_seconds       = 0
                    change_wait_seconds = 60
                    note_wait_seconds   = 30
                    tiers               = @([ordered]@{ name = 'widget'; kinds = @('record', 'how-to') })
                    rest_tier           = 'gadget'
                })
            $config.watch | Should -BeExactly 'widget/docs'
            $config.output | Should -BeExactly 'out/gadget'
            @($config.poll_milliseconds, $config.quiet_seconds, $config.change_wait_seconds,
                $config.note_wait_seconds) | Should -Be @(250, 0, 60, 30)
            $config.tiers[0].kinds | Should -Be @('record', 'how-to')
            $config.rest_tier | Should -BeExactly 'gadget'
        }

        It 'names the first tier that lists a kind, and the rest tier for any other kind or none' {
            $config = [Catzc.Tooling.Listen.ListenConfig]::new($null)
            $config.TierOf('record') | Should -BeExactly 'rule'
            $config.TierOf('diagram') | Should -BeExactly 'docs'
            $config.TierOf('function') | Should -BeExactly 'code'
            $config.TierOf($null) | Should -BeExactly 'code'
        }
    }

    Context 'rejections' {
        It 'rejects <Case>' -ForEach @(
            @{ Case = 'an unknown key'; Raw = [ordered]@{ widget = 1 }; Expected = "*unknown key 'widget'*" }
            @{ Case = 'an absolute watch folder'; Raw = [ordered]@{ watch = 'C:/docs' }; Expected = "*watch 'C:/docs' must be a repository-relative folder*" }
            @{ Case = 'a climbing output folder'; Raw = [ordered]@{ output = 'out/../widget' }; Expected = "*output 'out/../widget'*" }
            @{ Case = 'a backslash folder'; Raw = [ordered]@{ watch = 'docs\widget' }; Expected = '*forward slashes*' }
            @{ Case = 'a poll below its floor'; Raw = [ordered]@{ poll_milliseconds = 10 }; Expected = "*poll_milliseconds '10' must be a whole number from 100 to 60000*" }
            @{ Case = 'a quiet window that is no whole number'; Raw = [ordered]@{ quiet_seconds = '5' }; Expected = "*quiet_seconds '5'*" }
            @{ Case = 'a note wait above its roof'; Raw = [ordered]@{ note_wait_seconds = 4000 }; Expected = '*note_wait_seconds*1 to 3600*' }
            @{ Case = 'tiers that are no list'; Raw = [ordered]@{ tiers = 'rule' }; Expected = '*tiers must be a list*' }
            @{ Case = 'a tier without kinds'; Raw = [ordered]@{ tiers = @([ordered]@{ name = 'widget'; kinds = @() }) }; Expected = '*tier 0 kinds must be a non-empty list*' }
            @{ Case = 'a tier name that is not kebab-case'; Raw = [ordered]@{ tiers = @([ordered]@{ name = 'Widget'; kinds = @('record') }) }; Expected = "*tier 0 name 'Widget'*" }
            @{ Case = 'a repeated tier name'; Raw = [ordered]@{ tiers = @([ordered]@{ name = 'widget'; kinds = @('record') }, [ordered]@{ name = 'widget'; kinds = @('script') }) }; Expected = "*repeats the name 'widget'*" }
            @{ Case = 'a kind in two tiers'; Raw = [ordered]@{ tiers = @([ordered]@{ name = 'widget'; kinds = @('record') }, [ordered]@{ name = 'gadget'; kinds = @('record') }) }; Expected = "*kind 'record', which an earlier tier holds*" }
            @{ Case = 'an unknown tier key'; Raw = [ordered]@{ tiers = @([ordered]@{ name = 'widget'; kinds = @('record'); gizmo = 1 }) }; Expected = "*unknown key 'gizmo'*" }
            @{ Case = 'a rest tier that is also a listed tier'; Raw = [ordered]@{ rest_tier = 'rule' }; Expected = "*rest_tier 'rule' is also the name of a listed tier*" }
        ) {
            Get-ViolationMessage $Raw | Should -BeLike $Expected
        }

        It 'reports every violation at once' {
            $message = Get-ViolationMessage ([ordered]@{ widget = 1; quiet_seconds = -1 })
            $message | Should -BeLike '*widget*'
            $message | Should -BeLike '*quiet_seconds*'
        }
    }
}
