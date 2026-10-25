Describe 'Catzc.Base.VSCode.LampPaletteConfig' -Tag 'L0' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.VSCode.LampPaletteConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the LampPaletteConfig constructor to throw'
        }
    }

    Context 'logic' -Tag 'logic' {
        It 'declares every range with every shade when nothing is overridden' {
            $config = [Catzc.Base.VSCode.LampPaletteConfig]::new([ordered]@{ ranges = [ordered]@{} })
            @($config.ranges.Keys) | Should -Be @('committed', 'staged', 'unstaged', 'failed', 'empty', 'veto')
            $config.ranges['staged'].glyph_lit | Should -Match '^#[0-9a-f]{6}$'
            $config.ranges['unstaged'].background | Should -Match '^#[0-9a-f]{8}$'
        }

        It 'overrides one shade and keeps the others at their default' {
            $default = [Catzc.Base.VSCode.LampPaletteConfig]::new([ordered]@{})
            $config = [Catzc.Base.VSCode.LampPaletteConfig]::new([ordered]@{ ranges = [ordered]@{ empty = [ordered]@{ text = '#ABCDEF' } } })
            $config.ranges['empty'].text | Should -Be '#abcdef'
            $config.ranges['empty'].glyph_unlit | Should -Be $default.ranges['empty'].glyph_unlit
        }

        It 'reports an unknown range, an unknown shade and a shade that is no hex in one throw' {
            $raw = [ordered]@{
                ranges = [ordered]@{
                    widget = [ordered]@{}
                    failed = [ordered]@{ gadget = '#000000'; mark = 'red'; badge = '#12345' }
                }
            }
            $message = Get-ViolationMessage $raw
            $message | Should -BeLike "*unknown range 'widget'*"
            $message | Should -BeLike "*range 'failed': unknown shade 'gadget'*"
            $message | Should -BeLike "*shade 'mark' must be #rrggbb or #rrggbbaa*"
            $message | Should -BeLike "*shade 'badge' must be #rrggbb or #rrggbbaa*"
        }

        It 'refuses an unknown top-level key' {
            Get-ViolationMessage ([ordered]@{ widget = 1 }) | Should -BeLike "*unknown top-level key 'widget'*"
        }
    }

    Context 'integrity (shipped config)' -Tag 'integrity' {
        It 'the shipped lamp-palette.yml loads and validates' {
            $config = Get-Config -Config lamp-palette
            $config | Should -BeOfType ([Catzc.Base.VSCode.LampPaletteConfig])
            $config.ranges.Count | Should -Be 6
        }
    }
}
