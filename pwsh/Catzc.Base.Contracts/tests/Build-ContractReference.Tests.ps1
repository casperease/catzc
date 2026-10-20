<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1
    folder: tests
    name: build-contract-reference-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Build-ContractReference.Tests.ps1.md](docs/references/pwsh/catzc-base-contracts/tests/Build-ContractReference.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-REPO-CMDCONTRACT-ONEREADER
      - ADR-REPO-CONTRACT-LAYOUT
      - ADR-REPO-CONTRACT-CONTRACTASSET
      - ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION
      - ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
      - ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED
      - ADR-REPO-README-AUTHOREDSOURCES
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
            param([string] $Unit = 'widget')
            [System.IO.File]::ReadAllText((Join-Path $script:root "docs/references/contracts/$Unit.md"))
        }

        Mock Write-Message -ModuleName Catzc.Base.Contracts { }
        Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule {
            [pscustomobject]@{ name = 'Catzc.Widget'; root = 'widgets/Catzc.Widget'; languages = @('powershell') }
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $null = New-Item -ItemType Directory -Force -Path $script:root
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/.widget/flows/build.yml' ((@('# The keys the gadget host reads, per [ADR-TST-WIDGET-TURN](/docs/adr/repository/widget-thing.md#rule-adr-tst-widget-turn).', 'widget:') -join "`n") + "`n")
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/.widget/README.md' ''
        Add-File 'contracts/widget/0.0.0/Catzc.Gadget/gadget.sample.json' '{ "gadget": 1 }'
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/Get-Widget.command.yml' "parameters:`n  Path: string!`n  Strict: switch`noutput: string`n"
        Add-File 'contracts/widget/0.0.0/contract.yml' "direction:`n  Catzc.Widget/.widget/README.md: provided`n"
        Add-File 'contracts/widget/1.2.0/Catzc.Widget/.widget/README.md' ''
        Add-File 'contracts/widget/1.10.0/Catzc.Widget/.widget/README.md' ''
    }

    It 'writes one page per unit, with a section per version folder: the draft first, then the releases newest first' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
        Add-File 'contracts/gadget/0.0.0/Catzc.Gadget/.gadget/README.md' ''

        $paths = @(Build-ContractReference -RepositoryRoot $script:root -Silent)
        $paths | Should -Be @('docs/references/contracts/gadget.md', 'docs/references/contracts/widget.md')

        $page = Read-Page
        $page | Should -Match ("(?s)^---`ncatzc:.*role: reference.*generator: pwsh/Catzc.Base.Contracts/Build-ContractReference\.ps1.*---`n`n" + [regex]::Escape("# docs/references/contracts/widget.md`n`n``The widget contracts```n"))
        $sections = @([regex]::Matches($page, '(?m)^## (.+)$') | ForEach-Object { $_.Groups[1].Value })
        $sections | Should -Be @('0.0.0', '1.10.0', '1.2.0')
    }

    It 'lists each asset with its module, path, target, direction, and kind' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET', 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $rows = @((Read-Page) -split "`n" | Where-Object { $_.StartsWith('| `Catzc.') } | ForEach-Object {
                , @($_.Trim().Trim('|') -split ' \| ' | ForEach-Object { $_.Trim() })
            })

        $rows[0] | Should -Be @('`Catzc.Gadget`', '`gadget.sample.json`', 'none', 'provided', 'sample payload', 'none')
        $rows[1] | Should -Be @('`Catzc.Widget`', '`.widget/README.md`', '`.widget/README.md`', 'provided (contract.yml)', 'presence', 'none')
        $rows[2] | Should -Be @('`Catzc.Widget`', '`.widget/flows/build.yml`', '`.widget/flows/build.yml`', 'depended-on', 'fragment', 'none')
    }

    It 'shows a command contract''s signature in its own column, from the one reader' -Tag 'ADR-REPO-CMDCONTRACT-ONEREADER' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $rows = @((Read-Page) -split "`n" | Where-Object { $_.StartsWith('| `Catzc.') } | ForEach-Object {
                , @($_.Trim().Trim('|') -split ' \| ' | ForEach-Object { $_.Trim() })
            })
        $rows[3] | Should -Be @('`Catzc.Widget`', '`Get-Widget.command.yml`', '`widgets/Catzc.Widget/Get-Widget.ps1`', 'provided', 'command contract', '`Path: string!, Strict: switch -> string`')
    }

    It 'marks a command contract that does not read, and still writes the page' -Tag 'ADR-REPO-CMDCONTRACT-ONEREADER' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/Get-Widget.command.yml' "parameters:`n  Path: text`n"
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        (Read-Page) | Should -Match '(?m)^\| `Catzc\.Widget` +\| `Get-Widget\.command\.yml` .*\| not readable \(Test-Contracts reports it\) +\|$'
    }

    It 'lists the notes under the table, one item per asset that carries one' -Tag 'ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $lines = (Read-Page) -split "`n"
        $first = [array]::IndexOf($lines, '- `Catzc.Widget/.widget/flows/build.yml`: The keys the gadget host reads, per')

        @($lines | Where-Object { $_.StartsWith('- ') }).Count | Should -Be 1
        $first | Should -BeGreaterThan 0
        $lines[$first + 1] | Should -BeExactly '  [ADR-TST-WIDGET-TURN](../../adr/repository/widget-thing.md#rule-adr-tst-widget-turn).'
        (Read-Page) | Should -Match "(?m)^\| ``Catzc\.Widget``.*\|\n\nNotes:\n\n- "
    }

    It 'fills a long note across lines at the prose width' -Tag 'ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED' {
        $long = (@('widget gadget') * 20) -join ' '
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/.widget/flows/build.yml' ((@("# $long.", 'widget:') -join "`n") + "`n")
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        $lines = (Read-Page) -split "`n"

        @($lines | Where-Object { $_ -match '^  (widget|gadget) ' }).Count | Should -BeGreaterThan 0
        @($lines | Where-Object { $_.Length -gt 140 -and -not $_.StartsWith('|') }) | Should -BeNullOrEmpty
    }

    It 'emits formatter-stable markdown: prose within 140 columns, tables aligned' -Tag 'ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED' {
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

    It 'renders on every run, heads each page with the body hash and no inputs stamp, and writes nothing the second time' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        (Read-Page) | Should -Match 'with_body_sha: "?[0-9a-f]{12}'
        (Read-Page) | Should -Not -Match 'with_inputs_sha'
        $second = @(Build-ContractReference -RepositoryRoot $script:root -PassThru -Silent)
        $second | Should -Not -BeNullOrEmpty -Because 'the second run renders every page again'
        @($second | Where-Object Changed) | Should -BeNullOrEmpty
    }

    It 'reports drift without writing under -DryRun' {
        Build-ContractReference -RepositoryRoot $script:root -Silent | Out-Null
        Add-File 'docs/references/contracts/widget.md' 'stale'

        $result = Build-ContractReference -RepositoryRoot $script:root -DryRun -PassThru -Silent
        $result.Changed | Should -BeTrue
        $result.AssetCount | Should -Be 6
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

Describe 'Build-ContractReference — generated contract reference' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-README-AUTHOREDSOURCES' {
    It 'every unit''s page is current — no drift from its assets' {
        $results = @(Build-ContractReference -DryRun -PassThru -Silent)
        $results.Count | Should -BeGreaterThan 0
        @($results | Where-Object Changed | ForEach-Object Path) | Should -BeNullOrEmpty -Because 'Build-ContractReference regenerates a stale page'
    }
}
