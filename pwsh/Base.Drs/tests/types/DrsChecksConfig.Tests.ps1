Describe 'DrsChecksConfig' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
    Context 'defaults' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        It 'gives every check the gate mode and empty lists when the file states nothing' {
            foreach ($raw in @($null, [ordered]@{})) {
                $config = [Catzc.Base.Drs.DrsChecksConfig]::new($raw)
                $config.engine_neutrality.mode | Should -Be ([Catzc.Base.Reports.CheckMode]::Gate)
                $config.engine_neutrality.domains.Count | Should -Be 0
                $config.engine_neutrality.token_sets.Count | Should -Be 0
                $config.engine_neutrality.TokensFor('widget') | Should -HaveCount 0
                $config.citation_graph.mode | Should -Be ([Catzc.Base.Reports.CheckMode]::Gate)
                $config.code_language.mode | Should -Be ([Catzc.Base.Reports.CheckMode]::Gate)
                $config.dora_coverage.mode | Should -Be ([Catzc.Base.Reports.CheckMode]::Gate)
                $config.dora_coverage.file | Should -Be 'dora-explains.md'
                $config.dora_coverage.exempt.Count | Should -Be 0
                $config.dora_coverage.exempt_folders.Count | Should -Be 0
            }
        }

        It 'declares the default mode once, as gate, the zero value of CheckMode' {
            [System.Activator]::CreateInstance([Catzc.Base.Reports.CheckMode]) |
                Should -Be ([Catzc.Base.Reports.CheckMode]::Gate)
        }
    }

    Context 'a stated config' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        BeforeAll {
            $script:config = [Catzc.Base.Drs.DrsChecksConfig]::new([ordered]@{
                    engine_neutrality = [ordered]@{
                        mode       = 'report'
                        domains    = [ordered]@{ widget = @('engine'); gadget = @('vendor', 'engine') }
                        token_sets = [ordered]@{
                            engine = [ordered]@{ 'gizmo-call' = '\bGizmo-[A-Z][a-z]+\b'; 'dollar-name' = '\$[a-z]+' }
                            vendor = [ordered]@{ 'acme-name' = '\bAcme\b' }
                        }
                    }
                    citation_graph    = [ordered]@{ mode = 'Report'; exempt = [ordered]@{ widget = 'Widget binds to gadget.' } }
                    dora_coverage     = [ordered]@{ mode = 'gate'; file = 'widget-notes.md'; exempt = [ordered]@{ gizmo = 'Gizmo keeps its own notes.' } }
                    code_language     = [ordered]@{ mode = 'REPORT' }
                })
        }

        It 'reads the citation graph''s exempt domains with their reasons' {
            $config.citation_graph.exempt.Count | Should -Be 1
            $config.citation_graph.exempt['widget'] | Should -Be 'Widget binds to gadget.'
        }

        It 'reads each check''s mode, case-insensitively' {
            $config.engine_neutrality.mode | Should -Be ([Catzc.Base.Reports.CheckMode]::Report)
            $config.citation_graph.mode | Should -Be ([Catzc.Base.Reports.CheckMode]::Report)
            $config.code_language.mode | Should -Be ([Catzc.Base.Reports.CheckMode]::Report)
            $config.dora_coverage.mode | Should -Be ([Catzc.Base.Reports.CheckMode]::Gate)
        }

        It 'reads the domains with their sets, the token sets in file order, the file, and the exempt domains with their reasons' {
            @($config.engine_neutrality.domains.Keys) | Should -Be @('widget', 'gadget')
            $config.engine_neutrality.domains['gadget'] | Should -Be @('vendor', 'engine')
            $config.engine_neutrality.token_sets['engine'].name | Should -Be @('gizmo-call', 'dollar-name')
            $config.engine_neutrality.token_sets['engine'][0].pattern | Should -Be '\bGizmo-[A-Z][a-z]+\b'
            $config.dora_coverage.file | Should -Be 'widget-notes.md'
            $config.dora_coverage.exempt['gizmo'] | Should -Be 'Gizmo keeps its own notes.'
        }

        It 'gives a domain the tokens of its sets, in its set order' {
            $config.engine_neutrality.TokensFor('widget').name | Should -Be @('gizmo-call', 'dollar-name')
            $config.engine_neutrality.TokensFor('gadget').name | Should -Be @('acme-name', 'gizmo-call', 'dollar-name')
            $config.engine_neutrality.TokensFor('gizmo') | Should -HaveCount 0
        }

        It 'finds every distinct match of a token in a line, case-sensitively' {
            $token = $config.engine_neutrality.token_sets['engine'][0]
            $token.Find('Call Gizmo-Spin, then Gizmo-Stop, then Gizmo-Spin; never gizmo-spin.') |
                Should -Be @('Gizmo-Spin', 'Gizmo-Stop')
            $token.Find('No gizmo here.') | Should -HaveCount 0
            $token.Find('') | Should -HaveCount 0
        }
    }

    Context 'validation' {
        It 'throws once, naming every violation' {
            $raw = [ordered]@{
                widget            = 1
                engine_neutrality = [ordered]@{
                    mode       = 'loud'
                    colour     = 'red'
                    domains    = [ordered]@{ widget = @('engine', 'engine'); gadget = @('gizmo'); sprocket = 'engine' }
                    token_sets = [ordered]@{
                        engine    = [ordered]@{ 'Bad Name' = 'x'; 'broken' = '(unclosed'; 'empty' = '' }
                        'Bad Set' = [ordered]@{ 'fine' = 'x' }
                        flat      = 'x'
                    }
                }
                citation_graph    = 'report'
                dora_coverage     = [ordered]@{
                    file           = 'notes/widget.md'
                    exempt         = [ordered]@{ gizmo = ' ' }
                    exempt_folders = [ordered]@{ 'widget' = 'A domain, not a subfolder.'; 'widget/sub' = '' }
                }
            }
            $thrown = { [Catzc.Base.Drs.DrsChecksConfig]::new($raw) } | Should -Throw -PassThru
            $message = $thrown.Exception.Message
            $message | Should -BeLike '*drs-checks.yml is invalid*'
            $message | Should -BeLike "*drs-checks: unknown key 'widget'*"
            $message | Should -BeLike "*engine_neutrality: unknown key 'colour'*"
            $message | Should -BeLike "*engine_neutrality: mode 'loud' is not one of: gate, report*"
            $message | Should -BeLike "*engine_neutrality: domain 'widget' names token set 'engine' twice*"
            $message | Should -BeLike "*engine_neutrality: domain 'gadget' names token set 'gizmo', which token_sets does not declare*"
            $message | Should -BeLike "*engine_neutrality: domain 'sprocket' must list the token sets it is held to*"
            $message | Should -BeLike "*engine_neutrality: token set name 'Bad Set' must be kebab-case*"
            $message | Should -BeLike "*engine_neutrality: token set 'flat': must be a map of token name to regular expression*"
            $message | Should -BeLike "*token name 'Bad Name' must be kebab-case*"
            $message | Should -BeLike "*token 'broken' pattern does not compile*"
            $message | Should -BeLike "*token 'empty' needs a pattern*"
            $message | Should -BeLike '*citation_graph: must be a mapping*'
            $message |
                Should -BeLike "*dora_coverage: file 'notes/widget.md' must be a markdown file name, with no folder*"
            $message | Should -BeLike "*dora_coverage: exempt domain 'gizmo' needs a reason*"
            $message |
                Should -BeLike "*dora_coverage: exempt folder 'widget' must be a '/'-separated subfolder of a domain*"
            $message | Should -BeLike "*dora_coverage: exempt folder 'widget/sub' needs a reason*"
        }
    }
}
