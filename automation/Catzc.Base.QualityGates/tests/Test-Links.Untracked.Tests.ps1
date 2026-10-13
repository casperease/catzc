# A markdown link must resolve on GitHub, which has only what git tracks
# ([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)). A fixture repository in $TestDrive stands
# in for the loaded repository; its tracked set is mocked (neutral widget/gadget names,
# [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-Links — untracked link targets' -Tag 'L0', 'logic', 'ADR-REPO-LINK#2' {
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
        & $writeFile $root 'docs/adr/index.md' "| Code | ADR |`n| ---- | --- |`n| ``ADR-TST-WIDGET`` | [widget-rules](widget/widget-rules.md) |`n"
        & $writeFile $root 'docs/adr/widget/widget-rules.md' "# Widget rules`n`n### Rule ADR-TST-WIDGET:1`n`nOne.`n"
        & $writeFile $root 'docs/widget.md' "# docs/widget.md`n`n## Widget`n`nSee [rules](adr/widget/widget-rules.md), [gadget](gadget.md), [folder](adr/widget), and [here](#widget).`n"
        & $writeFile $root 'docs/gadget.md' "# docs/gadget.md`n"
        # The fixture is the loaded repository; git tracks everything except docs/gadget.md.
        Mock Get-RepositoryRoot { $script:root } -ModuleName Catzc.Base.QualityGates
        Mock Get-GitTrackedPath { 'docs/adr/index.md', 'docs/adr/widget/widget-rules.md', 'docs/widget.md' } -ModuleName Catzc.Base.QualityGates
    }

    It 'reports a link to a file that exists locally but is not committed' {
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'docs/widget.md') -Kind Markdown -PassThru
        $untracked = @($result.Violations | Where-Object { "$($_.Type)" -eq 'Untracked' } | ForEach-Object { "$_" })
        $untracked.Count | Should -Be 1
        $untracked | Should -BeLike '*docs/gadget.md*not committed*'
    }

    It 'accepts tracked files, folders holding tracked files, and in-file anchors' {
        & $writeFile $root 'docs/widget.md' "# docs/widget.md`n`n## Widget`n`nSee [rules](adr/widget/widget-rules.md), [folder](adr/widget), and [here](#widget).`n"
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'docs/widget.md') -Kind Markdown -PassThru
        @($result.Violations | ForEach-Object { "$_" }) | Should -BeNullOrEmpty
    }

    It 'skips the tracked check for a root other than the loaded repository' {
        Mock Get-RepositoryRoot { Join-Path $TestDrive 'elsewhere' } -ModuleName Catzc.Base.QualityGates
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'docs/widget.md') -Kind Markdown -PassThru
        @($result.Violations | Where-Object { "$($_.Type)" -eq 'Untracked' }).Count | Should -Be 0
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
