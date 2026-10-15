<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1
    kind: test
---
#>

# Build-ContractReference writes one page per unit, docs/references/contracts/<unit>.md, listing each version folder's
# assets with their notes ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)), as a
# committed generated page ([ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7)).
# Fixtures are a widget repository in TestDrive ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Build-ContractReference' -Tag 'L0', 'logic' {
    BeforeAll {
        function Add-File {
            param([string] $Relative, [string] $Content)
            $file = Join-Path $script:root $Relative
            $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, $Content)
        }

        function Read-Page {
            param([string] $Unit = 'widget')
            [System.IO.File]::ReadAllText((Join-Path $script:root "docs/references/contracts/$Unit.md"))
        }

        Mock Write-Message -ModuleName Catzc.Base.Contracts { }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $null = New-Item -ItemType Directory -Force -Path $script:root
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/.widget/flows/build.yml' ((@('# The keys the gadget host reads, per [ADR-TST-WIDGET#1](/docs/adr/repository/widget-thing.md#rule-adr-tst-widget1).', 'widget:') -join "`n") + "`n")
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/.widget/README.md' ''
        Add-File 'contracts/widget/0.0.0/Catzc.Gadget/gadget.sample.json' '{ "gadget": 1 }'
        Add-File 'contracts/widget/0.0.0/contract.yml' "direction:`n  Catzc.Widget/.widget/README.md: provided`n"
        Add-File 'contracts/widget/1.2.0/Catzc.Widget/.widget/README.md' ''
        Add-File 'contracts/widget/1.10.0/Catzc.Widget/.widget/README.md' ''
    }

    It 'writes one page per unit, with a section per version folder: the draft first, then the releases newest first' -Tag 'ADR-REPO-CONTRACT#2' {
        Add-File 'contracts/gadget/0.0.0/Catzc.Gadget/.gadget/README.md' ''

        $paths = @(Build-ContractReference -RepositoryRoot $script:root -Silent)
        $paths | Should -Be @('docs/references/contracts/gadget.md', 'docs/references/contracts/widget.md')

        $page = Read-Page
        $page | Should -Match ("(?s)^---`ncatzc:.*kind: tracked-generated-from-source.*generator: Build-ContractReference.*---`n`n" + [regex]::Escape("# docs/references/contracts/widget.md`n`n``The widget contracts```n"))
        $sections = @([regex]::Matches($page, '(?m)^## (.+)$') | ForEach-Object { $_.Groups[1].Value })
        $sections | Should -Be @('0.0.0', '1.10.0', '1.2.0')
    }

    It 'lists each asset with its module, path, target, direction, and kind' -Tag 'ADR-REPO-CONTRACT#6', 'ADR-REPO-CONTRACT#7' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $rows = @((Read-Page) -split "`n" | Where-Object { $_.StartsWith('| `Catzc.') } | ForEach-Object {
                , @($_.Trim().Trim('|') -split ' \| ' | ForEach-Object { $_.Trim() })
            })

        $rows[0] | Should -Be @('`Catzc.Gadget`', '`gadget.sample.json`', 'none', 'provided', 'sample payload')
        $rows[1] | Should -Be @('`Catzc.Widget`', '`.widget/README.md`', '`.widget/README.md`', 'provided (contract.yml)', 'presence')
        $rows[2] | Should -Be @('`Catzc.Widget`', '`.widget/flows/build.yml`', '`.widget/flows/build.yml`', 'depended-on', 'fragment')
    }

    It 'lists the notes under the table, one item per asset that carries one' -Tag 'ADR-REPO-CONTRACT#9' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $lines = (Read-Page) -split "`n"
        $first = [array]::IndexOf($lines, '- `Catzc.Widget/.widget/flows/build.yml`: The keys the gadget host reads, per')

        @($lines | Where-Object { $_.StartsWith('- ') }).Count | Should -Be 1
        $first | Should -BeGreaterThan 0
        $lines[$first + 1] | Should -BeExactly '  [ADR-TST-WIDGET#1](../../adr/repository/widget-thing.md#rule-adr-tst-widget1).'
        (Read-Page) | Should -Match "(?m)^\| ``Catzc\.Widget``.*\|\n\nNotes:\n\n- "
    }

    It 'fills a long note across lines at the prose width' -Tag 'ADR-REPO-FORMAT#5' {
        $long = (@('widget gadget') * 20) -join ' '
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/.widget/flows/build.yml' ((@("# $long.", 'widget:') -join "`n") + "`n")
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $lines = (Read-Page) -split "`n"

        @($lines | Where-Object { $_ -match '^  (widget|gadget) ' }).Count | Should -BeGreaterThan 0
        @($lines | Where-Object { $_.Length -gt 140 -and -not $_.StartsWith('|') }) | Should -BeNullOrEmpty
    }

    It 'emits formatter-stable markdown: prose within 140 columns, tables aligned' -Tag 'ADR-REPO-FORMAT#5' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $lines = (Read-Page) -split "`n"

        @($lines | Where-Object { -not $_.StartsWith('|') -and $_.Length -gt 140 }) | Should -BeNullOrEmpty
        $tables = @(([regex]::Matches((Read-Page), '(?m)(?:^\|.*\n)+')) | ForEach-Object { , @($_.Value.TrimEnd("`n") -split "`n") })
        $tables.Count | Should -Be 3
        foreach ($table in $tables) {
            @($table | ForEach-Object { $_.Length } | Select-Object -Unique).Count | Should -Be 1
        }
        (Read-Page) | Should -Not -Match "`n`n`n"
    }

    It 'is deterministic: a second run reports no change' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        @(Build-ContractReference -RepositoryRoot $script:root -DryRun -PassThru -Silent | Where-Object Changed) | Should -BeNullOrEmpty
    }

    It 'reports drift without writing under -DryRun' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        Add-File 'docs/references/contracts/widget.md' 'stale'

        $result = Build-ContractReference -RepositoryRoot $script:root -DryRun -PassThru -Silent
        $result.Changed | Should -BeTrue
        $result.AssetCount | Should -Be 5
        Read-Page | Should -BeExactly 'stale'
    }

    It 'removes a page it wrote whose unit has no assets, and only reports it under -DryRun' {
        Add-File 'docs/references/contracts/gadget.md' "a page of a retired unit`n``Build-ContractReference`` writes this page from ``contracts/gadget/``.`n"

        $result = @(Build-ContractReference -RepositoryRoot $script:root -DryRun -PassThru -Silent | Where-Object Removed)
        $result.Path | Should -Be 'docs/references/contracts/gadget.md'
        Test-Path (Join-Path $script:root 'docs/references/contracts/gadget.md') | Should -BeTrue

        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        Test-Path (Join-Path $script:root 'docs/references/contracts/gadget.md') | Should -BeFalse
    }

    It 'never touches a page it did not write' {
        Add-File 'docs/references/contracts/how-pins-work.md' 'a hand-written article'

        @(Build-ContractReference -RepositoryRoot $script:root -PassThru -Silent | Where-Object Removed) | Should -BeNullOrEmpty
        [System.IO.File]::ReadAllText((Join-Path $script:root 'docs/references/contracts/how-pins-work.md')) | Should -BeExactly 'a hand-written article'
    }

    It 'writes nothing when there are no contracts' {
        $empty = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $null = New-Item -ItemType Directory -Force -Path $empty
        @(Build-ContractReference -RepositoryRoot $empty -Silent) | Should -BeNullOrEmpty
        Test-Path (Join-Path $empty 'docs') | Should -BeFalse
    }
}

# The real contract reference against the real contracts/ tree: the committed pages are what the writer would write now.
# Reads only the repository's files.
Describe 'Build-ContractReference — generated contract reference' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-README#7' {
    It 'every unit''s page is current — no drift from its assets' {
        $results = @(Build-ContractReference -DryRun -PassThru -Silent)
        $results.Count | Should -BeGreaterThan 0
        @($results | Where-Object Changed | ForEach-Object Path) | Should -BeNullOrEmpty -Because 'Build-ContractReference regenerates a stale page'
    }
}
