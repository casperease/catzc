<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
    folder: tests
    name: test-contracts-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Test-Contracts.Tests.ps1.md](docs/references/pwsh/catzc-base-contracts/tests/Test-Contracts.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-CONTRACT-LAYOUT
      - ADR-REPO-CONTRACT-KEPTWHILEPINNED
      - ADR-REPO-CONTRACT-PROVENBYTESTS
      - ADR-REPO-CONTRACT-RELEASEDIMMUTABLE
      - ADR-REPO-CONTRACT-NODOTFOLDERS
---
#>

Describe 'Test-Contracts' -Tag 'L0', 'logic' {
    BeforeAll {
        function Add-File {
            param([string] $Relative, [string] $Content = '')
            $file = Join-Path $script:root $Relative
            $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, $Content)
        }

        $script:missing = "contracts/widget/0.0.0/Catzc.Widget/docs/gadget.md (Presence, DependedOn): the target 'docs/gadget.md' does not exist: 'docs' holds no 'gadget.md'."
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-Config -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'contracts' } {
            [Catzc.Base.Contracts.ContractsConfig]::new(@{ target_roots = @{ 'Catzc.Gadget' = '.gadget' } })
        }
        Mock Get-Config -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'exporter' } {
            [pscustomobject]@{ direct_install_version = '6.6.666' }
        }
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $null = [System.IO.Directory]::CreateDirectory($script:root)
        $script:out = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
    }

    It 'passes cleanly on a tree with no contracts' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        { Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out } | Should -Not -Throw
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Subject | Should -Be 'contracts'
        $result.IssueCount | Should -Be 0
        $result.Facts['Assets'] | Should -Be 0
        $result.Facts['FailedAssets'] | Should -Be 0
        $result.Facts['Version'] | Should -Be '0.0.0'
    }

    It 'passes when every asset holds' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/gadget.md'
        Add-File 'docs/gadget.md' '# Gadget'
        { Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out } | Should -Not -Throw
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Assets'] | Should -Be 1
        $result.Facts['FailedAssets'] | Should -Be 0
    }

    It 'throws once, naming the asset and its finding, when an asset fails' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS', 'ADR-AUTO-TEST-QUALITYGATE' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/gadget.md'
        Add-File 'docs/widget.md' '# Widget'
        $thrown = { Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Contracts failed: 1 issue(s)*'
        $thrown.Exception.Message | Should -BeLike "*$([WildcardPattern]::Escape($script:missing))*"
    }

    It 'returns every finding as an issue under -PassThru instead of throwing' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/gadget.md'
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/widget.md' "# Widget`n`nThe sprocket line.`n"
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/sprocket.md'
        Add-File 'docs/widget.md' '# Widget'
        Add-File 'docs/sprocket.md' '# Sprocket'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['Assets'] | Should -Be 3
        $result.Facts['FailedAssets'] | Should -Be 2
        $result.IssueCount | Should -Be $result.Issues.Count
        $result.Issues | Should -Contain $script:missing
        @($result.Issues | Where-Object { $_ -like 'contracts/widget/0.0.0/Catzc.Widget/docs/widget.md (Fragment, DependedOn): *' }).Count |
            Should -BeGreaterThan 0
        @($result.Issues | Where-Object { $_ -like '*docs/sprocket.md*' }).Count | Should -Be 0
    }

    It 'writes the report to its folder and points latest.txt at it' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/gadget.md'
        Add-File 'docs/widget.md' '# Widget'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        [System.IO.Path]::GetDirectoryName($result.ReportPath) | Should -Be $script:out
        $report = [System.IO.File]::ReadAllText((Join-Path $result.ReportPath 'contracts.md'))
        $report | Should -Match '^# Test-Contracts report'
        $report | Should -Match '- Assets: 1'
        $report | Should -Match '- FailedAssets: 1'
        $report | Should -Match ([regex]::Escape("- $script:missing"))
        [System.IO.File]::ReadAllText((Join-Path $script:out 'latest.txt')).Trim() | Should -Be (Split-Path $result.ReportPath -Leaf)
    }

    It 'checks every asset of the draft, in both directions' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/gadget.md'
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.sample.json' '{'
        Add-File 'docs/widget.md' '# Widget'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['Assets'] | Should -Be 2
        $result.Facts['PinnedAssets'] | Should -Be 0
        $result.Facts['FailedAssets'] | Should -Be 2
        $result.Issues | Should -Contain $script:missing
        @($result.Issues | Where-Object { $_ -like 'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.sample.json (Sample, Provided): *' }).Count |
            Should -BeGreaterThan 0
    }

    It 'checks the provided assets of a released folder and not its depended-on assets' -Tag 'ADR-REPO-CONTRACT-KEPTWHILEPINNED', 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/sprocket.md'
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.sample.json' '{'
        $null = Publish-ContractRelease -Unit widget -Version 1.0.0 -RepositoryRoot $script:root
        [System.IO.File]::Delete((Join-Path $script:root 'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.sample.json'))
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/widget.md'
        Add-File 'docs/widget.md' '# Widget'

        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['Assets'] | Should -Be 3
        $result.Facts['PinnedAssets'] | Should -Be 1
        $result.Facts['ReleasedFolders'] | Should -Be 1
        $result.Facts['FailedAssets'] | Should -Be 2
        @($result.Issues | Where-Object { $_ -like 'contracts/widget/1.0.0/Catzc.Widget/rest/gadget.sample.json (Sample, Provided, pinned): *' }).Count |
            Should -BeGreaterThan 0
        @($result.Issues | Where-Object { $_ -like 'contracts/widget/0.0.0/Catzc.Widget/docs/sprocket.md (Presence, DependedOn): *' }).Count |
            Should -Be 1
        @($result.Issues | Where-Object { $_ -like 'contracts/widget/1.0.0/*sprocket*' }).Count | Should -Be 0
    }

    It 'checks every asset of the release it is given, and not the draft' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS', 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/gadget.md'
        $null = Publish-ContractRelease -Unit widget -Version 1.0.0 -RepositoryRoot $script:root
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/sprocket.md'
        Add-File 'docs/widget.md' '# Widget'

        $result = Test-Contracts -Version 1.0.0 -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['Version'] | Should -Be '1.0.0'
        $result.Facts['Assets'] | Should -Be 1
        $result.Facts['PinnedAssets'] | Should -Be 0
        $result.Issues | Should -Be @("contracts/widget/1.0.0/Catzc.Widget/docs/gadget.md (Presence, DependedOn): the target 'docs/gadget.md' does not exist: 'docs' holds no 'gadget.md'.")
    }

    It 'reports a named release that a unit holds no folder for' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/widget.md'
        Add-File 'docs/widget.md' '# Widget'
        $result = Test-Contracts -Version 1.0.0 -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['Assets'] | Should -Be 0
        $result.Issues | Should -Be @("contracts/widget/1.0.0/ does not exist, so release 1.0.0 of 'widget' is not checked; a release freezes the draft with Publish-ContractRelease before it runs Test-Contracts -Version (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).")
    }

    It 'passes over a released folder that is unchanged since its freeze' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/widget.md'
        Add-File 'docs/widget.md' '# Widget'
        $null = Publish-ContractRelease -Unit widget -Version 1.0.0 -RepositoryRoot $script:root
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['ReleasedFolders'] | Should -Be 1
        $result.IssueCount | Should -Be 0
    }

    It 'reports a released folder changed since its freeze' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/widget.md'
        Add-File 'docs/widget.md' '# Widget'
        $null = Publish-ContractRelease -Unit widget -Version 1.0.0 -RepositoryRoot $script:root
        Add-File 'contracts/widget/1.0.0/Catzc.Widget/docs/widget.md' '# Widget'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Issues | Should -Be @('contracts/widget/1.0.0/Catzc.Widget/docs/widget.md: changed since the release froze it; a released version folder is immutable, so a change lands in the draft, contracts/widget/0.0.0/ (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).')
    }

    It 'reports a released folder with no .frozen record' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
        Add-File 'contracts/widget/1.0.0/Catzc.Widget/docs/widget.md'
        Add-File 'docs/widget.md' '# Widget'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Issues | Should -Be @('contracts/widget/1.0.0: holds no .frozen record, so nothing proves it unchanged; a release freezes the draft with Publish-ContractRelease, which writes it (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).')
    }

    It 'reports a contracts tree that does not list as one issue' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
        Add-File 'contracts/widget/draft/Catzc.Widget/docs/gadget.md'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeLike "contracts/ does not list — contracts/widget: 'draft' is not a version folder*"
        $result.Facts['Assets'] | Should -Be 0
    }

    It 'reports each outermost dot-prefixed folder under contracts/ as one issue' -Tag 'ADR-REPO-CONTRACT-NODOTFOLDERS' {
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/.widget/flows/build.yml' 'widget: gadget'
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/.widget/.flows/gadget.md'
        Add-File '.widget/flows/build.yml' 'widget: gadget'
        Add-File '.widget/.flows/gadget.md' '# Gadget'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeLike 'contracts/widget/0.0.0/Catzc.Widget/.widget/ is a dot-prefixed folder under contracts/*target_roots (ADR-REPO-CONTRACT-NODOTFOLDERS).'
    }

    It 'accepts a dot-prefixed file name and a dot-prefixed target root' -Tag 'ADR-REPO-CONTRACT-LAYOUT', 'ADR-REPO-CONTRACT-NODOTFOLDERS' {
        Add-File 'contracts/.gitkeep'
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/.widget'
        Add-File '.widget' 'widget'
        Add-File 'contracts/widget/0.0.0/Catzc.Gadget/flows/build.yml' 'widget: gadget'
        Add-File '.gadget/flows/build.yml' (@('widget: gadget', 'gadget: widget') -join "`n")
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Facts['Assets'] | Should -Be 2
    }

    It 'rejects a version that is not three numbers' {
        { Test-Contracts -Version '0.*' -RepositoryRoot $script:root -OutputFolder $script:out } | Should -Throw
    }
}

Describe 'Test-Contracts on the repository' -Tag 'L1', 'integrity', 'source-only' {
    It 'Test-Contracts passes over the current version folder of every unit' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS', 'ADR-AUTO-TEST-QUALITYGATE' {
        $result = Test-Contracts -PassThru -OutputFolder (Join-Path $TestDrive 'contracts')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
