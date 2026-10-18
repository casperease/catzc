Describe 'AdrChecksConfig' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES-NATIVETYPEDMODEL' {
    Context 'defaults' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        It 'gives every check the gate mode and empty lists when the file states nothing' {
            foreach ($raw in @($null, [ordered]@{})) {
                $config = [Catzc.Base.Docs.AdrChecksConfig]::new($raw)
                $config.engine_neutrality.mode | Should -Be ([Catzc.Base.Docs.CheckMode]::Gate)
                $config.engine_neutrality.domains | Should -HaveCount 0
                $config.engine_neutrality.tokens | Should -HaveCount 0
                $config.citation_graph.mode | Should -Be ([Catzc.Base.Docs.CheckMode]::Gate)
                $config.code_language.mode | Should -Be ([Catzc.Base.Docs.CheckMode]::Gate)
                $config.dora_coverage.mode | Should -Be ([Catzc.Base.Docs.CheckMode]::Gate)
                $config.dora_coverage.file | Should -Be 'dora-explains.md'
                $config.dora_coverage.exempt.Count | Should -Be 0
                $config.dora_coverage.exempt_folders.Count | Should -Be 0
            }
        }

        It 'declares the default mode once, as gate, the zero value of CheckMode' {
            [System.Activator]::CreateInstance([Catzc.Base.Docs.CheckMode]) | Should -Be ([Catzc.Base.Docs.CheckMode]::Gate)
        }
    }

    Context 'a stated config' -Tag 'ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        BeforeAll {
            $script:config = [Catzc.Base.Docs.AdrChecksConfig]::new([ordered]@{
                    engine_neutrality = [ordered]@{
                        mode    = 'report'
                        domains = @('widget', 'gadget')
                        tokens  = [ordered]@{ 'gizmo-call' = '\bGizmo-[A-Z][a-z]+\b'; 'dollar-name' = '\$[a-z]+' }
                    }
                    citation_graph    = [ordered]@{ mode = 'Report' }
                    dora_coverage     = [ordered]@{ mode = 'gate'; file = 'widget-notes.md'; exempt = [ordered]@{ gizmo = 'Gizmo keeps its own notes.' } }
                    code_language     = [ordered]@{ mode = 'REPORT' }
                })
        }

        It 'reads each check''s mode, case-insensitively' {
            $config.engine_neutrality.mode | Should -Be ([Catzc.Base.Docs.CheckMode]::Report)
            $config.citation_graph.mode | Should -Be ([Catzc.Base.Docs.CheckMode]::Report)
            $config.code_language.mode | Should -Be ([Catzc.Base.Docs.CheckMode]::Report)
            $config.dora_coverage.mode | Should -Be ([Catzc.Base.Docs.CheckMode]::Gate)
        }

        It 'reads the domains, the tokens in file order, the file, and the exempt domains with their reasons' {
            $config.engine_neutrality.domains | Should -Be @('widget', 'gadget')
            $config.engine_neutrality.tokens.name | Should -Be @('gizmo-call', 'dollar-name')
            $config.engine_neutrality.tokens[0].pattern | Should -Be '\bGizmo-[A-Z][a-z]+\b'
            $config.dora_coverage.file | Should -Be 'widget-notes.md'
            $config.dora_coverage.exempt['gizmo'] | Should -Be 'Gizmo keeps its own notes.'
        }

        It 'finds every distinct match of a token in a line, case-sensitively' {
            $token = $config.engine_neutrality.tokens[0]
            $token.Find('Call Gizmo-Spin, then Gizmo-Stop, then Gizmo-Spin; never gizmo-spin.') | Should -Be @('Gizmo-Spin', 'Gizmo-Stop')
            $token.Find('No gizmo here.') | Should -HaveCount 0
            $token.Find('') | Should -HaveCount 0
        }
    }

    Context 'validation' {
        It 'throws once, naming every violation' {
            $raw = [ordered]@{
                widget            = 1
                engine_neutrality = [ordered]@{
                    mode    = 'loud'
                    colour  = 'red'
                    domains = @('widget', 'widget')
                    tokens  = [ordered]@{ 'Bad Name' = 'x'; 'broken' = '(unclosed'; 'empty' = '' }
                }
                citation_graph    = 'report'
                dora_coverage     = [ordered]@{
                    file           = 'notes/widget.md'
                    exempt         = [ordered]@{ gizmo = ' ' }
                    exempt_folders = [ordered]@{ 'widget' = 'A domain, not a subfolder.'; 'widget/sub' = '' }
                }
            }
            $thrown = { [Catzc.Base.Docs.AdrChecksConfig]::new($raw) } | Should -Throw -PassThru
            $message = $thrown.Exception.Message
            $message | Should -BeLike '*adr-checks.yml is invalid*'
            $message | Should -BeLike "*adr-checks: unknown key 'widget'*"
            $message | Should -BeLike "*engine_neutrality: unknown key 'colour'*"
            $message | Should -BeLike "*engine_neutrality: mode 'loud' is not one of: gate, report*"
            $message | Should -BeLike "*engine_neutrality: domain 'widget' is listed twice*"
            $message | Should -BeLike "*token name 'Bad Name' must be kebab-case*"
            $message | Should -BeLike "*token 'broken' pattern does not compile*"
            $message | Should -BeLike "*token 'empty' needs a pattern*"
            $message | Should -BeLike '*citation_graph: must be a mapping*'
            $message | Should -BeLike "*dora_coverage: file 'notes/widget.md' must be a markdown file name, with no folder*"
            $message | Should -BeLike "*dora_coverage: exempt domain 'gizmo' needs a reason*"
            $message | Should -BeLike "*dora_coverage: exempt folder 'widget' must be a '/'-separated subfolder of a domain*"
            $message | Should -BeLike "*dora_coverage: exempt folder 'widget/sub' needs a reason*"
        }
    }
}
