Describe 'FileCarriersConfig' -Tag 'L0' {
    BeforeAll {
        $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Base.Languages.FileCarriersConfig]::new($raw) }
        $script:one = {
            param([System.Collections.IDictionary] $entry)
            [Catzc.Base.Languages.FileCarriersConfig]::new([ordered]@{ carriers = [ordered]@{ widget = $entry } })
        }
    }

    Context 'integrity (shipped file-carriers.yml)' -Tag 'integrity' {
        It 'passes for the shipped file-carriers.yml' {
            Get-Config -Config file-carriers | Should -BeOfType [Catzc.Base.Languages.FileCarriersConfig]
        }

        It 'gives every file language of languages.yml a carrier entry, and every other entry its own files' -Tag 'ADR-REPO-FILEMETA#1' {
            $carriers = Get-Config -Config file-carriers
            $languages = (Get-Config -Config languages).languages.name
            $missing = @($languages | Where-Object { $null -eq $carriers.Find($_) })
            $missing | Should -BeNullOrEmpty -Because "a file language with no carrier entry is a hidden gap: $($missing -join ', ')"
            $loose = @($carriers.carriers | Where-Object { $_.id -notin $languages -and $_.files.Count -eq 0 })
            @($loose | ForEach-Object id) | Should -BeNullOrEmpty -Because 'an entry that is no file language selects its files with files'
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'reads a comment head with a line prefix, defaulting its anchor to the start' -Tag 'ADR-AUTO-DEFAULT#6' {
            $config = & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#' })
            $config.carriers[0] | Should -BeOfType [Catzc.Base.Languages.FileCarrier]
            $config.carriers[0].carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::CommentHead)
            $config.carriers[0].line | Should -Be '#'
            $config.carriers[0].anchor | Should -Be ([Catzc.Base.Languages.CarrierAnchor]::Start)
            $config.carriers[0].block | Should -BeNullOrEmpty
        }

        It 'reads a block-comment head below a prolog' {
            $config = & $script:one ([ordered]@{ carrier = 'comment-head'; block = @('<!--', '-->'); anchor = 'after-prolog' })
            $config.carriers[0].block | Should -Be @('<!--', '-->')
            $config.carriers[0].anchor | Should -Be ([Catzc.Base.Languages.CarrierAnchor]::AfterProlog)
        }

        It 'reads a head that follows a fixed number of preamble lines' {
            $config = & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; anchor = 'after-preamble'; preamble_lines = 2 })
            $config.carriers[0].preamble_lines | Should -Be 2
        }

        It 'reads front matter, a property, a sidecar and a reason for none, and keeps declared order' {
            $config = & $script:make ([ordered]@{ carriers = [ordered]@{
                        widget   = [ordered]@{ carrier = 'front-matter' }
                        gadget   = [ordered]@{ carrier = 'property'; property = '//' }
                        sprocket = [ordered]@{ files = @('docs/*.png'); carrier = 'sidecar'; sidecar = '{base}.md' }
                        cog      = [ordered]@{ carrier = 'none'; reason = 'binary' }
                    }
                })
            $config.carriers.id | Should -Be @('widget', 'gadget', 'sprocket', 'cog')
            $config.carriers[1].property | Should -Be '//'
            $config.carriers[2].sidecar | Should -Be '{base}.md'
            $config.carriers[2].files | Should -Be @('docs/*.png')
            $config.carriers[3].reason | Should -Be 'binary'
            $config.Find('gadget').carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::Property)
            $config.Find('missing') | Should -BeNullOrEmpty
        }

        It 'is empty when the file declares nothing' {
            (& $script:make @{}).carriers | Should -BeNullOrEmpty
        }

        It 'rejects an unknown key, carrier and anchor, naming the allowed ones' {
            { & $script:make @{ other = 1 } } | Should -Throw "*unknown key 'other' (allowed: carriers)*"
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; shade = 1 }) } | Should -Throw "*unknown key 'shade'*"
            { & $script:one ([ordered]@{ carrier = 'banner' }) } | Should -Throw "*unknown carrier 'banner' (one of: front-matter, comment-head, property, sidecar, none)*"
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; anchor = 'middle' }) } | Should -Throw "*unknown anchor 'middle' (one of: start, after-shebang, after-prolog, after-preamble)*"
            { & $script:one ([ordered]@{ carrier = '0' }) } | Should -Throw '*unknown carrier*'
        }

        It 'needs a carrier' {
            { & $script:one ([ordered]@{ line = '#' }) } | Should -Throw '*needs a carrier (one of: front-matter, comment-head, property, sidecar, none)*'
        }

        It 'needs exactly one of line and block for a comment head, and rejects a bad delimiter' {
            { & $script:one ([ordered]@{ carrier = 'comment-head' }) } | Should -Throw '*exactly one of line and block*'
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; block = @('/*', '*/') }) } | Should -Throw '*exactly one of line and block*'
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '# ' }) } | Should -Throw '*non-empty comment prefix without spaces*'
            { & $script:one ([ordered]@{ carrier = 'comment-head'; block = @('<!--') }) } | Should -Throw '*opening and the closing delimiter*'
        }

        It 'keeps each key to the carrier that owns it' {
            { & $script:one ([ordered]@{ carrier = 'front-matter'; line = '#' }) } | Should -Throw '*line and block belong to a comment-head carrier*'
            { & $script:one ([ordered]@{ carrier = 'property'; property = '//'; anchor = 'start' }) } | Should -Throw '*anchor belongs to a comment-head carrier*'
            { & $script:one ([ordered]@{ carrier = 'property' }) } | Should -Throw '*property is required, and only allowed, for a property carrier*'
            { & $script:one ([ordered]@{ carrier = 'front-matter'; property = '//' }) } | Should -Throw '*property is required, and only allowed*'
            { & $script:one ([ordered]@{ carrier = 'none' }) } | Should -Throw '*reason is required, and only allowed, when the carrier is none*'
            { & $script:one ([ordered]@{ carrier = 'front-matter'; reason = 'why' }) } | Should -Throw '*reason is required, and only allowed*'
        }

        It 'ties preamble_lines to the after-preamble anchor' {
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; anchor = 'after-preamble' }) } | Should -Throw '*preamble_lines is required, and only allowed, with anchor after-preamble*'
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; preamble_lines = 2 }) } | Should -Throw '*preamble_lines is required, and only allowed*'
        }

        It 'needs a sidecar template that names {base}, and the files it covers' {
            { & $script:one ([ordered]@{ carrier = 'sidecar'; files = @('a/*.png'); sidecar = 'notes.md' }) } | Should -Throw '*names {base}*'
            { & $script:one ([ordered]@{ carrier = 'sidecar'; sidecar = '{base}.md' }) } | Should -Throw '*selects its files with files*'
        }

        It 'rejects a bad id, a duplicate file glob and a non-map entry' {
            { & $script:make ([ordered]@{ carriers = [ordered]@{ Widget = [ordered]@{ carrier = 'front-matter' } } }) } | Should -Throw "*invalid file class id 'Widget'*"
            { & $script:one ([ordered]@{ carrier = 'none'; reason = 'x'; files = @('a', 'a') }) } | Should -Throw "*duplicate files entry 'a'*"
            { & $script:make ([ordered]@{ carriers = [ordered]@{ widget = 'front-matter' } }) } | Should -Throw '*must be a mapping*'
        }
    }
}
