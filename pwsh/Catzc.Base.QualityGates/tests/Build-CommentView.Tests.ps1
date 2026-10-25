<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Build-CommentView.Tests.ps1.md"
  warning: "Generated Header"
---
#>

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
            & $script:writeFile $root "$(Get-CatzcModulesFolder)/Catzc.Widget/Get-Widget.ps1" $script:source
            & $script:writeFile $root "$(Get-CatzcModulesFolder)/Catzc.Widget/Get-Gadget.ps1" "function Get-Gadget { 'gadget' }`n"
            $root
        }
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
    }

    It 'writes the annotated copy of an exported file, equal to the original, and nothing for a file without a page' -Tag 'ADR-REPO-COMMENTS-INLINEVIEWGENERATED' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) | Out-Null
        $written = @(Build-CommentView -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)))
        $written | Should -Be @('out/annotated/pwsh/Catzc.Widget/Get-Widget.ps1')
        [System.IO.File]::ReadAllText((Join-Path $root $written[0])) | Should -BeExactly $source
    }

    It 'is idempotent and writes nothing under -DryRun' -Tag 'ADR-AUTO-IDEM-CHECKBEFOREACTING' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) | Out-Null
        @(Build-CommentView -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) -DryRun).Count | Should -Be 1
        Test-Path (Join-Path $root 'out/annotated') | Should -BeFalse
        Build-CommentView -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) | Out-Null
        Build-CommentView -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) | Should -BeNullOrEmpty
    }
}
