<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/tests/Test-Contracts.Tests.ps1.md"
  header: "generated"
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

        # The version's applies_to, one glob per asset key.
        function Set-Applies {
            param([string] $Root, [hashtable] $Map)
            $lines = @('applies_to:')
            foreach ($key in ($Map.Keys | Sort-Object)) {
                $lines += "  ${key}: ['$($Map[$key])']"
            }
            Add-File "contracts/$Root/0.1.0/contract.yml" (($lines -join "`n") + "`n")
        }

        $script:missing = "contracts/widget/0.1.0/gadgets/gadget.md (Presence, DependedOn): the target 'docs/gadget.md' does not exist: 'docs' holds no 'gadget.md'."
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-GitTrackedPath { 'docs/gadget.md', 'docs/widget.md', 'docs/sprocket.md', '.widget' } -ModuleName Catzc.Base.Contracts
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
        $result.Facts['Version'] | Should -Be '0.1.0'
    }

    It 'passes when every asset holds' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
        Add-File 'contracts/widget/0.1.0/gadgets/gadget.md'
        Set-Applies widget @{ 'gadgets/gadget.md' = 'docs/gadget.md' }
        Add-File 'docs/gadget.md' '# Gadget'
        { Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out } | Should -Not -Throw
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Assets'] | Should -Be 1
        $result.Facts['FailedAssets'] | Should -Be 0
    }

    It 'throws once, naming the asset and its finding, when an asset fails' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS', 'ADR-AUTO-TEST-QUALITYGATE' {
        Add-File 'contracts/widget/0.1.0/gadgets/gadget.md'
        Set-Applies widget @{ 'gadgets/gadget.md' = 'docs/gadget.md' }
        Add-File 'docs/widget.md' '# Widget'
        $thrown = { Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Contracts failed: 1 issue(s)*'
        $thrown.Exception.Message | Should -BeLike "*$([WildcardPattern]::Escape($script:missing))*"
    }

    It 'returns every finding as an issue under -PassThru instead of throwing' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
        Add-File 'contracts/widget/0.1.0/gadgets/gadget.md'
        Add-File 'contracts/widget/0.1.0/gadgets/widget.md' "# Widget`n`nThe sprocket line.`n"
        Add-File 'contracts/widget/0.1.0/gadgets/sprocket.md'
        Set-Applies widget @{ 'gadgets/gadget.md' = 'docs/gadget.md'; 'gadgets/widget.md' = 'docs/widget.md'; 'gadgets/sprocket.md' = 'docs/sprocket.md' }
        Add-File 'docs/widget.md' '# Widget'
        Add-File 'docs/sprocket.md' '# Sprocket'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['Assets'] | Should -Be 3
        $result.Facts['FailedAssets'] | Should -Be 2
        $result.IssueCount | Should -Be $result.Issues.Count
        $result.Issues | Should -Contain $script:missing
        @($result.Issues | Where-Object { $_ -like 'contracts/widget/0.1.0/gadgets/widget.md (Fragment, DependedOn): *' }).Count |
            Should -BeGreaterThan 0
        @($result.Issues | Where-Object { $_ -like '*gadgets/sprocket.md*' }).Count | Should -Be 0
    }

    It 'writes the report to its folder and points latest.txt at it' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Add-File 'contracts/widget/0.1.0/gadgets/gadget.md'
        Set-Applies widget @{ 'gadgets/gadget.md' = 'docs/gadget.md' }
        Add-File 'docs/widget.md' '# Widget'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        [System.IO.Path]::GetDirectoryName($result.ReportPath) | Should -Be $script:out
        $report = [System.IO.File]::ReadAllText((Join-Path $result.ReportPath 'contracts.md'))
        $report | Should -Match '^# Test-Contracts report'
        $report | Should -Match '- Assets: 1'
        $report | Should -Match '- FailedAssets: 1'
        $report | Should -Match ([regex]::Escape("- $script:missing"))
        [System.IO.File]::ReadAllText((Join-Path $script:out 'latest.txt')).Trim() |
            Should -Be (Split-Path $result.ReportPath -Leaf)
    }

    It 'checks every asset of the current version, in both directions' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
        Add-File 'contracts/widget/0.1.0/gadgets/gadget.md'
        Set-Applies widget @{ 'gadgets/gadget.md' = 'docs/gadget.md' }
        Add-File 'contracts/catzc/0.1.0/gadgets/gadget.sample.json' '{'
        Add-File 'docs/widget.md' '# Widget'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['Assets'] | Should -Be 2
        $result.Facts['PinnedAssets'] | Should -Be 0
        $result.Facts['FailedAssets'] | Should -Be 2
        $result.Issues | Should -Contain $script:missing
        @($result.Issues | Where-Object { $_ -like 'contracts/catzc/0.1.0/gadgets/gadget.sample.json (Sample, Provided): *' }).Count |
            Should -BeGreaterThan 0
    }

    It 'checks the provided assets of a released folder as well as the current version' -Tag 'ADR-REPO-CONTRACT-KEPTWHILEPINNED', 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
        Add-File 'contracts/catzc/0.1.0/gadgets/gadget.sample.json' '{'
        $null = Publish-ContractRelease -Root catzc -Version 1.0.0 -RepositoryRoot $script:root
        [System.IO.File]::Delete((Join-Path $script:root 'contracts/catzc/0.1.0/gadgets/gadget.sample.json'))
        Add-File 'contracts/catzc/0.1.0/gadgets/widget.sample.json' '{}'

        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['Assets'] | Should -Be 2
        $result.Facts['PinnedAssets'] | Should -Be 1
        $result.Facts['ReleasedFolders'] | Should -Be 1
        $result.Facts['FailedAssets'] | Should -Be 1
        @($result.Issues | Where-Object { $_ -like 'contracts/catzc/1.0.0/gadgets/gadget.sample.json (Sample, Provided, pinned): *' }).Count |
            Should -BeGreaterThan 0
    }

    It 'checks every asset of the release it is given, and not the current version' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS', 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
        Add-File 'contracts/catzc/0.1.0/gadgets/gadget.sample.json' '{'
        $null = Publish-ContractRelease -Root catzc -Version 1.0.0 -RepositoryRoot $script:root
        Add-File 'contracts/catzc/0.1.0/gadgets/widget.sample.json' '{'

        $result = Test-Contracts -Version 1.0.0 -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['Version'] | Should -Be '1.0.0'
        $result.Facts['Assets'] | Should -Be 1
        $result.Facts['PinnedAssets'] | Should -Be 0
        @($result.Issues).Count | Should -Be 1
        $result.Issues[0] | Should -BeLike 'contracts/catzc/1.0.0/gadgets/gadget.sample.json (Sample, Provided): *'
    }

    It 'reports a named release that the provided root holds no folder for' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
        Add-File 'contracts/catzc/0.1.0/gadgets/gadget.sample.json' '{}'
        $result = Test-Contracts -Version 1.0.0 -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['Assets'] | Should -Be 0
        $result.Issues |
            Should -Be @("contracts/catzc/1.0.0/ does not exist, so release 1.0.0 of 'catzc' is not checked; a release freezes the current version with Publish-ContractRelease before it runs Test-Contracts -Version (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).")
    }

    It 'passes over a released folder that is unchanged since its freeze' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
        Add-File 'contracts/catzc/0.1.0/gadgets/gadget.sample.json' '{}'
        $null = Publish-ContractRelease -Root catzc -Version 1.0.0 -RepositoryRoot $script:root
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Facts['ReleasedFolders'] | Should -Be 1
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'reports a released folder changed since its freeze' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
        Add-File 'contracts/catzc/0.1.0/gadgets/gadget.sample.json' '{}'
        $null = Publish-ContractRelease -Root catzc -Version 1.0.0 -RepositoryRoot $script:root
        Add-File 'contracts/catzc/1.0.0/gadgets/gadget.sample.json' '{ "widget": 1 }'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Issues |
            Should -Be @('contracts/catzc/1.0.0/gadgets/gadget.sample.json: changed since the release froze it; a released version folder is immutable, so a change lands in the current version, contracts/catzc/0.1.0/ (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).')
    }

    It 'reports a released folder with no .frozen record' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
        Add-File 'contracts/catzc/1.0.0/gadgets/gadget.sample.json' '{}'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Issues |
            Should -Be @('contracts/catzc/1.0.0: holds no .frozen record, so nothing proves it unchanged; a release freezes the current version with Publish-ContractRelease, which writes it (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).')
    }

    It 'reports a release folder under a vendor root, which never releases' -Tag 'ADR-REPO-CONTRACT-KEPTWHILEPINNED' {
        Add-File 'contracts/widget/1.0.0/gadgets/gadget.sample.json' '{}'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Issues |
            Should -Be @("contracts/widget/1.0.0/ is a release folder under the vendor root 'widget'; only catzc releases, and a vendor root follows its vendor in 0.1.0 (ADR-REPO-CONTRACT-KEPTWHILEPINNED).")
    }

    It 'reports the version folder <Version>, which is neither the current version nor a release' -Tag 'ADR-REPO-CONTRACT-CURRENTVERSION' -ForEach @(
        @{ Version = '0.0.0'; Text = 'is neither the current version 0.1.0 nor a release' }
        @{ Version = '0.2.0'; Text = 'is neither the current version 0.1.0 nor a release' }
        @{ Version = '6.6.666'; Text = 'is the local build version' }
    ) {
        Add-File "contracts/catzc/$Version/gadgets/gadget.sample.json" '{}'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        @($result.Issues | Where-Object { $_ -like "contracts/catzc/$Version/ $Text*" }).Count | Should -Be 1
    }

    It 'reports a contracts tree that does not list as one issue' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
        Add-File 'contracts/widget/draft/gadgets/gadget.sample.json' '{}'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] |
            Should -BeLike "contracts/ does not list ? contracts/widget: 'draft' is not a version folder*"
        $result.Facts['Assets'] | Should -Be 0
    }

    It 'reports a folder below a group as one issue' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
        Add-File 'contracts/widget/0.1.0/gadgets/flows/gadget.sample.json' '{}'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] |
            Should -BeLike "contracts/ does not list ? contracts/widget/0.1.0/gadgets: 'flows' is a folder below a group*"
    }

    It 'reports a dot-prefixed folder under contracts/ as one issue' -Tag 'ADR-REPO-CONTRACT-NODOTFOLDERS' {
        Add-File 'contracts/widget/0.1.0/.widget/gadget.sample.json' '{}'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] |
            Should -BeLike 'contracts/widget/0.1.0/.widget/ is a dot-prefixed folder under contracts/*applies_to*(ADR-REPO-CONTRACT-NODOTFOLDERS).'
    }

    It 'accepts a dot-prefixed file name and a dot-prefixed target' -Tag 'ADR-REPO-CONTRACT-LAYOUT', 'ADR-REPO-CONTRACT-NODOTFOLDERS' {
        Add-File 'contracts/.gitkeep'
        Add-File 'contracts/widget/0.1.0/gadgets/.widget'
        Set-Applies widget @{ 'gadgets/.widget' = '.widget' }
        Add-File '.widget' 'widget'
        $result = Test-Contracts -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Facts['Assets'] | Should -Be 1
    }

    It 'rejects a version that is not three numbers' {
        { Test-Contracts -Version '0.*' -RepositoryRoot $script:root -OutputFolder $script:out } | Should -Throw
    }
}

Describe 'Test-Contracts on the repository' -Tag 'L1', 'integrity', 'source-only' {
    It 'Test-Contracts passes over the current version folder of every root' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS', 'ADR-AUTO-TEST-QUALITYGATE' {
        $result = Test-Contracts -PassThru -OutputFolder (Join-Path $TestDrive 'contracts')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
