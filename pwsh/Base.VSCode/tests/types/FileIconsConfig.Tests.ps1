Describe 'Catzc.Base.VSCode.FileIconsConfig' -Tag 'L0' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.VSCode.FileIconsConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the FileIconsConfig constructor to throw'
        }
    }

    Context 'logic' -Tag 'logic' {
        It 'keeps the default file colour and reads each icon, extensions without their dot' {
            $config = [Catzc.Base.VSCode.FileIconsConfig]::new([ordered]@{ icons = [ordered]@{
                        widget   = [ordered]@{ glyph = 'gadget'; color = '#ABCDEF'; extensions = @('.WDG',
                                'tests.wdg')
                        }
                        sprocket = [ordered]@{ label = 'SPR'; color = '#123456'; names = @('.gadget') }
                    }
                })
            $config.file | Should -Be ([Catzc.Base.VSCode.FileIconsConfig]::DefaultFile)
            @($config.icons.name) | Should -Be @('widget', 'sprocket')
            $config.icons[0].extensions | Should -Be @('wdg', 'tests.wdg')
            $config.icons[0].color | Should -Be '#abcdef'
            $config.icons[1].label | Should -Be 'SPR'
            $config.icons[1].names | Should -Be @('.gadget')
        }

        It 'reports a bad key, glyph and label together, a bad colour, a file with no match, and a file two icons claim' {
            $message = Get-ViolationMessage ([ordered]@{ file = 'blue'; folder = '#123456'; icons = [ordered]@{
                        widget    = [ordered]@{ glyph = 'gadget'; label = 'W'; color = '#123456'; extensions = @('wdg'); shape = 'round' }
                        gadget    = [ordered]@{ label = 'TOO LONG'; color = 'red' }
                        sprocket  = [ordered]@{ label = 'S'; color = '#123456'; extensions = @('WDG'); style = 'fancy' }
                        cog       = [ordered]@{ glyph = 'gadget'; style = 'prompt'; color = '#123456'; language = 'cogs' }
                        'cog-two' = [ordered]@{ label = 'C'; color = '#123456'; language = 'cogs' }
                        sprite    = [ordered]@{ label = 'R'; color = '#cb6b6b'; extensions = @('spr') }
                        flame     = [ordered]@{ label = 'F'; color = '#e0823d'; extensions = @('flm') }
                    }
                })
            $message | Should -BeLike "*'file' must be a six-digit hex colour*"
            $message | Should -BeLike "*icon 'sprite': color '#cb6b6b' is a red, which marks an error only*"
            $message | Should -Not -BeLike "*icon 'flame'*"
            $message | Should -BeLike "*unknown top-level key 'folder' (allowed: file, icons)*"
            $message | Should -BeLike "*icon 'widget': unknown key 'shape'*"
            $message | Should -BeLike "*icon 'widget' needs exactly one of 'glyph' or 'label'*"
            $message | Should -BeLike "*icon 'gadget': label 'TOO LONG'*"
            $message | Should -BeLike "*icon 'gadget': color 'red'*"
            $message | Should -BeLike "*icon 'gadget' marks no file*"
            $message | Should -BeLike "*'`*.wdg' is marked by both 'widget' and 'sprocket'*"
            $message | Should -BeLike "*icon 'sprocket': style 'fancy' is unknown*"
            $message | Should -BeLike "*icon 'cog': 'style' applies to a label only*"
            $message | Should -BeLike "*'language cogs' is marked by both 'cog' and 'cog-two'*"
        }
    }
}
