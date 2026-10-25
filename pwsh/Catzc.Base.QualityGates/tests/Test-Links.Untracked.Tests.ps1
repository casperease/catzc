<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Test-Links.Untracked.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Test-Links — untracked link targets' -Tag 'L0', 'logic', 'ADR-REPO-LINK-MARKDOWNRELATIVE' {
    BeforeAll {
        $script:writeFile = {
            param([string] $Root, [string] $Relative, [string] $Text)
            $full = Join-Path $Root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $Text)
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:reportBase = Join-Path $TestDrive "reports-$([guid]::NewGuid().ToString('N'))"
        & $writeFile $root 'docs/drs/index.md' "| Code | ADR |`n| ---- | --- |`n| ``ADR-TST-WIDGET`` | [widget-rules](widget/widget-rules.md) |`n"
        & $writeFile $root 'docs/drs/widget/widget-rules.md' "# Widget rules`n`n### Rule ADR-TST-WIDGET-TURN`n`nOne.`n"
        & $writeFile $root 'docs/widget.md' "# docs/widget.md`n`n## Widget`n`nSee [rules](drs/widget/widget-rules.md), [gadget](gadget.md), [folder](drs/widget), and [here](#widget).`n"
        & $writeFile $root 'docs/gadget.md' "# docs/gadget.md`n"
        # The fixture is the loaded repository; git tracks everything except docs/gadget.md.
        Mock Get-RepositoryRoot { $script:root } -ModuleName Catzc.Base.QualityGates
        Mock Get-GitTrackedPath { 'docs/drs/index.md', 'docs/drs/widget/widget-rules.md', 'docs/widget.md' } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'reports a link to a file that exists locally but is not committed' {
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'docs/widget.md') -Kind Markdown -OutputFolder $reportBase -PassThru
        $untracked = @($result.Issues | Where-Object { $_ -match '\[Untracked\]' })
        $untracked.Count | Should -Be 1
        $untracked | Should -BeLike '*docs/gadget.md*not committed*'
    }

    It 'accepts tracked files, folders holding tracked files, and in-file anchors' {
        & $writeFile $root 'docs/widget.md' "# docs/widget.md`n`n## Widget`n`nSee [rules](drs/widget/widget-rules.md), [folder](drs/widget), and [here](#widget).`n"
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'docs/widget.md') -Kind Markdown -OutputFolder $reportBase -PassThru
        $result.Issues | Should -BeNullOrEmpty
    }

    It 'skips the tracked check for a root other than the loaded repository' {
        Mock Get-RepositoryRoot { Join-Path $TestDrive 'elsewhere' } -ModuleName Catzc.Base.QualityGates
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'docs/widget.md') -Kind Markdown -OutputFolder $reportBase -PassThru
        @($result.Issues | Where-Object { $_ -match '\[Untracked\]' }).Count | Should -Be 0
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
