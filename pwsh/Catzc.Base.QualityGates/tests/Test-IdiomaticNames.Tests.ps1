Describe 'Test-IdiomaticNames' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'widget_root/Bad-Folder/good_name.wdg'; 'widget_root/fine/fine_name.wdg'; 'notes.md' }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'languages' } {
            [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{ languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; naming = [ordered]@{ folder = 'snake'; file = 'snake' } }
                    }
                })
        }
        $script:reportFolder = Join-Path $TestDrive 'idiomatic-names'
    }

    It 'reports each folder and file name that breaks its language''s naming, over the tracked files' -Tag 'ADR-AUTO-IDIOM-LANGUAGEIDIOM' {
        $result = Test-IdiomaticNames -PassThru -OutputFolder $script:reportFolder

        $result.Issues | Should -Be @('widget_root/Bad-Folder/: the folder is not snake (widget)')
    }

    It 'passes when every tracked name is idiomatic' -Tag 'ADR-AUTO-IDIOM-LANGUAGEIDIOM' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'widget_root/fine/fine_name.wdg' }

        $result = Test-IdiomaticNames -PassThru -OutputFolder $script:reportFolder

        $result.Issues | Should -BeNullOrEmpty
    }
}
