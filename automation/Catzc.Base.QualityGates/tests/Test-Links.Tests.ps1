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
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:reportBase = Join-Path $TestDrive "reports-$([guid]::NewGuid().ToString('N'))"
        & $writeFile $root 'docs/adr/index.md' "| Code | ADR |`n| ---- | --- |`n| ``ADR-TST-WIDGET`` | [widget-rules](widget/widget-rules.md) |`n"
        & $writeFile $root 'docs/adr/widget/widget-rules.md' "# Widget rules`n`n### Rule ADR-TST-WIDGET:1`n`nOne.`n"
    }

    It 'passes when every link is aligned and resolves' -Tag 'ADR-REPO-LINK#8', 'ADR-AUTO-TEST#35' {
        & $writeFile $root 'src/widget.ps1' "# See [ADR-TST-WIDGET#1](/docs/adr/widget/widget-rules.md#rule-adr-tst-widget1).`n"
        { Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase } | Should -Not -Throw
    }

    It 'throws on an off-form code link, naming the file, line, and Format-Links' -Tag 'ADR-REPO-LINK#8', 'ADR-AUTO-TEST#35' {
        & $writeFile $root 'src/widget.ps1' "`$x = 1`n# See ADR-TST-WIDGET:1.`n"
        { Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase } |
            Should -Throw 'Test-Links failed: 1 issue(s)*src/widget.ps1:2:*run Format-Links*'
    }

    It 'reads only: the file is unchanged after the gate' -Tag 'ADR-REPO-LINK#8' {
        $text = "# See ADR-TST-WIDGET:1.`n"
        & $writeFile $root 'src/widget.ps1' $text
        Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $root 'src/widget.ps1')) | Should -BeExactly $text
    }

    It 'separates fixable from unfixable violations in its result' -Tag 'ADR-REPO-LINK#8', 'ADR-AUTO-TEST#35' {
        & $writeFile $root 'src/widget.ps1' "# See ADR-TST-WIDGET:1 and docs/adr/nowhere/gadget.md.`n"
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
        $result.Subject | Should -Be 'links'
        $result.IssueCount | Should -Be 2
        $result.FixableCount | Should -Be 1
        $result.FileCount | Should -Be 1
        $unfixable = @($result.Issues | Where-Object { $_ -notmatch 'run Format-Links$' })
        $unfixable.Count | Should -Be 1
        $unfixable[0] | Should -Match '\[Dangling\]'
    }

    It 'does not fail on an overlong line it can only report' -Tag 'ADR-REPO-LINK#8' {
        Mock Get-Config -ParameterFilter { $Config -eq 'links' } -ModuleName Catzc.Base.QualityGates -MockWith {
            [Catzc.Base.QualityGates.LinksConfig]::new(@{ line_limit = @{ '.ps1' = 30 } })
        }
        & $writeFile $root 'src/widget.ps1' "# [ADR-TST-WIDGET#1](/docs/adr/widget/widget-rules.md#rule-adr-tst-widget1)`n"
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
        $result.IssueCount | Should -Be 0
    }

    Context 'rule citations in string literals' {
        BeforeEach {
            $script:useLinks = {
                param([System.Collections.IDictionary] $StringCitations)
                $config = [Catzc.Base.QualityGates.LinksConfig]::new(@{ string_citations = $StringCitations })
                Mock Get-Config -ParameterFilter { $Config -eq 'links' } -ModuleName Catzc.Base.QualityGates -MockWith { $config }.GetNewClosure()
            }
            & $writeFile $root 'src/widget.ps1' "throw 'a widget needs a gadget (ADR-TST-WIDGET:1)'`n"
            & $writeFile $root 'src/Gadget.cs' "class Gadget { const string Why = `"ADR-TST-WIDGET:1`"; const string Heading = `"### Rule ADR-TST-WIDGET:1`"; }`n"
        }

        It 'fails the gate in gate mode, once per citation, naming Format-Links' -Tag 'ADR-REPO-LINK#5', 'ADR-PRIN-CONFIG#4' {
            & $useLinks ([ordered]@{})
            $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
            $result.IssueCount | Should -Be 2
            $result.Issues | Should -BeLike '*`[StringColon`]*run Format-Links'
            @($result.Issues | Where-Object { $_ -like 'src/widget.ps1:1:*' }) | Should -HaveCount 1
            $result.ReportedCount | Should -Be 0
        }

        It 'lists the findings and passes in report mode' -Tag 'ADR-REPO-LINK#5', 'ADR-PRIN-CONFIG#4' {
            & $useLinks ([ordered]@{ mode = 'report' })
            { Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase } | Should -Not -Throw
            $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
            $result.IssueCount | Should -Be 0
            $result.ReportedCount | Should -Be 2
            $result.Reported | Should -BeLike '*`[StringColon`]*'
        }

        It 'leaves out a file its exempt globs match' -Tag 'ADR-REPO-LINK#5', 'ADR-PRIN-CONFIG#4' {
            & $useLinks ([ordered]@{ exempt = [ordered]@{ 'src/*.cs' = 'gadget fixtures' } })
            $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
            $result.IssueCount | Should -Be 1
            $result.Issues[0] | Should -BeLike 'src/widget.ps1:1:*'
        }
    }
}
