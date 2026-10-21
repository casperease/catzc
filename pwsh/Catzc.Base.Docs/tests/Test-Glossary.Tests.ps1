<#
---
catzc:
  immutable:
    with_body_sha: "62a29abc6321"
  edges:
    docs: "[Test-Glossary.Tests.ps1.md](docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Docs/Test-Glossary.ps1
    cites:
      - ADR-AUTO-FAILFAST
      - ADR-AUTO-TEST-SETUPONCE
      - ADR-AUTO-TEST-ONEIMPORTPERCASE
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-VOCAB-DEFINEDTERM
      - ADR-REPO-VOCAB-GLOSSARYSOURCE
      - ADR-REPO-VOCAB-SOURCESINREPOSITORY
      - ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED
      - ADR-REPO-VOCAB-REALIZEDBY
---
#>

Describe 'Test-Glossary' -Tag 'L0', 'logic' {
    BeforeAll {
        # Two real entries: the mocked checks keep their typed -Entry parameter, so the glossary must bind to it.
        $script:entries = [Catzc.Base.Docs.GlossaryEntry[]] @(foreach ($term in 'gadget run', 'widget suite') {
                $concept = [Catzc.Base.Docs.GlossaryConcept]::new($term, [ordered]@{
                        key         = $term.Replace(' ', '_')
                        domain      = 'repository'
                        defined_by  = 'ADR-TST-WIDGET-REST'
                        short       = "The $term."
                        realized_by = [ordered]@{ kind = 'prose-only' }
                    })
                [Catzc.Base.Docs.GlossaryEntry]::new($concept, 'Catzc.Widget', 'widgets/Catzc.Widget/configs/glossary.yml',
                    [Catzc.Base.Docs.GlossaryOptions]::new(@{}))
            })
    }

    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-GlossarySources -ModuleName Catzc.Base.Docs { [pscustomobject]@{ Owner = 'Catzc.Widget' } }
        $entries = $script:entries
        Mock Get-Glossary -ModuleName Catzc.Base.Docs -MockWith { , $entries }.GetNewClosure()
        Mock Get-GlossarySourceViolations -ModuleName Catzc.Base.Docs { }
        Mock Get-GlossaryAnchorViolations -ModuleName Catzc.Base.Docs { }
        Mock Get-GlossaryDefinitionViolations -ModuleName Catzc.Base.Docs { }
        Mock Get-GlossaryPhrasingViolations -ModuleName Catzc.Base.Docs { }
        Mock Get-GlossaryEnforcementViolations -ModuleName Catzc.Base.Docs { }
        Mock Get-GlossaryFormViolations -ModuleName Catzc.Base.Docs { }
        $script:out = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
    }

    It 'reports no issues, writes the report, and points latest.txt at it' -Tag 'ADR-REPO-VOCAB-DEFINEDTERM' {
        { Test-Glossary -OutputFolder $script:out } | Should -Not -Throw
        $result = Test-Glossary -OutputFolder $script:out -PassThru
        $result.Subject | Should -Be 'glossary'
        $result.IssueCount | Should -Be 0
        $result.Facts['ConceptCount'] | Should -Be 2
        $result.Facts['SourceCount'] | Should -Be 1
        [System.IO.File]::ReadAllText((Join-Path $result.ReportPath 'glossary.md')) | Should -Match 'no glossary issues'
        (Get-Content (Join-Path $script:out 'latest.txt')) | Should -Be (Split-Path $result.ReportPath -Leaf)
    }

    It 'throws once with every check''s issues, prefixed by the check, in check order' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED', 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-GlossarySourceViolations -ModuleName Catzc.Base.Docs { 'widget: duplicate' }
        Mock Get-GlossaryPhrasingViolations -ModuleName Catzc.Base.Docs { 'docs/alpha.md:3 says "widget bundle"'; 'docs/beta.md:1 says "widget bundle"' }
        Mock Get-GlossaryEnforcementViolations -ModuleName Catzc.Base.Docs { 'widget: unenforced' }
        Mock Get-GlossaryFormViolations -ModuleName Catzc.Base.Docs { 'docs/alpha.md:5 says "widget-gadget run"' }
        $thrown = { Test-Glossary -OutputFolder $script:out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-Glossary failed: 5 issue(s)*'
        $order = @('G1 widget: duplicate', 'G4 docs/alpha.md:3', 'G4 docs/beta.md:1', 'G5 widget: unenforced', 'G6 docs/alpha.md:5') |
            ForEach-Object { $message.IndexOf($_) }
        $order | Should -Not -Contain -1
        $order | Should -Be @($order | Sort-Object)
    }

    It 'returns the issues instead of throwing with -PassThru' -Tag 'ADR-REPO-VOCAB-DEFINEDTERM' {
        Mock Get-GlossaryAnchorViolations -ModuleName Catzc.Base.Docs { 'widget: not anchored' }
        Mock Get-GlossaryDefinitionViolations -ModuleName Catzc.Base.Docs { 'widget: defined twice' }
        $result = Test-Glossary -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 2
        $result.Issues | Should -Be @('G2 widget: not anchored', 'G3 widget: defined twice')
        [System.IO.File]::ReadAllText((Join-Path $result.ReportPath 'glossary.md')) | Should -Match '- G3 widget: defined twice'
    }

    It 'hands G4 and G6 one surface table, so a run reads each file''s prose once' {
        # G4 reads a file into the table it is given; G6 reports what it finds already in its table.
        Mock Get-GlossaryPhrasingViolations -ModuleName Catzc.Base.Docs { $SurfaceCache['docs/widget.md'] = @() }
        Mock Get-GlossaryFormViolations -ModuleName Catzc.Base.Docs { @($SurfaceCache.Keys | ForEach-Object { "table holds $_" }) }
        $result = Test-Glossary -OutputFolder $script:out -PassThru
        $result.Issues | Should -Be @('G6 table holds docs/widget.md')
    }
}

Describe 'Test-Glossary — real glossary sources' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:sources = @(InModuleScope Catzc.Base.Docs { Get-GlossarySources })
        $script:gate = Test-Glossary -PassThru -OutputFolder (Join-Path $TestDrive 'glossary')
        $script:issuesOf = {
            param([string] $Check)
            @($script:gate.Issues | Where-Object { $_.StartsWith("$Check ", [System.StringComparison]::Ordinal) })
        }
    }

    It 'Test-Glossary passes over the real sources' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $script:gate.IssueCount | Should -Be 0
    }

    It 'discovers at least one glossary source' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
        $script:sources.Count | Should -BeGreaterThan 0
    }

    It 'G1 — the sources agree with each other and are tracked' -Tag 'ADR-REPO-VOCAB-SOURCESINREPOSITORY' {
        & $script:issuesOf 'G1' | Should -BeNullOrEmpty
    }

    It 'G2 — every term is anchored on its defining rule' -Tag 'ADR-REPO-VOCAB-DEFINEDTERM' {
        & $script:issuesOf 'G2' | Should -BeNullOrEmpty
    }

    It 'G3 — no second rule defines a term' -Tag 'ADR-REPO-VOCAB-DEFINEDTERM' {
        & $script:issuesOf 'G3' | Should -BeNullOrEmpty
    }

    It 'G4 — prose avoids every avoided phrasing in scope' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
        & $script:issuesOf 'G4' | Should -BeNullOrEmpty
    }

    It 'G5 — every realized concept is enforced' -Tag 'ADR-REPO-VOCAB-REALIZEDBY' {
        & $script:issuesOf 'G5' | Should -BeNullOrEmpty
    }
}
