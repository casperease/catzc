<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-Comments.Tests.ps1
    kind: test
---
#>

# Test-Comments is the gate that every long comment lives in its file's comment page and every residue and section
# pair up ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)), tested in
# isolation on a widget/gadget fixture repository in $TestDrive; each case breaks the pairing one way.
Describe 'Test-Comments' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:writeFile = {
            param([string] $Root, [string] $Relative, [string] $Text)
            $full = Join-Path $Root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $Text)
        }
        $script:readFile = {
            param([string] $Root, [string] $Relative)
            [System.IO.File]::ReadAllText((Join-Path $Root $Relative))
        }
        $script:newRepository = {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            & $script:writeFile $root '.editorconfig' ((@('[*.{ps1,psm1,psd1}]', 'max_line_length = 120', '') -join "`n"))
            & $script:writeFile $root 'automation/Catzc.Widget/Get-Widget.ps1' ((@(
                        'function Get-Widget {'
                        '    # Sorted first, so the gadget order is stable'
                        '    # across runs and the cache key never changes.'
                        '    Get-Gadget | Sort-Object'
                        '}'
                        ''
                    ) -join "`n"))
            $root
        }
        $script:file = 'automation/Catzc.Widget/Get-Widget.ps1'
        $script:pageRelative = 'docs/references/automation/catzc-widget/Get-Widget.ps1.md'
        $script:check = {
            param([string] $Root)
            Test-Comments -RepositoryRoot $Root -Path (Join-Path $Root 'automation') -OutputFolder (Join-Path $Root 'out/report') -PassThru
        }
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
    }

    It 'reports a long comment still in the file, then passes once it is exported' -Tag 'ADR-REPO-COMMENTS#5' {
        $root = & $newRepository
        $before = & $check $root
        $before.IssueCount | Should -Be 1
        $before.Issues[0] | Should -BeLike "$($file):2: a 2-line comment is still in the file*Export-Comments"
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') | Out-Null
        $after = & $check $root
        $after.IssueCount | Should -Be 0
        $after.ResidueCount | Should -Be 1
    }

    It 'reports a residue whose section is missing and a section no residue links' -Tag 'ADR-REPO-COMMENTS#5' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') | Out-Null
        $page = & $readFile $root $pageRelative
        & $writeFile $root $pageRelative ($page.Replace('## comment:1', '## comment:7'))
        $report = & $check $root
        $report.IssueCount | Should -Be 2
        ($report.Issues -join "`n") | Should -BeLike "*comment:1 has no section in $pageRelative*"
        ($report.Issues -join "`n") | Should -BeLike '*section comment:7 is linked by no residue*'
    }

    It 'reports a residue that links another file''s page and a number used twice' -Tag 'ADR-REPO-COMMENTS#5' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') | Out-Null
        $text = & $readFile $root $file
        $residue = "    # [comment:1](/$pageRelative#comment1)"
        $foreign = '    # [comment:2](/docs/references/automation/catzc-widget/Get-Gadget.ps1.md#comment2)'
        & $writeFile $root $file ($text.Replace($residue, "$residue`n    # Gadget order again.`n$residue`n    # Gadget lookup.`n$foreign"))
        $issues = (& $check $root).Issues -join "`n"
        $issues | Should -BeLike '*comment:1 is used twice in the file*'
        $issues | Should -BeLike "*comment:2 links docs/references/automation/catzc-widget/Get-Gadget.ps1.md, not the file's page*"
    }
}
