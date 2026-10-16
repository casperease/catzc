<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Export-Comments.Tests.ps1
    folder: tests
    name: export-comments-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/Export-Comments.Tests.ps1.md
    cites:
      - ADR-AUTO-DRYRUN#1
      - ADR-AUTO-IDEM#1
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-COMMENTS#{1,3}
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
            & $script:writeFile $root 'automation/Catzc.Widget/Get-Widget.ps1' $script:source
            & $script:writeFile $root 'automation/Catzc.Widget/assets/root/gadget.yml' "# A template's header, copied verbatim,`n# stays where it is.`ngadget: 1`n"
            $root
        }
        $script:pageRelative = 'docs/references/automation/catzc-widget/Get-Widget.ps1.md'
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
    }

    It 'moves the long comment into the page and leaves nothing in the file' -Tag 'ADR-REPO-COMMENTS#1' {
        $root = & $newRepository
        $changed = Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation')
        $changed | Should -Be @('automation/Catzc.Widget/Get-Widget.ps1')
        $text = & $readFile $root 'automation/Catzc.Widget/Get-Widget.ps1'
        $text | Should -BeExactly "function Get-Widget {`n    Get-Gadget | Sort-Object`n}`n"
        $page = & $readFile $root $pageRelative
        $page.Contains('# Sorted first') | Should -BeFalse -Because 'the page holds the prose without its comment marker'
        $page.Contains("across runs and the cache key never changes.`n" + '```') | Should -BeTrue
    }

    It 'leaves an asset''s comments in place' -Tag 'ADR-REPO-COMMENTS#3' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') | Out-Null
        & $readFile $root 'automation/Catzc.Widget/assets/root/gadget.yml' | Should -BeExactly "# A template's header, copied verbatim,`n# stays where it is.`ngadget: 1`n"
    }

    It 'changes nothing on a second run' -Tag 'ADR-AUTO-IDEM#1' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') | Out-Null
        $before = & $readFile $root 'automation/Catzc.Widget/Get-Widget.ps1'
        $pageBefore = & $readFile $root $pageRelative
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') | Should -BeNullOrEmpty
        & $readFile $root 'automation/Catzc.Widget/Get-Widget.ps1' | Should -BeExactly $before
        & $readFile $root $pageRelative | Should -BeExactly $pageBefore
    }

    It 'writes nothing under -DryRun and returns the would-be results under -PassThru' -Tag 'ADR-AUTO-DRYRUN#1' {
        $root = & $newRepository
        $results = @(Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') -DryRun -PassThru)
        $results.Count | Should -Be 1
        $results[0].MovedCount | Should -Be 1
        $results[0].Page | Should -Be $pageRelative
        & $readFile $root 'automation/Catzc.Widget/Get-Widget.ps1' | Should -BeExactly $source
        Test-Path (Join-Path $root $pageRelative) | Should -BeFalse
    }
}
