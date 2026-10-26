Describe 'Assert-IdiomaticNames' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'languages' } {
            [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{ languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; naming = [ordered]@{ folder = 'snake'; file = 'snake' } }
                    }
                })
        }
    }

    It 'throws with every misnamed folder and file when a tracked name breaks its language''s naming' -Tag 'ADR-AUTO-IDIOM-HELDBYGATE' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'widget_root/Bad-Folder/BadName.wdg' }

        { Assert-IdiomaticNames } |
            Should -Throw '*2 file, folder, function and type name(s)*widget_root/Bad-Folder/: the folder is not snake (widget)*widget_root/Bad-Folder/BadName.wdg: the file name is not snake (widget)*'
    }

    It 'passes silently when every tracked name is idiomatic' -Tag 'ADR-AUTO-IDIOM-HELDBYGATE' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'widget_root/fine/fine_name.wdg'; 'notes.md' }

        { Assert-IdiomaticNames } | Should -Not -Throw
    }
}
