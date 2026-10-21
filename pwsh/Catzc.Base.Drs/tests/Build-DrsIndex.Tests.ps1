<#
---
catzc:
  immutable:
    with_body_sha: "7f5799f21ca8"
  edges:
    docs: "[Build-DrsIndex.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-drs/tests/Build-DrsIndex.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Drs/Build-DrsIndex.ps1
    cites:
      - ADR-AUTO-ASSETDEP-COVEREDBYREALTEST
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
      - ADR-REPO-README-AUTHOREDSOURCES
---
#>

Describe 'Build-DrsIndex — generated ADR index' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-README-AUTHOREDSOURCES' {
    BeforeAll {
        $script:indexEntries = & (Get-Module Catzc.Base.Drs) { Get-CatsDrsIndex }
        $script:ruleSets = Get-DrsRuleSet
        $script:adrRoot = Resolve-RepoPath 'docs/drs'
    }

    It 'the on-disk index is current — no drift from drs.yml (Test-GeneratedFiles)' {
        $result = Test-GeneratedFiles -Generator Build-DrsIndex -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'the on-disk index carries the body hash and no inputs stamp, and a second run writes nothing' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        Build-DrsIndex -Silent | Out-Null
        $head = [System.IO.File]::ReadAllText((Join-Path $script:adrRoot 'index.md'))
        $head | Should -Match 'with_body_sha: "?[0-9a-f]{12}'
        $head | Should -Not -Match 'with_inputs_sha'
        (Build-DrsIndex -Silent -PassThru).Changed | Should -BeFalse
    }

    It 'every drs.yml ruleset is one parseable index row (codes agree with the flattened rule-sets)' {
        (@($script:indexEntries.Code) | Sort-Object) -join ',' |
            Should -Be ((@($script:ruleSets.External) | Sort-Object) -join ',') -Because (
                'the index is a projection of drs.yml — every external code is one row, in the format Get-CatsDrsIndex parses')
    }

    It 'every domain heading is followed by its drs.yml description' {
        $index = [System.IO.File]::ReadAllText((Join-Path $script:adrRoot 'index.md'))
        $flattened = $index -replace '\s+', ' '
        $missing = foreach ($domain in (Get-Config -Config drs).Domains) {
            $expected = "### $($domain.Folder)/ $($domain.Description -replace '\s+', ' ')"
            if (-not $flattened.Contains($expected)) {
                $domain.Name
            }
        }
        @($missing) | Should -BeNullOrEmpty -Because 'each domain section opens with the description declared in drs.yml'
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

Describe 'Build-DrsIndex — shipped configs/drs.yml and types' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'finds the domain registry and the type sources in the loaded module' {
        $registry = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'configs/drs.yml' -Module Catzc.Base.Drs)) | ConvertFrom-Yaml -Ordered
        @($registry['domains'].Keys).Count | Should -BeGreaterThan 0
        [System.IO.Directory]::EnumerateFiles((Get-CatzcModuleRoot 'types' -Module Catzc.Base.Drs), '*.cs') | Should -Not -BeNullOrEmpty
    }
}
