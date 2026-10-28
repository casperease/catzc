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

        It 'gives every file language of languages.yml a carrier entry, and every other entry its own files' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
            $carriers = Get-Config -Config file-carriers
            $languages = (Get-Config -Config languages).languages.name
            $missing = @($languages | Where-Object { $null -eq $carriers.Find($_) })
            $missing |
                Should -BeNullOrEmpty -Because "a file language with no carrier entry is a hidden gap: $($missing -join ', ')"
            $loose = @($carriers.carriers | Where-Object { $_.id -notin $languages -and $_.files.Count -eq 0 })
            @($loose | ForEach-Object id) |
                Should -BeNullOrEmpty -Because 'an entry that is no file language selects its files with files'
            $noForm = @($carriers.carriers | Where-Object { $_.carrier -eq [Catzc.Base.Languages.CarrierKind]::CommentHead -and $null -eq $_.Form() })
            @($noForm | ForEach-Object id) |
                Should -BeNullOrEmpty -Because 'every comment-head entry yields a head form'
            $carriers.Find('diagram-render').carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::PngText) -Because 'a committed generated format has a carrier'
            $carriers.Find('png').carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::PngText)
            $carriers.Find('svg').carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::Metadata)
            $carriers.Find('xml').carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::ProcessingInstruction)
            foreach ($glob in @($carriers.carriers | ForEach-Object { $_.exclude.Keys })) {
                { [Catzc.Base.Objects.GlobPattern]::new($glob) } |
                    Should -Not -Throw -Because "exclude '$glob' is a valid glob"
            }
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'reads a comment head with a line prefix, defaulting its anchor to the start' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $config = & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#' })
            $config.carriers[0] | Should -BeOfType [Catzc.Base.Languages.FileCarrier]
            $config.carriers[0].carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::CommentHead)
            $config.carriers[0].line | Should -Be '#'
            $config.carriers[0].anchor | Should -Be ([Catzc.Base.CodeMeta.HeadAnchor]::Start)
            $config.carriers[0].block | Should -BeNullOrEmpty
        }

        It 'reads a block-comment head below a prolog' {
            $config = & $script:one ([ordered]@{ carrier = 'comment-head'; block = @('<!--',
                        '-->'); anchor = 'after-prolog'
                })
            $config.carriers[0].block | Should -Be @('<!--', '-->')
            $config.carriers[0].anchor | Should -Be ([Catzc.Base.CodeMeta.HeadAnchor]::AfterProlog)
        }

        It 'reads a head that follows a fixed number of preamble lines' {
            $config = & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; anchor = 'after-preamble'; preamble_lines = 2 })
            $config.carriers[0].preamble_lines | Should -Be 2
        }

        It 'reads the globs an entry leaves out with their reasons, empty by default' -Tag 'ADR-REPO-FILEMETA-METAKIND' {
            $config = & $script:make ([ordered]@{ carriers = [ordered]@{
                        widget = [ordered]@{ carrier = 'comment-head'; line = '#'; exclude = [ordered]@{ '**/tests/**' = 'a test carries no help'; '**/assets/**' = ' copied verbatim ' } }
                        gadget = [ordered]@{ carrier = 'comment-head'; line = '#' }
                    }
                })
            $config.Find('widget').exclude.Count | Should -Be 2
            $config.Find('widget').exclude['**/tests/**'] | Should -Be 'a test carries no help'
            $config.Find('widget').exclude['**/assets/**'] | Should -Be 'copied verbatim'
            $config.Find('gadget').exclude.Count | Should -Be 0
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; exclude = 'tests' }) } |
                Should -Throw '*exclude must be a map of glob to the reason*'
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; exclude = [ordered]@{ 'a/**' = '' } }) } | Should -Throw '*needs a glob and a reason*'
        }

        It 'builds the head form of a comment-head entry, and none for any other carrier' -Tag 'ADR-REPO-CODEMETA-CODEFILEHEAD' {
            $config = & $script:make ([ordered]@{ carriers = [ordered]@{
                        widget = [ordered]@{ carrier = 'comment-head'; line = '#'; anchor = 'after-shebang' }
                        gadget = [ordered]@{ carrier = 'comment-head'; block = @('/*', '*/') }
                        cog    = [ordered]@{ carrier = 'front-matter' }
                    }
                })
            $widget = $config.Find('widget').Form()
            $widget | Should -BeOfType [Catzc.Base.CodeMeta.HeadForm]
            $widget.Line | Should -Be '#'
            $widget.Anchor | Should -Be ([Catzc.Base.CodeMeta.HeadAnchor]::AfterShebang)
            $gadget = $config.Find('gadget').Form()
            $gadget.IsBlock | Should -BeTrue
            $gadget.BlockOpen | Should -Be '/*'
            $gadget.BlockClose | Should -Be '*/'
            $config.Find('cog').Form() | Should -BeNullOrEmpty
        }

        It 'reads the openers of old heads a comment-head entry strips, and passes them to its head form' -Tag 'ADR-REPO-CODEMETA-CODEFILEHEAD' {
            $config = & $script:make ([ordered]@{ carriers = [ordered]@{
                        widget = [ordered]@{ carrier = 'comment-head'; block = @('/*', '*/'); strip = @('// catzc:') }
                        gadget = [ordered]@{ carrier = 'comment-head'; line = '#' }
                    }
                })
            $config.Find('widget').strip | Should -Be @('// catzc:')
            $config.Find('widget').Form().Strip | Should -Be @('// catzc:')
            $config.Find('gadget').strip.Count | Should -Be 0
            { & $script:one ([ordered]@{ carrier = 'front-matter'; strip = @('// catzc:') }) } |
                Should -Throw '*strip belongs to a comment-head or property carrier*'
            $property = & $script:make ([ordered]@{ carriers = [ordered]@{ widget = [ordered]@{ carrier = 'property'; property = '$comment'; strip = @('GENERATED FILE') } } })
            $property.Find('widget').strip | Should -Be @('GENERATED FILE')
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; strip = @(' # catzc:') }) } |
                Should -Throw '*without surrounding spaces*'
        }

        It 'reads front matter, a property and a reason for none, and keeps declared order' {
            $config = & $script:make ([ordered]@{ carriers = [ordered]@{
                        widget = [ordered]@{ carrier = 'front-matter' }
                        gadget = [ordered]@{ carrier = 'property'; property = '//' }
                        cog    = [ordered]@{ files = @('docs/*.png'); carrier = 'none'; reason = 'binary' }
                    }
                })
            $config.carriers.id | Should -Be @('widget', 'gadget', 'cog')
            $config.carriers[0].key |
                Should -Be 'catzc' -Because 'a front-matter block sits at the reserved top-level key unless the entry nests it'
            $config.carriers[1].key | Should -BeNullOrEmpty
            $config.carriers[1].property | Should -Be '//'
            $config.carriers[2].files | Should -Be @('docs/*.png')
            $config.carriers[2].reason | Should -Be 'binary'
            $config.Find('gadget').carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::Property)
            $config.Find('missing') | Should -BeNullOrEmpty
        }

        It 'reads a banner carrier''s one line, which only a banner carrier takes and needs' {
            $config = & $script:make ([ordered]@{ carriers = [ordered]@{ cog = [ordered]@{ files = @('**/cog.mod'); carrier = 'banner'; banner = '// widget. DO NOT EDIT.' } } })
            $config.Find('cog').carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::Banner)
            $config.Find('cog').banner | Should -BeExactly '// widget. DO NOT EDIT.'
            { & $script:one ([ordered]@{ carrier = 'banner' }) } | Should -Throw '*banner is required, and only allowed, for a banner carrier*'
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; banner = '# widget' }) } | Should -Throw '*banner is required, and only allowed*'
            { & $script:one ([ordered]@{ carrier = 'banner'; banner = " // widget`n" }) } | Should -Throw '*banner is one line*'
        }

        It 'is empty when the file declares nothing' {
            (& $script:make @{}).carriers | Should -BeNullOrEmpty
        }

        It 'rejects an unknown key, carrier and anchor, naming the allowed ones' {
            { & $script:make @{ other = 1 } } | Should -Throw "*unknown key 'other' (allowed: carriers)*"
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; shade = 1 }) } |
                Should -Throw "*unknown key 'shade'*"
            { & $script:one ([ordered]@{ carrier = 'gizmo' }) } |
                Should -Throw "*unknown carrier 'gizmo' (one of: front-matter, comment-head, property, banner, png-text, metadata, processing-instruction, none)*"
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; anchor = 'middle' }) } |
                Should -Throw "*unknown anchor 'middle' (one of: start, after-shebang, after-prolog, after-preamble)*"
            { & $script:one ([ordered]@{ carrier = '0' }) } | Should -Throw '*unknown carrier*'
        }

        It 'needs a carrier' {
            { & $script:one ([ordered]@{ line = '#' }) } |
                Should -Throw '*needs a carrier (one of: front-matter, comment-head, property, banner, png-text, metadata, processing-instruction, none)*'
        }

        It 'reads a png, svg and xml stamp carrier, each taking no key of a text carrier' -Tag 'ADR-REPO-FILEMETA-EVERYFORMATCARRIES' -ForEach @(
            @{ Name = 'png-text'; Kind = 'PngText' }, @{ Name = 'metadata'; Kind = 'Metadata' }, @{ Name = 'processing-instruction'; Kind = 'ProcessingInstruction' }
        ) {
            $config = & $script:one ([ordered]@{ files = @('docs/*.wdg'); carrier = $Name })
            $config.Find('widget').carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::$Kind)
            $config.Find('widget').Form() | Should -BeNullOrEmpty
            $config.Find('widget').key | Should -BeNullOrEmpty
            { & $script:one ([ordered]@{ carrier = $Name; line = '#' }) } | Should -Throw '*line and block belong to a comment-head carrier*'
            { & $script:one ([ordered]@{ carrier = $Name; property = '//' }) } | Should -Throw '*property is required, and only allowed*'
            { & $script:one ([ordered]@{ carrier = $Name; reason = 'binary' }) } | Should -Throw '*reason is required, and only allowed*'
            { & $script:one ([ordered]@{ carrier = $Name; strip = @('catzc') }) } | Should -Throw '*strip belongs to a comment-head or property carrier*'
        }

        It 'needs exactly one of line and block for a comment head, and rejects a bad delimiter' {
            { & $script:one ([ordered]@{ carrier = 'comment-head' }) } | Should -Throw '*exactly one of line and block*'
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; block = @('/*', '*/') }) } |
                Should -Throw '*exactly one of line and block*'
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '# ' }) } |
                Should -Throw '*non-empty comment prefix without spaces*'
            { & $script:one ([ordered]@{ carrier = 'comment-head'; block = @('<!--') }) } |
                Should -Throw '*opening and the closing delimiter*'
        }

        It 'nests a front-matter block under a key path that ends in catzc' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
            $nested = & $script:one ([ordered]@{ files = @('.widget/skills/**/SKILL.md'); carrier = 'front-matter'; key = 'metadata.catzc' })
            $nested.Find('widget').key | Should -Be 'metadata.catzc'
            { & $script:one ([ordered]@{ carrier = 'front-matter'; key = 'metadata' }) } |
                Should -Throw '*key is a dotted path of plain keys ending in catzc*'
            { & $script:one ([ordered]@{ carrier = 'property'; property = '//'; key = 'metadata.catzc' }) } |
                Should -Throw '*key belongs to a front-matter carrier*'
        }

        It 'keeps each key to the carrier that owns it' {
            { & $script:one ([ordered]@{ carrier = 'front-matter'; line = '#' }) } |
                Should -Throw '*line and block belong to a comment-head carrier*'
            { & $script:one ([ordered]@{ carrier = 'property'; property = '//'; anchor = 'start' }) } |
                Should -Throw '*anchor belongs to a comment-head carrier*'
            { & $script:one ([ordered]@{ carrier = 'property' }) } |
                Should -Throw '*property is required, and only allowed, for a property carrier*'
            { & $script:one ([ordered]@{ carrier = 'front-matter'; property = '//' }) } |
                Should -Throw '*property is required, and only allowed*'
            { & $script:one ([ordered]@{ carrier = 'none' }) } |
                Should -Throw '*reason is required, and only allowed, when the carrier is none*'
            { & $script:one ([ordered]@{ carrier = 'front-matter'; reason = 'why' }) } |
                Should -Throw '*reason is required, and only allowed*'
        }

        It 'ties preamble_lines to the after-preamble anchor' {
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; anchor = 'after-preamble' }) } |
                Should -Throw '*preamble_lines is required, and only allowed, with anchor after-preamble*'
            { & $script:one ([ordered]@{ carrier = 'comment-head'; line = '#'; preamble_lines = 2 }) } |
                Should -Throw '*preamble_lines is required, and only allowed*'
        }

        It 'knows no sidecar carrier: a file carries its block in its own text, or none' {
            { & $script:one ([ordered]@{ carrier = 'sidecar'; files = @('a/*.png') }) } |
                Should -Throw "*unknown carrier 'sidecar'*"
            { & $script:one ([ordered]@{ carrier = 'none'; reason = 'binary'; sidecar = '{base}.md' }) } |
                Should -Throw "*unknown key 'sidecar'*"
        }

        It 'rejects a bad id, a duplicate file glob and a non-map entry' {
            { & $script:make ([ordered]@{ carriers = [ordered]@{ Widget = [ordered]@{ carrier = 'front-matter' } } }) } | Should -Throw "*invalid file class id 'Widget'*"
            { & $script:one ([ordered]@{ carrier = 'none'; reason = 'x'; files = @('a', 'a') }) } |
                Should -Throw "*duplicate files entry 'a'*"
            { & $script:make ([ordered]@{ carriers = [ordered]@{ widget = 'front-matter' } }) } |
                Should -Throw '*must be a mapping*'
        }
    }
}
