# Format-Comments puts every comment residue into its one-liner shape in place
# ([ADR-REPO-COMMENTS#5](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments5),
# [ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)), tested in isolation:
# every test builds its own fixture repository in $TestDrive with widget/gadget files and formats only that tree
# (-RepositoryRoot, -Path). The residue rules come from the shipped comments.yml
# ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
Describe 'Format-Comments' -Tag 'L0', 'logic' {
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
        $script:pageRelative = 'docs/references/automation/catzc-widget/Get-Widget.ps1.md'
        $script:link = "[comment:1](/$pageRelative#comment1)"
        $script:source = (@(
                'function Get-Widget {'
                '    # Sorted first so the gadget order is stable across every run and the cache key of the widget never changes'
                "    # $link"
                '    Get-Gadget | Sort-Object'
                '}'
                ''
            ) -join "`n")
        $script:newRepository = {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            & $script:writeFile $root '.editorconfig' ((@('[*.{ps1,psm1,psd1}]', 'max_line_length = 80', '') -join "`n"))
            & $script:writeFile $root 'automation/Catzc.Widget/Get-Widget.ps1' $script:source
            & $script:writeFile $root 'automation/Catzc.Widget/Get-Gadget.ps1' "function Get-Gadget {`n    # This function gets gadgets.`n    # [comment:1](/docs/references/automation/catzc-widget/Get-Gadget.ps1.md#comment1)`n    'gadget'`n}`n"
            $root
        }
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
    }

    It 'cuts the overlong insight line to the file''s line limit and leaves the rest of the file as written' -Tag 'ADR-REPO-COMMENTS#5' {
        $root = & $newRepository
        $changed = Format-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation')
        $changed | Should -Be @('automation/Catzc.Widget/Get-Widget.ps1')
        $lines = (& $readFile $root 'automation/Catzc.Widget/Get-Widget.ps1') -split "`n"
        $lines[1].Length | Should -BeLessOrEqual 80
        $lines[1] | Should -BeLike '    # Sorted first so the gadget order*...'
        $lines[2] | Should -Be "    # $link"
        $lines[3] | Should -Be '    Get-Gadget | Sort-Object'
    }

    It 'leaves an obvious insight to a person, and a second run changes nothing' -Tag 'ADR-REPO-COMMENTS#5', 'ADR-AUTO-IDEM#1' {
        $root = & $newRepository
        $first = Format-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') -PassThru
        $first.ChangedCount | Should -Be 1
        @($first.Fixed).Count | Should -Be 1
        @($first.Unfixable).Count | Should -Be 1
        "$($first.Unfixable[0])" | Should -Match '^automation/Catzc\.Widget/Get-Gadget\.ps1:2 \[Obvious\] '
        & $readFile $root 'automation/Catzc.Widget/Get-Gadget.ps1' | Should -BeLike '*# This function gets gadgets.*'
        $second = Format-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') -PassThru
        $second.ChangedCount | Should -Be 0
        @($second.Fixed).Count | Should -Be 0
        @($second.Unfixable).Count | Should -Be 1
    }

    It 'writes nothing under -DryRun and reports what it would fix' -Tag 'ADR-AUTO-DRYRUN#1' {
        $root = & $newRepository
        $result = Format-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') -DryRun -PassThru
        $result.DryRun | Should -BeTrue
        $result.ChangedFiles | Should -Be @('automation/Catzc.Widget/Get-Widget.ps1')
        $result.Fixed[0].Kind | Should -Be ([Catzc.Base.QualityGates.CommentFindingKind]::Overlong)
        & $readFile $root 'automation/Catzc.Widget/Get-Widget.ps1' | Should -BeExactly $source
    }
}
