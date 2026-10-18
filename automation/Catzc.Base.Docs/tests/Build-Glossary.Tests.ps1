Describe 'Build-Glossary' -Tag 'L0', 'logic' {
    BeforeAll {
        $entry = {
            param([string] $term, [string] $domain, [System.Collections.IDictionary] $extra = @{})
            $body = [ordered]@{
                key         = $term.Replace(' ', '_')
                domain      = $domain
                defined_by  = 'ADR-TST-WIDGET#1'
                short       = "The $term."
                realized_by = [ordered]@{ kind = 'prose-only' }
            }
            foreach ($name in $extra.Keys) {
                $body[$name] = $extra[$name]
            }
            [Catzc.Base.Docs.GlossaryEntry]::new([Catzc.Base.Docs.GlossaryConcept]::new($term, $body), 'Catzc.Widget',
                'automation/Catzc.Widget/configs/glossary.yml', [Catzc.Base.Docs.GlossaryOptions]::new(@{}))
        }
        $entries = [Catzc.Base.Docs.GlossaryEntry[]] @(
            (& $entry 'gadget run' 'automation' @{
                realized_by = [ordered]@{ kind = 'tag'; pattern = 'gadget' }
                relations   = @{ part_of = @('widget suite') }
                contrasts   = @{ 'widget suite' = 'A widget suite is files at rest; a gadget run executes.' }
            })
            (& $entry 'widget suite' 'repository' @{
                contrasts = @{ 'gadget run' = 'A gadget run executes; a widget suite is files at rest.' }
                avoid     = @(@{ phrase = 'widget bundle'; say = 'widget suite' })
            })
        )
        $citations = [Catzc.Base.Docs.AdrCitationMap]::new(
            @{ 'ADR-TST-WIDGET' = @{ path = 'docs/adr/repository/widget-thing.md'; rules = @(1) } },
            @('docs/adr/repository/widget-thing.md'))
        $domains = [pscustomobject]@{
            Domains = @([pscustomobject]@{ Name = 'repository' }, [pscustomobject]@{ Name = 'automation' }, [pscustomobject]@{ Name = 'flow' })
        }
        Mock Get-Glossary -ModuleName Catzc.Base.Docs -MockWith { , $entries }.GetNewClosure()
        Mock Get-AdrCitationMap -ModuleName Catzc.Base.Docs -MockWith { $citations }.GetNewClosure()
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'adrs' } -MockWith { $domains }.GetNewClosure()
        Mock Write-Message -ModuleName Catzc.Base.Docs { }
        $script:page = Join-Path $TestDrive 'glossary.md'
    }

    It 'renders a section per domain in adrs.yml order, each term with its rule link, realization, relations, contrasts, and avoids' -Tag 'ADR-REPO-VOCAB#1' {
        Build-Glossary -Path $script:page -Silent | Out-Null
        $text = [System.IO.File]::ReadAllText($script:page)

        $text | Should -BeLike "---`ncatzc:*kind: other*generator: automation/Catzc.Base.Docs/Build-Glossary.ps1*---`n`n# docs/adr/glossary.md*"
        $text.IndexOf('## repository') | Should -BeLessThan $text.IndexOf('## automation')
        $text | Should -Not -Match '## flow'   # a domain without concepts gets no section
        $text | Should -Match ([regex]::Escape('- **Defined by:** [ADR-TST-WIDGET#1](repository/widget-thing.md#rule-adr-tst-widget1)'))
        $text | Should -Match ([regex]::Escape('- **Realized by:** tag `gadget`'))
        $text | Should -Match ([regex]::Escape('- **Part of:** [widget suite](#widget-suite)'))
        $text | Should -Match ([regex]::Escape('  - [gadget run](#gadget-run): A gadget run executes; a widget suite is files at rest.'))
        $text | Should -Match ([regex]::Escape('| `widget bundle` | widget suite |'))
    }

    It 'is deterministic: a second run reports no change' -Tag 'ADR-REPO-VOCAB#1' {
        Build-Glossary -Path $script:page -Silent | Out-Null
        (Build-Glossary -Path $script:page -DryRun -PassThru -Silent).Changed | Should -BeFalse
    }

    It 'records the inputs stamp in the head and renders nothing again while the inputs are unchanged' {
        Remove-Item $script:page -ErrorAction Ignore
        Build-Glossary -Path $script:page -Silent | Out-Null
        [System.IO.File]::ReadAllText($script:page) | Should -Match 'with_inputs_sha: "?[0-9a-f]{64}'
        Build-Glossary -Path $script:page -Silent | Out-Null
        Should -Invoke Get-Glossary -ModuleName Catzc.Base.Docs -Times 1 -Exactly -Scope It
    }

    It 'renders again when the page carries a different inputs stamp' {
        Remove-Item $script:page -ErrorAction Ignore
        Build-Glossary -Path $script:page -Silent | Out-Null
        $stale = [System.IO.File]::ReadAllText($script:page) -replace 'with_inputs_sha: "?[0-9a-f]{64}"?', ('with_inputs_sha: ' + ('0' * 64))
        [System.IO.File]::WriteAllText($script:page, $stale)
        Build-Glossary -Path $script:page -Silent | Out-Null
        Should -Invoke Get-Glossary -ModuleName Catzc.Base.Docs -Times 2 -Exactly -Scope It
    }

    It 'reports drift without writing under -DryRun' -Tag 'ADR-REPO-VOCAB#1' {
        Build-Glossary -Path $script:page -Silent | Out-Null
        [System.IO.File]::WriteAllText($script:page, 'stale')
        $report = Build-Glossary -Path $script:page -DryRun -PassThru -Silent
        $report.Changed | Should -BeTrue
        $report.ConceptCount | Should -Be 2
        [System.IO.File]::ReadAllText($script:page) | Should -Be 'stale'
    }
}

Describe 'Build-Glossary — generated glossary page' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-README#7' {
    It 'the on-disk glossary is current — no drift from the glossary sources' {
        (Build-Glossary -DryRun -PassThru -Silent).ConceptCount | Should -BeGreaterThan 0
        $result = Test-GeneratedFiles -Generator Build-Glossary -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
