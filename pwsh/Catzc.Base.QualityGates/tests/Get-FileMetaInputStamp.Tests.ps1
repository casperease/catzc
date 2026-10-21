<#
---
catzc:
  immutable:
    with_body_sha: "4f0e8b4e81e8"
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-FileMetaInputStamp.ps1
---
#>

Describe 'Get-FileMetaInputStamp' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $script:widget = Join-Path $script:root 'widgets/Get-Widget.wdg'
        $script:note = Join-Path $script:root 'notes/widget.md'
        $script:config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{ 'drs-codes' = @{ section = 'edges'; keys = @('cites'); select = @(@{ classes = @('function') }) } }
            })
        $script:languages = [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{
                languages = [ordered]@{ widget = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' } }
            })
    }

    BeforeEach {
        $script:codes = @('ADR-WIDGET', 'ADR-WIDGET-SPINS')
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'comment-pages' } { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{}) }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'languages' } { $script:languages }
        Mock Get-CommentPage -ModuleName Catzc.Base.QualityGates { $null }
        Mock Get-FileKind -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Class = ($Path -like '*.wdg') ? 'function' : 'doc' }
        }
        Mock Get-DrsCitationMap -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Codes = $script:codes } }
        $script:stamp = {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ F = @($script:widget, $script:note); R = $script:root; C = $script:config } {
                param($F, $R, $C)
                Get-FileMetaInputStamp -File $F -RepositoryRoot $R -Config $C
            }
        }
    }

    It 'changes the stamp of a file the drs-codes kind selects when a code is registered, and of no other file' {
        $before = & $script:stamp
        $script:codes = @('ADR-WIDGET', 'ADR-WIDGET-SPINS', 'ADR-WIDGET-TURNS')
        $after = & $script:stamp
        $after[$script:widget] | Should -Not -Be $before[$script:widget]
        $after[$script:note] | Should -Be $before[$script:note]
    }

    It 'keeps the stamp while the registered codes are the same, in any order' {
        $before = & $script:stamp
        $script:codes = @('ADR-WIDGET-SPINS', 'ADR-WIDGET')
        (& $script:stamp)[$script:widget] | Should -Be $before[$script:widget]
    }

    It 'reads the code map once per call, however many files it selects' {
        $null = & $script:stamp
        Should -Invoke Get-DrsCitationMap -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }
}
