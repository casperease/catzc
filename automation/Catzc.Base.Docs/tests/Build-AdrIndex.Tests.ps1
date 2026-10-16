<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/tests/Build-AdrIndex.Tests.ps1
    folder: tests
    name: build-adr-index-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/tests/Build-AdrIndex.Tests.ps1.md
    cites:
      - ADR-REPO-README#7
---
#>

Describe 'Build-AdrIndex — generated ADR index' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-README#7' {
    BeforeAll {
        $script:indexEntries = & (Get-Module Catzc.Base.Docs) { Get-CatsAdrIndex }
        $script:ruleSets = Get-AdrRuleSet
        $script:adrRoot = Resolve-RepoPath 'docs/adr'
    }

    It 'the on-disk index is current — no drift from adrs.yml (Test-GeneratedFiles)' {
        $result = Test-GeneratedFiles -Generator Build-AdrIndex -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'every adrs.yml ruleset is one parseable index row (codes agree with the flattened rule-sets)' {
        (@($script:indexEntries.Code) | Sort-Object) -join ',' |
            Should -Be ((@($script:ruleSets.External) | Sort-Object) -join ',') -Because (
                'the index is a projection of adrs.yml — every external code is one row, in the format Get-CatsAdrIndex parses')
    }

    It 'every domain heading is followed by its adrs.yml description' {
        $index = [System.IO.File]::ReadAllText((Join-Path $script:adrRoot 'index.md'))
        $flattened = $index -replace '\s+', ' '
        $missing = foreach ($domain in (Get-Config -Config adrs).Domains) {
            $expected = "### $($domain.Name)/ $($domain.Description -replace '\s+', ' ')"
            if (-not $flattened.Contains($expected)) {
                $domain.Name
            }
        }
        @($missing) | Should -BeNullOrEmpty -Because 'each domain section opens with the description declared in adrs.yml'
    }

    It 'every index row links to a real ADR file under its domain folder' {
        $missing = foreach ($entry in $script:indexEntries) {
            $full = Join-Path $script:adrRoot $entry.Path
            if (-not [System.IO.File]::Exists($full)) {
                "$($entry.Code) -> $($entry.Path)"
            }
        }
        @($missing) | Should -BeNullOrEmpty -Because 'each generated link resolves to the ADR markdown it cites'
    }
}
