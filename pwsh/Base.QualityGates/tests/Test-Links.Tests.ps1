<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Test-Links.Tests.ps1.md"
  header: "generated"
---
#>

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
        & $writeFile $root 'docs/drs/index.md' "| Code | ADR |`n| ---- | --- |`n| ``ADR-TST-WIDGET`` | [widget-rules](widget/widget-rules.md) |`n"
        & $writeFile $root 'docs/drs/widget/widget-rules.md' "# Widget rules`n`n### Rule ADR-TST-WIDGET-SPIN`n`nOne.`n"
    }

    It 'passes when every link is aligned and resolves' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL', 'ADR-AUTO-TEST-QUALITYGATE' {
        & $writeFile $root 'src/widget.ps1' "# See [ADR-TST-WIDGET-SPIN](/docs/drs/widget/widget-rules.md#rule-adr-tst-widget-spin).`n"
        { Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase } |
            Should -Not -Throw
    }

    It 'throws on an off-form code link, naming the file, line, and Format-Links' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL', 'ADR-AUTO-TEST-QUALITYGATE' {
        & $writeFile $root 'src/widget.ps1' "`$x = 1`n# See ADR-TST-WIDGET-SPIN.`n"
        { Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase } |
            Should -Throw 'Test-Links failed: 1 issue(s)*src/widget.ps1:2:*run Format-Links*'
    }

    It 'leaves the cites of a line-comment meta head alone, and still checks the comments below it' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
        $head = "# ---`n# catzc:`n#   edges:`n#     cites:`n#       - ADR-TST-WIDGET-SPIN`n# ---`n"
        & $writeFile $root 'src/widget.yml' ($head + "`nwidget: 1`n")
        & $writeFile $root 'src/gadget.yml' ($head + "`n# See ADR-TST-WIDGET-SPIN.`ngadget: 1`n")
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -Match 'src/gadget.yml:8:'
    }

    It 'resolves a code head''s docs edge from the file''s folder, and reports one that does not open' -Tag 'ADR-REPO-FILEMETA-FEWLINKS' {
        $head = { param([string] $Target) "<#`n---`ncatzc:`n  docs: ""$Target""`n  header: ""generated""`n---`n#>`n`nfunction Get-Widget { }`n" }
        & $writeFile $root 'docs/references/src/widget.ps1.md' "# src/widget.ps1`n"
        & $writeFile $root 'src/widget.ps1' (& $head '../docs/references/src/widget.ps1.md')
        (Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru).IssueCount | Should -Be 0

        & $writeFile $root 'src/widget.ps1' (& $head 'docs/references/src/widget.ps1.md')
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] |
            Should -Match 'src/widget\.ps1:4:.*\[Dangling\].*docs edge .docs/references/src/widget\.ps1\.md. does not resolve from the file''s folder'

        & $writeFile $root 'src/widget.ps1' (& $head '../docs/references/src/gone.ps1.md')
        (Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru).IssueCount | Should -Be 1
    }

    It 'reads only: the file is unchanged after the gate' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
        $text = "# See ADR-TST-WIDGET-SPIN.`n"
        & $writeFile $root 'src/widget.ps1' $text
        Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $root 'src/widget.ps1')) | Should -BeExactly $text
    }

    It 'separates fixable from unfixable violations in its result' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL', 'ADR-AUTO-TEST-QUALITYGATE' {
        & $writeFile $root 'src/widget.ps1' "# See ADR-TST-WIDGET-SPIN and docs/drs/nowhere/gadget.md.`n"
        $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
        $result.Subject | Should -Be 'links'
        $result.IssueCount | Should -Be 2
        $result.Facts['FixableCount'] | Should -Be 1
        $result.Facts['FileCount'] | Should -Be 1
        $unfixable = @($result.Issues | Where-Object { $_ -notmatch 'run Format-Links$' })
        $unfixable.Count | Should -Be 1
        $unfixable[0] | Should -Match '\[Dangling\]'
    }

    It 'does not fail on an overlong line it can only report' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
        Mock Get-Config -ParameterFilter { $Config -eq 'links' } -ModuleName Catzc.Base.QualityGates -MockWith {
            [Catzc.Base.QualityGates.LinksConfig]::new(@{ line_limit = @{ '.ps1' = 30 } })
        }
        & $writeFile $root 'src/widget.ps1' "# [ADR-TST-WIDGET-SPIN](/docs/drs/widget/widget-rules.md#rule-adr-tst-widget-spin)`n"
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
            & $writeFile $root 'src/Gadget.cs' "class Gadget { const string Why = `"ADR-TST-WIDGET:1`"; const string Heading = `"### Rule ADR-TST-WIDGET-SPIN`"; }`n"
        }

        It 'fails the gate in gate mode, once per numbered citation' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING', 'PDR-CONFIG-EXCEPTIONISCONFIGENTRY' {
            & $useLinks ([ordered]@{})
            $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
            $result.IssueCount | Should -Be 2
            $result.Issues | Should -BeLike '*`[StringNumbered`]*'
            @($result.Issues | Where-Object { $_ -like 'src/widget.ps1:1:*' }) | Should -HaveCount 1
            $result.Facts['ReportedCount'] | Should -Be 0
        }

        It 'lists the findings and passes in report mode' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING', 'PDR-CONFIG-EXCEPTIONISCONFIGENTRY' {
            & $useLinks ([ordered]@{ mode = 'report' })
            { Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase } |
                Should -Not -Throw
            $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
            $result.IssueCount | Should -Be 0
            $result.Facts['ReportedCount'] | Should -Be 2
            $result.Facts['Reported'] | Should -BeLike '*`[StringNumbered`]*'
        }

        It 'leaves out a file its exempt globs match' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING', 'PDR-CONFIG-EXCEPTIONISCONFIGENTRY' {
            & $useLinks ([ordered]@{ exempt = [ordered]@{ 'src/*.cs' = 'gadget fixtures' } })
            $result = Test-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -OutputFolder $reportBase -PassThru
            $result.IssueCount | Should -Be 1
            $result.Issues[0] | Should -BeLike 'src/widget.ps1:1:*'
        }
    }
}
