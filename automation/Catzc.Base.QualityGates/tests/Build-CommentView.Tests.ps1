# Build-CommentView writes the inverse of Export-Comments: the annotated copy of every file that carries residues,
# under the view folder in out/ ([ADR-REPO-OUTDIR#1](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir1)),
# equal to the file before its comments moved
# ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). Tested in isolation on a
# widget/gadget fixture repository in $TestDrive.
Describe 'Build-CommentView' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:writeFile = {
            param([string] $Root, [string] $Relative, [string] $Text)
            $full = Join-Path $Root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $Text)
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
            & $script:writeFile $root 'automation/Catzc.Widget/Get-Gadget.ps1' "function Get-Gadget { 'gadget' }`n"
            $root
        }
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
    }

    It 'writes the annotated copy of an exported file, equal to the original, and nothing for a file without residues' -Tag 'ADR-REPO-COMMENTS#4' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') | Out-Null
        $written = @(Build-CommentView -RepositoryRoot $root -Path (Join-Path $root 'automation'))
        $written | Should -Be @('out/annotated/automation/Catzc.Widget/Get-Widget.ps1')
        [System.IO.File]::ReadAllText((Join-Path $root $written[0])) | Should -BeExactly $source
    }

    It 'is idempotent and writes nothing under -DryRun' -Tag 'ADR-AUTO-IDEM#1' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root 'automation') | Out-Null
        @(Build-CommentView -RepositoryRoot $root -Path (Join-Path $root 'automation') -DryRun).Count | Should -Be 1
        Test-Path (Join-Path $root 'out/annotated') | Should -BeFalse
        Build-CommentView -RepositoryRoot $root -Path (Join-Path $root 'automation') | Out-Null
        Build-CommentView -RepositoryRoot $root -Path (Join-Path $root 'automation') | Should -BeNullOrEmpty
    }
}
