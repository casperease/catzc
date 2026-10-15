# Export-Comments moves a file's long comments into its comment page, one-way and losslessly
# ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)), tested in isolation:
# every test builds its own fixture repository in $TestDrive with widget/gadget files and exports only that tree
# (-RepositoryRoot, -Path). The page location comes from the shipped comments.yml
# ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
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
            & $script:writeFile $root 'automation/Catzc.Widget/tests/Get-Widget.Tests.ps1' "# A test's long prose`n# stays where it is.`n"
            $root
        }
        $script:pageRelative = 'docs/references/automation/catzc-widget/Get-Widget.ps1.md'
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
    }

    It 'moves the long comment into the page and leaves the residue in the file' -Tag 'ADR-REPO-COMMENTS#1' {
        $root = & $newRepository
        $changed = Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation')
        $changed | Should -Be @('automation/Catzc.Widget/Get-Widget.ps1')
        $text = & $readFile $root 'automation/Catzc.Widget/Get-Widget.ps1'
        $text.Contains('    # Sorted first, so the gadget order is stable across runs and the cache key never changes.') | Should -BeTrue
        $text.Contains("    # [comment:1](/$pageRelative#comment1)") | Should -BeTrue
        $page = & $readFile $root $pageRelative
        $page.Contains('# Sorted first') | Should -BeFalse -Because 'the page holds the prose without its comment marker'
        $page.Contains("across runs and the cache key never changes.`n" + '```') | Should -BeTrue
    }

    It 'leaves test files alone, and a second run changes nothing' -Tag 'ADR-AUTO-IDEM#1' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') | Out-Null
        $before = & $readFile $root 'automation/Catzc.Widget/Get-Widget.ps1'
        $pageBefore = & $readFile $root $pageRelative
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') | Should -BeNullOrEmpty
        & $readFile $root 'automation/Catzc.Widget/Get-Widget.ps1' | Should -BeExactly $before
        & $readFile $root $pageRelative | Should -BeExactly $pageBefore
        & $readFile $root 'automation/Catzc.Widget/tests/Get-Widget.Tests.ps1' | Should -BeExactly "# A test's long prose`n# stays where it is.`n"
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
