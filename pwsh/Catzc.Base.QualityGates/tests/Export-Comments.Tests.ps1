<#
---
catzc:
  immutable:
    with_body_sha: "92888805cc7a"
  edges:
    docs: "[Export-Comments.Tests.ps1.md](docs/references/pwsh/catzc-base-quality-gates/tests/Export-Comments.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/Export-Comments.ps1
    cites:
      - ADR-AUTO-DRYRUN-SIDEEFFECTSTAKEDRYRUN
      - ADR-AUTO-IDEM-CHECKBEFOREACTING
      - ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG
      - ADR-PRIN-ONELIVE-ONEVERSION
      - ADR-REPO-COMMENTS-ONELINEOFINSIGHT
      - ADR-REPO-COMMENTS-COMMENTPAGEPLACE
---
#>

# cspell:ignore ngadget  -- the escape-sequence artifact in the "`ngadget" fixture strings
Describe 'Export-Comments' -Tag 'L0', 'logic' {
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
        $script:source = (@(
                'function Get-Widget {'
                '    # Sorted first, so the gadget order is stable'
                '    # across runs and the cache key never changes.'
                '    Get-Gadget | Sort-Object'
                '}'
                ''
            ) -join "`n")
        $script:newRepository = {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            & $script:writeFile $root '.editorconfig' ((@('[*.{ps1,psm1,psd1}]', 'max_line_length = 120', '') -join "`n"))
            & $script:writeFile $root "$(Get-CatzcModulesFolder)/Catzc.Widget/Get-Widget.ps1" $script:source
            & $script:writeFile $root "$(Get-CatzcModulesFolder)/Catzc.Widget/assets/root/gadget.yml" "# A template's header, copied verbatim,`n# stays where it is.`ngadget: 1`n"
            $root
        }
        $script:pageRelative = 'docs/references/pwsh/catzc-widget/Get-Widget.ps1.md'
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
    }

    It 'moves the long comment into the page and leaves nothing in the file' -Tag 'ADR-REPO-COMMENTS-ONELINEOFINSIGHT' {
        $root = & $newRepository
        $changed = Export-Comments -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder))
        $changed | Should -Be @("$(Get-CatzcModulesFolder)/Catzc.Widget/Get-Widget.ps1")
        $text = & $readFile $root "$(Get-CatzcModulesFolder)/Catzc.Widget/Get-Widget.ps1"
        $text | Should -BeExactly "function Get-Widget {`n    Get-Gadget | Sort-Object`n}`n"
        $page = & $readFile $root $pageRelative
        $page.Contains('# Sorted first') | Should -BeFalse -Because 'the page holds the prose without its comment marker'
        $page.Contains("across runs and the cache key never changes.`n" + '```') | Should -BeTrue
    }

    It 'leaves an asset''s comments in place' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) | Out-Null
        & $readFile $root "$(Get-CatzcModulesFolder)/Catzc.Widget/assets/root/gadget.yml" | Should -BeExactly "# A template's header, copied verbatim,`n# stays where it is.`ngadget: 1`n"
    }

    It 'changes nothing on a second run' -Tag 'ADR-AUTO-IDEM-CHECKBEFOREACTING' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) | Out-Null
        $before = & $readFile $root "$(Get-CatzcModulesFolder)/Catzc.Widget/Get-Widget.ps1"
        $pageBefore = & $readFile $root $pageRelative
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) | Should -BeNullOrEmpty
        & $readFile $root "$(Get-CatzcModulesFolder)/Catzc.Widget/Get-Widget.ps1" | Should -BeExactly $before
        & $readFile $root $pageRelative | Should -BeExactly $pageBefore
    }

    It 'writes nothing under -DryRun and returns the would-be results under -PassThru' -Tag 'ADR-AUTO-DRYRUN-SIDEEFFECTSTAKEDRYRUN' {
        $root = & $newRepository
        $results = @(Export-Comments -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) -DryRun -PassThru)
        $results.Count | Should -Be 1
        $results[0].MovedCount | Should -Be 1
        $results[0].Page | Should -Be $pageRelative
        & $readFile $root "$(Get-CatzcModulesFolder)/Catzc.Widget/Get-Widget.ps1" | Should -BeExactly $source
        Test-Path (Join-Path $root $pageRelative) | Should -BeFalse
    }
}
