<#
---
catzc:
  immutable:
    with_body_sha: "33462ede9644"
  edges:
    docs: "[Get-GlossaryPhrasingViolations.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Docs/private/Get-GlossaryPhrasingViolations.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-PWSH-PESTER-PRIVATETHROUGHMODULE
      - ADR-REPO-VOCAB-GLOSSARYSOURCE
      - ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED
---
#>

Describe 'Get-GlossaryPhrasingViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:entry = {
            param([System.Collections.IDictionary] $options = @{})
            $concept = [Catzc.Base.Docs.GlossaryConcept]::new('widget suite', [ordered]@{
                    key         = 'widget_suite'
                    domain      = 'repository'
                    defined_by  = 'ADR-TST-WIDGET-REST'
                    short       = 'The widget suite.'
                    realized_by = [ordered]@{ kind = 'prose-only' }
                    avoid       = @([ordered]@{ phrase = 'widget bundle'; say = 'widget suite' })
                })
            [Catzc.Base.Docs.GlossaryEntry]::new($concept, 'Catzc.Widget', 'widgets/Catzc.Widget/configs/glossary.yml',
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
        It 'reports a use in prose with its file, line, phrase, replacement, and defining rule' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
            $found = & $script:scan @{ 'docs/alpha.md' = @('# Alpha', '', 'Run the widget bundle first.') }
            $found.Count | Should -Be 1
            $found[0] | Should -Be 'docs/alpha.md:3 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)'
        }

        It 'matches case-insensitively and across a wrapped line' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
            $found = & $script:scan @{ 'docs/alpha.md' = @('The Widget', 'BUNDLE runs.') }
            $found | Should -Be @('docs/alpha.md:1 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)')
        }

        It 'matches whole words only' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
            & $script:scan @{ 'docs/alpha.md' = @('A gadget-widget bundle, the widget bundles, the widget bundle-set, and widget bundled.') } | Should -BeNullOrEmpty
        }

        It 'exempts a mention in backticks, double quotes, or curly quotes' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
            $curly = "Say $([char]0x201C)widget bundle$([char]0x201D) never."
            $text = @('Avoid `widget bundle`, and "widget', 'bundle" too.', $curly)
            & $script:scan @{ 'docs/alpha.md' = $text } | Should -BeNullOrEmpty
        }

        It 'skips fenced code blocks' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
            $text = @('```powershell', 'Get-Widget # the widget bundle', '```', '~~~', 'widget bundle', '~~~', 'Then the widget bundle.')
            $found = & $script:scan @{ 'docs/alpha.md' = $text }
            $found | Should -Be @('docs/alpha.md:7 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)')
        }
    }

    Context 'PowerShell surfaces' {
        It 'reads comments and comment-based help as their own surfaces' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
            $text = @('<#', '.SYNOPSIS', '    Builds the widget bundle.', '#>', 'function Get-Widget {', '    # the widget bundle again', '}')
            $found = & $script:scan @{ 'widgets/Get-Widget.ps1' = $text }
            $found | Should -Be @(
                'widgets/Get-Widget.ps1:3 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)'
                'widgets/Get-Widget.ps1:6 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)'
            )
            & $script:scan @{ 'widgets/Get-Widget.ps1' = $text } @{ surfaces = @('comments') } |
                Should -Be @('widgets/Get-Widget.ps1:6 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)')
        }

        It 'reads the strings of throw and the writers' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
            $text = @(
                "throw 'no widget bundle'"
                "Write-Message 'the widget bundle ran'"
                "Write-Warning -Message 'a widget bundle is stale'"
            )
            $found = & $script:scan @{ 'widgets/Get-Widget.ps1' = $text }
            $found.Count | Should -Be 3
            $found | Should -Contain 'widgets/Get-Widget.ps1:1 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)'
            $found | Should -Contain 'widgets/Get-Widget.ps1:3 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)'
        }

        It 'reads the -ErrorText and -Because values of any command' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
            $text = @(
                "Assert-Widget -ErrorText 'the widget bundle is missing'"
                "`$x | Should -Be 1 -Because 'the widget bundle counts'"
            )
            $found = & $script:scan @{ 'widgets/Get-Widget.Tests.ps1' = $text }
            $found.Count | Should -Be 2
        }

        It 'ignores a string that is not a message' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
            $text = @("`$name = 'widget bundle'", "Get-Widget -Name 'widget bundle'")
            & $script:scan @{ 'widgets/Get-Widget.ps1' = $text } | Should -BeNullOrEmpty
        }

        It 'reads only the literal text of an expandable string' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
            $text = @(
                "throw `"the `$(`$widget) bundle is gone`""
                "throw `"the widget bundle `$(Get-Name 'widget bundle') is gone`""
            )
            $found = & $script:scan @{ 'widgets/Get-Widget.ps1' = $text }
            $found | Should -Be @('widgets/Get-Widget.ps1:2 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)')
        }
    }

    Context 'source options' {
        It 'scans only the files in scope and not excluded' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
            $files = [ordered]@{
                'docs/alpha.md'    = @('the widget bundle')
                'docs/old/beta.md' = @('the widget bundle')
                'widgets/gamma.md' = @('the widget bundle')
            }
            $found = & $script:scan $files @{ scope = @('docs/**'); exclude = @('docs/old/**') }
            $found | Should -Be @('docs/alpha.md:1 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)')
        }

        It 'always applies the default excludes' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
            & $script:scan @{ 'out/report.md' = @('the widget bundle') } | Should -BeNullOrEmpty
        }

        It 'skips a source that opts out of the avoid check' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
            & $script:scan @{ 'docs/alpha.md' = @('the widget bundle') } @{ checks = @('anchored', 'single', 'enforced', 'forms') } | Should -BeNullOrEmpty
        }

        It 'reads no file type that is not a surface' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
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
                Should -Be @('docs/alpha.md:1 says "widget bundle" — say "widget suite" (ADR-TST-WIDGET-REST)')
        }
    }
}
