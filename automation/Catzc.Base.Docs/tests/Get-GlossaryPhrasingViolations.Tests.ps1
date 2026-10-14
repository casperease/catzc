# Get-GlossaryPhrasingViolations is private, so it is exercised through the module (InModuleScope, per
# [ADR-AUTO-PESTER#4](/docs/adr/automation/powershell/pester-testing.md#rule-adr-auto-pester4)). Each test writes its
# own fixture file under $TestDrive and passes it as the only tracked file
# (-TrackedFile, -Root), so no git process runs; the glossary is built in memory from the real types. Fixture terms
# and rule codes are neutral (widget/gadget, tst —
# [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): the avoided phrase is 'widget
# bundle'.
Describe 'Get-GlossaryPhrasingViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        # One entry from the widget's source avoiding 'widget bundle' (say 'widget suite'), with the source's
        # options, if any.
        $script:entry = {
            param([System.Collections.IDictionary] $options = @{})
            $concept = [Catzc.Base.Docs.GlossaryConcept]::new('widget suite', [ordered]@{
                    key         = 'widget_suite'
                    domain      = 'repository'
                    defined_by  = 'ADR-TST-WIDGET#1'
                    short       = 'The widget suite.'
                    realized_by = [ordered]@{ kind = 'prose-only' }
                    avoid       = @([ordered]@{ phrase = 'widget bundle'; say = 'widget suite' })
                })
            [Catzc.Base.Docs.GlossaryEntry]::new($concept, 'Catzc.Widget', 'automation/Catzc.Widget/configs/glossary.yml',
                [Catzc.Base.Docs.GlossaryOptions]::new($options))
        }
        # Writes each repo-relative file under $TestDrive and scans exactly those files.
        $script:scan = {
            param([System.Collections.IDictionary] $files, [System.Collections.IDictionary] $options = @{})
            foreach ($relative in $files.Keys) {
                $full = Join-Path $TestDrive $relative
                [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
                [System.IO.File]::WriteAllText($full, ($files[$relative] -join "`n"))
            }
            $parameters = @{ Entries = @(& $script:entry $options); Files = [string[]] @($files.Keys); Root = [string] $TestDrive }
            $found = @(InModuleScope Catzc.Base.Docs -Parameters $parameters {
                    Get-GlossaryPhrasingViolations -Entry $Entries -TrackedFile $Files -Root $Root
                })
            Write-Output -NoEnumerate $found   # keep a single violation an array, so .Count and [0] mean what they say
        }
    }

    Context 'markdown' {
        It 'reports a use in prose with its file, line, phrase, replacement, and defining rule' -Tag 'ADR-REPO-VOCAB#5' {
            $found = & $script:scan @{ 'docs/alpha.md' = @('# Alpha', '', 'Run the widget bundle first.') }
            $found.Count | Should -Be 1
            $found[0] | Should -Be 'docs/alpha.md:3 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)'
        }

        It 'matches case-insensitively and across a wrapped line' -Tag 'ADR-REPO-VOCAB#5' {
            $found = & $script:scan @{ 'docs/alpha.md' = @('The Widget', 'BUNDLE runs.') }
            $found | Should -Be @('docs/alpha.md:1 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)')
        }

        It 'matches whole words only' -Tag 'ADR-REPO-VOCAB#5' {
            & $script:scan @{ 'docs/alpha.md' = @('A gadget-widget bundle, the widget bundles, the widget bundle-set, and widget bundled.') } | Should -BeNullOrEmpty
        }

        It 'exempts a mention in backticks, double quotes, or curly quotes' -Tag 'ADR-REPO-VOCAB#5' {
            $curly = "Say $([char]0x201C)widget bundle$([char]0x201D) never."
            $text = @('Avoid `widget bundle`, and "widget', 'bundle" too.', $curly)
            & $script:scan @{ 'docs/alpha.md' = $text } | Should -BeNullOrEmpty
        }

        It 'skips fenced code blocks' -Tag 'ADR-REPO-VOCAB#5' {
            $text = @('```powershell', 'Get-Widget # the widget bundle', '```', '~~~', 'widget bundle', '~~~', 'Then the widget bundle.')
            $found = & $script:scan @{ 'docs/alpha.md' = $text }
            $found | Should -Be @('docs/alpha.md:7 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)')
        }
    }

    Context 'PowerShell surfaces' {
        It 'reads comments and comment-based help as their own surfaces' -Tag 'ADR-REPO-VOCAB#5' {
            $text = @('<#', '.SYNOPSIS', '    Builds the widget bundle.', '#>', 'function Get-Widget {', '    # the widget bundle again', '}')
            $found = & $script:scan @{ 'automation/Get-Widget.ps1' = $text }
            $found | Should -Be @(
                'automation/Get-Widget.ps1:3 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)'
                'automation/Get-Widget.ps1:6 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)'
            )
            & $script:scan @{ 'automation/Get-Widget.ps1' = $text } @{ surfaces = @('comments') } |
                Should -Be @('automation/Get-Widget.ps1:6 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)')
        }

        It 'reads the strings of throw and the writers' -Tag 'ADR-REPO-VOCAB#5' {
            $text = @(
                "throw 'no widget bundle'"
                "Write-Message 'the widget bundle ran'"
                "Write-Warning -Message 'a widget bundle is stale'"
            )
            $found = & $script:scan @{ 'automation/Get-Widget.ps1' = $text }
            $found.Count | Should -Be 3
            $found | Should -Contain 'automation/Get-Widget.ps1:1 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)'
            $found | Should -Contain 'automation/Get-Widget.ps1:3 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)'
        }

        It 'reads the -ErrorText and -Because values of any command' -Tag 'ADR-REPO-VOCAB#5' {
            $text = @(
                "Assert-Widget -ErrorText 'the widget bundle is missing'"
                "`$x | Should -Be 1 -Because 'the widget bundle counts'"
            )
            $found = & $script:scan @{ 'automation/Get-Widget.Tests.ps1' = $text }
            $found.Count | Should -Be 2
        }

        It 'ignores a string that is not a message' -Tag 'ADR-REPO-VOCAB#5' {
            $text = @("`$name = 'widget bundle'", "Get-Widget -Name 'widget bundle'")
            & $script:scan @{ 'automation/Get-Widget.ps1' = $text } | Should -BeNullOrEmpty
        }

        It 'reads only the literal text of an expandable string' -Tag 'ADR-REPO-VOCAB#5' {
            $text = @(
                "throw `"the `$(`$widget) bundle is gone`""
                "throw `"the widget bundle `$(Get-Name 'widget bundle') is gone`""
            )
            $found = & $script:scan @{ 'automation/Get-Widget.ps1' = $text }
            $found | Should -Be @('automation/Get-Widget.ps1:2 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)')
        }
    }

    Context 'source options' {
        It 'scans only the files in scope and not excluded' -Tag 'ADR-REPO-VOCAB#2' {
            $files = [ordered]@{
                'docs/alpha.md'       = @('the widget bundle')
                'docs/old/beta.md'    = @('the widget bundle')
                'automation/gamma.md' = @('the widget bundle')
            }
            $found = & $script:scan $files @{ scope = @('docs/**'); exclude = @('docs/old/**') }
            $found | Should -Be @('docs/alpha.md:1 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)')
        }

        It 'always applies the default excludes' -Tag 'ADR-REPO-VOCAB#2' {
            & $script:scan @{ 'out/report.md' = @('the widget bundle') } | Should -BeNullOrEmpty
        }

        It 'skips a source that opts out of the avoid check' -Tag 'ADR-REPO-VOCAB#2' {
            & $script:scan @{ 'docs/alpha.md' = @('the widget bundle') } @{ checks = @('anchored', 'single', 'enforced', 'forms') } | Should -BeNullOrEmpty
        }

        It 'reads no file type that is not a surface' -Tag 'ADR-REPO-VOCAB#2' {
            & $script:scan @{ 'docs/alpha.yml' = @('note: the widget bundle') } | Should -BeNullOrEmpty
        }
    }

    # Test-Glossary hands G4 and G6 one surface table, so a run reads each file's prose once.
    Context 'surface table' {
        It 'fills the table it is given, and reads a file already in the table from the table' {
            $relative = 'docs/alpha.md'
            $full = Join-Path $TestDrive $relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, 'the widget suite')
            $parameters = @{ Entries = @(& $script:entry); Files = [string[]] @($relative); Root = [string] $TestDrive; Table = @{} }
            $check = {
                Get-GlossaryPhrasingViolations -Entry $Entries -TrackedFile $Files -Root $Root -SurfaceCache $Table
            }

            @(InModuleScope Catzc.Base.Docs -Parameters $parameters $check) | Should -BeNullOrEmpty
            @($parameters.Table.Keys) | Should -Be @($relative)

            $parameters.Table[$relative] = @([Catzc.Base.Docs.GlossarySegment]::new('markdown', 1, 'the widget bundle'))
            @(InModuleScope Catzc.Base.Docs -Parameters $parameters $check) |
                Should -Be @('docs/alpha.md:1 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET#1)')
        }
    }
}
