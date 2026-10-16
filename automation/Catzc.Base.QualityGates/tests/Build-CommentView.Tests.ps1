<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1
    folder: tests
    name: build-comment-view-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md
    adrs:
      - ADR-AUTO-IDEM#1
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-COMMENTS#4
      - ADR-REPO-OUTDIR#1
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
            & $script:writeFile $root 'automation/Catzc.Widget/Get-Widget.ps1' $script:source
            & $script:writeFile $root 'automation/Catzc.Widget/Get-Gadget.ps1' "function Get-Gadget { 'gadget' }`n"
            $root
        }
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
    }

    It 'writes the annotated copy of an exported file, equal to the original, and nothing for a file without a page' -Tag 'ADR-REPO-COMMENTS#4' {
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
