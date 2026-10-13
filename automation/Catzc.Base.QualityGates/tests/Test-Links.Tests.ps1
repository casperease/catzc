# Test-Links is the link gate ([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)): the same
# engine as Format-Links, read-only. A fixture repository in
# $TestDrive (neutral widget/gadget codes,
# [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) holds the files under test.
Describe 'Test-Links' -Tag 'L0', 'logic' {
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
    }

    It 'passes when every link is aligned and resolves' -Tag 'ADR-REPO-LINK#8' {
        & $writeFile $root 'src/widget.ps1' "# See [ADR-TST-WIDGET#1](/docs/adr/widget/widget-rules.md#rule-adr-tst-widget1).`n"
        { Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') } | Should -Not -Throw
    }

    It 'throws on an off-form code link, naming the file, line, and Format-Links' -Tag 'ADR-REPO-LINK#8' {
        & $writeFile $root 'src/widget.ps1' "`$x = 1`n# See ADR-TST-WIDGET:1.`n"
        { Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') } | Should -Throw '*run Format-Links*src/widget.ps1:2:*'
    }

    It 'reads only: the file is unchanged after the gate' -Tag 'ADR-REPO-LINK#8' {
        $text = "# See ADR-TST-WIDGET:1.`n"
        & $writeFile $root 'src/widget.ps1' $text
        Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -PassThru | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $root 'src/widget.ps1')) | Should -BeExactly $text
    }

    It 'separates fixable from unfixable violations in its result' -Tag 'ADR-REPO-LINK#8' {
        & $writeFile $root 'src/widget.ps1' "# See ADR-TST-WIDGET:1 and docs/adr/nowhere/gadget.md.`n"
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -PassThru
        $result.ViolationCount | Should -Be 2
        @($result.Violations | Where-Object IsFixable).Count | Should -Be 1
        @($result.Violations | Where-Object { -not $_.IsFixable }).Type | Should -Be 'Dangling'
    }

    It 'does not fail on an overlong line it can only report' -Tag 'ADR-REPO-LINK#8' {
        Mock Get-Config -ParameterFilter { $Config -eq 'links' } -ModuleName Catzc.Base.QualityGates -MockWith {
            [Catzc.Base.QualityGates.LinksConfig]::new(@{ line_limit = @{ '.ps1' = 30 } })
        }
        & $writeFile $root 'src/widget.ps1' "# [ADR-TST-WIDGET#1](/docs/adr/widget/widget-rules.md#rule-adr-tst-widget1)`n"
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -PassThru
        $result.ViolationCount | Should -Be 0
    }
}
