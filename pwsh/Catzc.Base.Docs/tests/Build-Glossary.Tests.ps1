<#
---
catzc:
  immutable:
    with_body_sha: "1c743c57507e"
  edges:
    docs: "[Build-Glossary.Tests.ps1.md](docs/references/pwsh/catzc-base-docs/tests/Build-Glossary.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Docs/Build-Glossary.ps1
    cites:
      - ADR-AUTO-ASSETDEP-COVEREDBYREALTEST
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
      - ADR-REPO-README-AUTHOREDSOURCES
      - ADR-REPO-VOCAB-DEFINEDTERM
---
#>

Describe 'Build-Glossary' -Tag 'L0', 'logic' {
    BeforeAll {
        # A rule whose link is longer than a line: the page wraps it the way Prettier does, so the formatter leaves it unchanged.
        $script:longRule = 'ADR-TST-WIDGET-GADGET-SPINS-WHILE-EVERY-WIDGET-RESTS-AND-NOTHING-ELSE-MOVES'
        $entry = {
            param([string] $term, [string] $domain, [System.Collections.IDictionary] $extra = @{})
            $body = [ordered]@{
                key         = $term.Replace(' ', '_')
                domain      = $domain
                defined_by  = 'ADR-TST-WIDGET-REST'
                short       = "The $term."
                realized_by = [ordered]@{ kind = 'prose-only' }
            }
            foreach ($name in $extra.Keys) {
                $body[$name] = $extra[$name]
            }
            [Catzc.Base.Docs.GlossaryEntry]::new([Catzc.Base.Docs.GlossaryConcept]::new($term, $body), 'Catzc.Widget',
                'widgets/Catzc.Widget/configs/glossary.yml', [Catzc.Base.Docs.GlossaryOptions]::new(@{}))
        }
        $entries = [Catzc.Base.Docs.GlossaryEntry[]] @(
            (& $entry 'gadget run' 'automation' @{
                realized_by = [ordered]@{ kind = 'tag'; pattern = 'gadget' }
                relations   = @{ part_of = @('widget suite') }
                contrasts   = @{ 'widget suite' = 'A widget suite is files at rest; a gadget run executes.' }
            })
            (& $entry 'widget suite' 'repository' @{
                avoid = @(@{ phrase = 'widget bundle'; say = 'widget suite' })
            })
            (& $entry 'gadget shelf' 'repository' @{ defined_by = $script:longRule })
        )
        $citations = [Catzc.Base.Docs.AdrCitationMap]::new(
            @{ 'ADR-TST-WIDGET' = @{ path = 'docs/adr/repository/widget-thing.md'; rules = [string[]] @('ADR-TST-WIDGET-REST', $script:longRule) } },
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

    It 'renders a section per domain in adrs.yml order, each term with its rule link, realization, relations, contrasts, and avoids' -Tag 'ADR-REPO-VOCAB-DEFINEDTERM' {
        Build-Glossary -Path $script:page -Silent | Out-Null
        $text = [System.IO.File]::ReadAllText($script:page)

        $text | Should -BeLike "---`ncatzc:*role: other*generator: pwsh/Catzc.Base.Docs/Build-Glossary.ps1*---`n`n# docs/adr/glossary.md*"
        $text.IndexOf('## repository') | Should -BeLessThan $text.IndexOf('## automation')
        $text | Should -Not -Match '## flow'   # a domain without concepts gets no section
        $text | Should -Match ([regex]::Escape('- **Defined by:** [ADR-TST-WIDGET-REST](repository/widget-thing.md#rule-adr-tst-widget-rest)'))
        $text | Should -Match ([regex]::Escape('- **Realized by:** tag `gadget`'))
        $text | Should -Match ([regex]::Escape('- **Part of:** [widget suite](#widget-suite)'))
        $text | Should -Match ([regex]::Escape('| `widget bundle` | widget suite |'))
    }

    It 'renders a contrast declared on one term on both terms'' entries' -Tag 'ADR-REPO-VOCAB-SIMILARTERMSCONTRASTED' {
        Build-Glossary -Path $script:page -Silent | Out-Null
        $text = [System.IO.File]::ReadAllText($script:page)
        $text | Should -Match ([regex]::Escape('  - [widget suite](#widget-suite): A widget suite is files at rest; a gadget run executes.'))
        $text | Should -Match ([regex]::Escape('  - [gadget run](#gadget-run): A widget suite is files at rest; a gadget run executes.'))
    }

    It 'wraps a rule link longer than a line onto its own continuation line, as Prettier does' -Tag 'ADR-REPO-VOCAB-DEFINEDTERM' {
        Build-Glossary -Path $script:page -Silent | Out-Null
        $text = [System.IO.File]::ReadAllText($script:page)

        $link = "[$($script:longRule)](repository/widget-thing.md#rule-$($script:longRule.ToLowerInvariant()))"
        $text | Should -Match ([regex]::Escape("- **Defined by:**`n  $link`n"))
        foreach ($line in $text -split "`n") {
            $line.Length | Should -BeLessOrEqual ([Math]::Max(140, $link.Length + 2)) -Because $line
        }
    }

    It 'is deterministic: a second run reports no change' -Tag 'ADR-REPO-VOCAB-DEFINEDTERM' {
        Build-Glossary -Path $script:page -Silent | Out-Null
        (Build-Glossary -Path $script:page -DryRun -PassThru -Silent).Changed | Should -BeFalse
    }

    It 'records the body hash in the head, never an inputs stamp, and renders on every run' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        Remove-Item $script:page -ErrorAction Ignore
        Build-Glossary -Path $script:page -Silent | Out-Null
        $text = [System.IO.File]::ReadAllText($script:page)
        $text | Should -Match 'with_body_sha: "?[0-9a-f]{12}'
        $text | Should -Not -Match 'with_inputs_sha'
        (Build-Glossary -Path $script:page -PassThru -Silent).Changed | Should -BeFalse
        Should -Invoke Get-Glossary -ModuleName Catzc.Base.Docs -Times 2 -Exactly -Scope It
    }

    It 'rewrites a page whose body went stale, and its body hash with it' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        Remove-Item $script:page -ErrorAction Ignore
        Build-Glossary -Path $script:page -Silent | Out-Null
        $fresh = [System.IO.File]::ReadAllText($script:page)
        [System.IO.File]::WriteAllText($script:page, $fresh + "stale line`n")
        (Build-Glossary -Path $script:page -PassThru -Silent).Changed | Should -BeTrue
        [System.IO.File]::ReadAllText($script:page) | Should -BeExactly $fresh
    }

    It 'reports drift without writing under -DryRun' -Tag 'ADR-REPO-VOCAB-DEFINEDTERM' {
        Build-Glossary -Path $script:page -Silent | Out-Null
        [System.IO.File]::WriteAllText($script:page, 'stale')
        $report = Build-Glossary -Path $script:page -DryRun -PassThru -Silent
        $report.Changed | Should -BeTrue
        $report.ConceptCount | Should -Be 3
        [System.IO.File]::ReadAllText($script:page) | Should -Be 'stale'
    }
}

Describe 'Build-Glossary — generated glossary page' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-README-AUTHOREDSOURCES' {
    It 'the on-disk glossary is current — no drift from the glossary sources' {
        (Build-Glossary -DryRun -PassThru -Silent).ConceptCount | Should -BeGreaterThan 0
        $result = Test-GeneratedFiles -Generator Build-Glossary -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

Describe 'Build-Glossary — shipped configs/adrs.yml and types' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'finds the domain registry and the type sources in the loaded module' {
        $registry = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'configs/adrs.yml' -Module Catzc.Base.Docs)) | ConvertFrom-Yaml -Ordered
        @($registry['domains'].Keys).Count | Should -BeGreaterThan 0
        [System.IO.Directory]::EnumerateFiles((Get-CatzcModuleRoot 'types' -Module Catzc.Base.Docs), '*.cs') | Should -Not -BeNullOrEmpty
    }
}
