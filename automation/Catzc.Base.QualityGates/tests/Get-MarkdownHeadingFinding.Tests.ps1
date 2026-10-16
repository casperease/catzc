<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-MarkdownHeadingFinding.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
    adrs:
      - ADR-REPO-FORMAT#7
---
#>

Describe 'Get-MarkdownHeadingFinding' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#7' {
    BeforeAll {
        # Fixture text is built from lines, so every escape stays apart from the words around it.
        function script:Join-Lines {
            param([string[]] $Lines, [string] $Newline = "`n")
            $Lines -join $Newline
        }

        function script:Get-Finding {
            param([string] $Text, [string] $RelativePath = 'docs/adr/widget/widget-rules.md')
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text; RelativePath = $RelativePath } {
                param($Text, $RelativePath)
                $citation = @{ 'ADR-TST-WIDGET' = 'docs/adr/widget/widget-rules.md'; 'ADR-TST-GADGET' = 'docs/adr/gadget/gadget-rules.md' }
                Get-MarkdownHeadingFinding -RelativePath $RelativePath -Text $Text -Citation $citation
            }
        }
    }

    It 'accepts headings of plain words' {
        $text = Join-Lines '# docs/widget.md', '', '## Widget model', '', 'Body.', ''
        $result = Get-Finding $text
        $result.Findings | Should -BeNullOrEmpty
        $result.Fixed | Should -Be $text
    }

    It 'moves a trailing code group onto its own line below the heading' {
        $result = Get-Finding (Join-Lines '## Widget model (`widget.yml` + `gadgets/`)', '', 'Body.', '')
        $result.Fixed | Should -Be (Join-Lines '## Widget model', '', '`widget.yml` + `gadgets/`', '', 'Body.', '')
        $result.Findings[0].Kind | Should -Be 'Reference'
        $result.Findings[0].Line | Should -Be 1
    }

    It 'moves every trailing group, joined in order, and links a known citation relative to the file' {
        $result = Get-Finding (Join-Lines '## Widget model (`widget.yml`) (`ADR-TST-GADGET`)', '', 'Body.', '')
        $result.Fixed | Should -Be (Join-Lines '## Widget model', '', '`widget.yml` · [ADR-TST-GADGET](../gadget/gadget-rules.md)', '', 'Body.', '')
    }

    It 'keeps an unknown citation as a code span' {
        (Get-Finding (Join-Lines '### Widget (`ADR-TST-NONE`)', '')).Fixed | Should -Be (Join-Lines '### Widget', '', '`ADR-TST-NONE`', '')
    }

    It 'reports the anchor change of a moved group' {
        $finding = (Get-Finding (Join-Lines '## Validation (`Assert-Widget`)', '')).Findings[0]
        $finding.From | Should -Be 'validation-assert-widget'
        $finding.To | Should -Be 'validation'
    }

    It 'pads the moved line from a body line that followed the heading directly' {
        (Get-Finding (Join-Lines '## Widget (`widget.yml`)', 'Body.', '')).Fixed | Should -Be (Join-Lines '## Widget', '', '`widget.yml`', '', 'Body.', '')
    }

    It 'leaves code that is the subject of a heading' {
        (Get-Finding (Join-Lines '### `$Widget` — capture immediately', '')).Findings | Should -BeNullOrEmpty
    }

    It 'leaves a trailing group that holds prose' {
        (Get-Finding (Join-Lines '### Why a single `.psm1` (not three `.ps1` files)', '')).Findings | Should -BeNullOrEmpty
    }

    It 'leaves the H1, fenced headings, and front matter alone' {
        $text = Join-Lines '---', 'name: widget (`x`)', '---', '# Widget (`widget.yml`)', '', '```markdown', '## Gadget (`gadget.yml`)', '```', ''
        (Get-Finding $text).Findings | Should -BeNullOrEmpty
    }

    It 'reports a duplicate anchor without fixing it' {
        $text = Join-Lines '## Widget', '', '### Widget', ''
        $result = Get-Finding $text
        $result.Findings.Kind | Should -Be 'Duplicate'
        $result.Findings[0].Line | Should -Be 3
        $result.Fixed | Should -Be $text
    }

    It 'judges duplicates on the normal form' {
        (Get-Finding (Join-Lines '## Widget', '', '## Widget (`widget.yml`)', '')).Findings.Kind | Should -Contain 'Duplicate'
    }

    It 'keeps CRLF line endings' {
        (Get-Finding (Join-Lines '## Widget (`widget.yml`)', '' -Newline "`r`n")).Fixed | Should -Be (Join-Lines '## Widget', '', '`widget.yml`', '' -Newline "`r`n")
    }

    Context 'dora-explains' {
        It 'quotes each entry''s DORA paragraph, after the moved citation' {
            $text = Join-Lines '## Widget rules (`ADR-TST-WIDGET`)', '', 'DORA says widgets', 'matter.', '', '- [Capability](x.md) — why.', ''
            $result = Get-Finding $text -RelativePath 'docs/adr/widget/dora-explains.md'
            $result.Fixed | Should -Be (Join-Lines '## Widget rules', '', '[ADR-TST-WIDGET](widget-rules.md)', '', '> DORA says widgets', '> matter.', '', '- [Capability](x.md) — why.', '')
            $result.Findings.Kind | Should -Be 'Reference', 'Quote'
        }

        It 'accepts an entry already in normal form, so a second run changes nothing' {
            $text = Join-Lines '## Widget rules', '', '[ADR-TST-WIDGET](widget-rules.md)', '', '> DORA says widgets.', '', '- [Capability](x.md) — why.', ''
            $result = Get-Finding $text -RelativePath 'docs/adr/widget/dora-explains.md'
            $result.Findings | Should -BeNullOrEmpty
            $result.Fixed | Should -Be $text
        }

        It 'does not quote a list that opens an entry' {
            $text = Join-Lines '## Widget rules', '', '- [Capability](x.md) — why.', ''
            (Get-Finding $text -RelativePath 'docs/adr/widget/dora-explains.md').Findings | Should -BeNullOrEmpty
        }

        It 'quotes nothing outside a dora-explains file' {
            (Get-Finding (Join-Lines '## Widget', '', 'Prose.', '')).Findings | Should -BeNullOrEmpty
        }
    }
}
