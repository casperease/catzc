<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/tests/Build-ContractReference.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Build-ContractReference' -Tag 'L0', 'logic' {
    BeforeAll {
        function Add-File {
            param([string] $Relative, [string] $Content)
            $file = Join-Path $script:root $Relative
            $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, $Content)
        }

        function Read-Page {
            param([string] $ContractRoot = 'catzc')
            [System.IO.File]::ReadAllText((Join-Path $script:root "docs/references/contracts/$ContractRoot.md"))
        }

        Mock Write-Message -ModuleName Catzc.Base.Contracts { }
        # The fixture root is no git checkout, so the generated head reads no file as tracked.
        Import-InternalModule TestKit
        Set-GitTrackedPathMock
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule {
            [pscustomobject]@{ name = 'Catzc.Widget'; root = 'widgets/Catzc.Widget'; languages = @('powershell') }
        }
        Mock -ModuleName Catzc.Base.Contracts Get-GitTrackedPath { 'widgets/build.yml', 'widgets/README.md' }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $null = New-Item -ItemType Directory -Force -Path $script:root
        $appliesTo = "applies_to:`n  catzc.widget/build.yml: ['widgets/build.yml']`n  catzc.widget/README.md: ['widgets/README.md']`n"
        Add-File 'contracts/catzc/0.1.0/catzc.widget/build.yml' ((@('# The keys the gadget host reads, per [ADR-TST-WIDGET-TURN](/docs/drs/repository/widget-thing.md#rule-adr-tst-widget-turn).', 'widget:') -join "`n") + "`n")
        Add-File 'contracts/catzc/0.1.0/catzc.widget/README.md' ''
        Add-File 'contracts/catzc/0.1.0/catzc.gadget/gadget.sample.json' '{ "gadget": 1 }'
        Add-File 'contracts/catzc/0.1.0/catzc.widget/get_widget.command.yml' "parameters:`n  path: string!`n  strict: switch`noutput: string`n"
        Add-File 'contracts/catzc/0.1.0/contract.yml' $appliesTo
        foreach ($release in '1.2.0', '1.10.0') {
            Add-File "contracts/catzc/$release/catzc.widget/README.md" ''
            Add-File "contracts/catzc/$release/contract.yml" "applies_to:`n  catzc.widget/README.md: ['widgets/README.md']`n"
        }
    }

    It 'writes one page per root, with a section per version folder: the current version first, then the releases newest first' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
        Add-File 'contracts/gadget/0.1.0/catzc.gadget/README.md' ''
        Add-File 'contracts/gadget/0.1.0/contract.yml' "applies_to:`n  catzc.gadget/README.md: ['widgets/README.md']`n"

        $paths = @(Build-ContractReference -RepositoryRoot $script:root -Silent)
        $paths | Should -Be @('docs/references/contracts/catzc.md', 'docs/references/contracts/gadget.md')

        $page = Read-Page
        $page |
            Should -Match ("(?s)^---`ncatzc:.*warning: .*---`n`n" + [regex]::Escape("# docs/references/contracts/catzc.md`n`n``The catzc contracts```n"))
        $sections = @([regex]::Matches($page, '(?m)^## (.+)$') | ForEach-Object { $_.Groups[1].Value })
        $sections | Should -Be @('0.1.0', '1.10.0', '1.2.0')
    }

    It 'lists each asset with its group, path, bound file, direction, and kind' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET', 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $page = Read-Page
        $page | Should -Match '(?m)^\| Group +\| Asset +\| Bound file +\| Direction +\| Kind +\| Signature +\|$'
        $rows = @($page -split "`n" | Where-Object { $_.StartsWith('| `catzc.') } | ForEach-Object {
                , @($_.Trim().Trim('|') -split ' \| ' | ForEach-Object { $_.Trim() })
            })

        $rows[0] | Should -Be @('`catzc.gadget`', '`gadget.sample.json`', 'none', 'provided', 'sample payload', 'none')
        $rows[1] | Should -Be @('`catzc.widget`', '`README.md`', '`widgets/README.md`', 'provided', 'presence', 'none')
        $rows[2] | Should -Be @('`catzc.widget`', '`build.yml`', '`widgets/build.yml`', 'provided', 'fragment', 'none')
    }

    It 'shows a command contract''s signature in its own column, from the one reader' -Tag 'ADR-REPO-CMDCONTRACT-ONEREADER' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $rows = @((Read-Page) -split "`n" | Where-Object { $_.StartsWith('| `catzc.') } | ForEach-Object {
                , @($_.Trim().Trim('|') -split ' \| ' | ForEach-Object { $_.Trim() })
            })
        $rows[3] | Should -Be @('`catzc.widget`', '`get_widget.command.yml`', '`widgets/Catzc.Widget/Get-Widget.ps1`',
            'provided', 'command contract', '`path: string!, strict: switch -> string`')
    }

    It 'marks a command contract that does not read, and still writes the page' -Tag 'ADR-REPO-CMDCONTRACT-ONEREADER' {
        Add-File 'contracts/catzc/0.1.0/catzc.widget/get_widget.command.yml' "parameters:`n  path: text`n"
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        (Read-Page) |
            Should -Match '(?m)^\| `catzc\.widget` +\| `get_widget\.command\.yml` .*\| not readable \(Test-Contracts reports it\) +\|$'
    }

    It 'lists the notes under the table, one item per asset that carries one' -Tag 'ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $lines = (Read-Page) -split "`n"
        $first = [array]::IndexOf($lines, '- `catzc.widget/build.yml`: The keys the gadget host reads, per')

        @($lines | Where-Object { $_.StartsWith('- ') }).Count | Should -Be 1
        $first | Should -BeGreaterThan 0
        $lines[$first + 1] |
            Should -BeExactly '  [ADR-TST-WIDGET-TURN](../../drs/repository/widget-thing.md#rule-adr-tst-widget-turn).'
        (Read-Page) | Should -Match "(?m)^\| ``catzc\.widget``.*\|\n\nNotes:\n\n- "
    }

    It 'fills a long note across lines at the prose width' -Tag 'ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED' {
        $long = (@('widget gadget') * 20) -join ' '
        Add-File 'contracts/catzc/0.1.0/catzc.widget/build.yml' ((@("# $long.", 'widget:') -join "`n") + "`n")
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $lines = (Read-Page) -split "`n"

        @($lines | Where-Object { $_ -match '^  (widget|gadget) ' }).Count | Should -BeGreaterThan 0
        @($lines | Where-Object { $_.Length -gt 140 -and -not $_.StartsWith('|') }) | Should -BeNullOrEmpty
    }

    It 'emits formatter-stable markdown: prose within 140 columns, tables aligned' -Tag 'ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $lines = (Read-Page) -split "`n"

        @($lines | Where-Object { -not $_.StartsWith('|') -and $_.Length -gt 140 }) | Should -BeNullOrEmpty
        $tables = @(([regex]::Matches((Read-Page),
                    '(?m)(?:^\|.*\n)+')) | ForEach-Object { , @($_.Value.TrimEnd("`n") -split "`n") })
        $tables.Count | Should -Be 3
        foreach ($table in $tables) {
            @($table | ForEach-Object { $_.Length } | Select-Object -Unique).Count | Should -Be 1
        }
        (Read-Page) | Should -Not -Match "`n`n`n"
    }

    It 'is deterministic: a second run reports no change' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        @(Build-ContractReference -RepositoryRoot $script:root -DryRun -PassThru -Silent | Where-Object Changed) |
            Should -BeNullOrEmpty
    }

    It 'renders on every run, heads each page with the warning and no inputs stamp, and writes nothing the second time' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        (Read-Page) | Should -Match 'warning: "Do Not Edit, this file is generated"'
        (Read-Page) |
            Should -Not -Match 'with_body_sha' -Because 'git does not track a fixture page, and the body hash is written only while it does'
        (Read-Page) | Should -Not -Match 'with_inputs_sha'
        $second = @(Build-ContractReference -RepositoryRoot $script:root -PassThru -Silent)
        $second | Should -Not -BeNullOrEmpty -Because 'the second run renders every page again'
        @($second | Where-Object Changed) | Should -BeNullOrEmpty
    }

    It 'reports drift without writing under -DryRun' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        Add-File 'docs/references/contracts/catzc.md' 'stale'

        $result = Build-ContractReference -RepositoryRoot $script:root -DryRun -PassThru -Silent
        $result.Changed | Should -BeTrue
        $result.AssetCount | Should -Be 6
        Read-Page | Should -BeExactly 'stale'
    }

    It 'removes a page it wrote whose root has no assets, and only reports it under -DryRun' {
        Add-File 'docs/references/contracts/gadget.md' "a page of a retired root`n``Build-ContractReference`` writes this page from ``contracts/gadget/``.`n"

        $result = @(Build-ContractReference -RepositoryRoot $script:root -DryRun -PassThru -Silent | Where-Object Removed)
        $result.Path | Should -Be 'docs/references/contracts/gadget.md'
        Test-Path (Join-Path $script:root 'docs/references/contracts/gadget.md') | Should -BeTrue

        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        Test-Path (Join-Path $script:root 'docs/references/contracts/gadget.md') | Should -BeFalse
    }

    It 'never touches a page it did not write' {
        Add-File 'docs/references/contracts/how-pins-work.md' 'a hand-written article'

        @(Build-ContractReference -RepositoryRoot $script:root -PassThru -Silent | Where-Object Removed) |
            Should -BeNullOrEmpty
        [System.IO.File]::ReadAllText((Join-Path $script:root 'docs/references/contracts/how-pins-work.md')) |
            Should -BeExactly 'a hand-written article'
    }

    It 'writes nothing when there are no contracts' {
        $empty = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $null = New-Item -ItemType Directory -Force -Path $empty
        @(Build-ContractReference -RepositoryRoot $empty -Silent) | Should -BeNullOrEmpty
        Test-Path (Join-Path $empty 'docs') | Should -BeFalse
    }
}

Describe 'Build-ContractReference — generated contract reference' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-README-AUTHOREDSOURCES' {
    It 'every root''s page is current — no drift from its assets' {
        $results = @(Build-ContractReference -DryRun -PassThru -Silent)
        $results.Count | Should -BeGreaterThan 0
        @($results | Where-Object Changed | ForEach-Object Path) |
            Should -BeNullOrEmpty -Because 'Build-ContractReference regenerates a stale page'
    }
}
