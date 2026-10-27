Describe 'ConvertFrom-NormalName' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{
                naming    = [ordered]@{ normal_form = 'snake' }
                languages = [ordered]@{
                    widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; naming = [ordered]@{ function = 'verb-noun'; type = 'pascal-dotted'; file = @('verb-noun', 'pascal') } }
                    gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never'; naming = [ordered]@{ function = 'snake'; type = 'pascal'; folder = 'flat' } }
                }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'languages' } { $script:fixture }
    }

    It 'renders a normal-form name in the language''s first case for the kind' -Tag 'ADR-AUTO-IDIOM-ROUNDTRIP' -ForEach @(
        @{ Name = 'get_gadget_part'; Language = 'widget'; Kind = 'function'; Expected = 'Get-GadgetPart' }
        @{ Name = 'convert_to_gadget_name'; Language = 'widget'; Kind = 'function'; Expected = 'ConvertTo-GadgetName' }
        @{ Name = 'widget.base.gadget_parts'; Language = 'widget'; Kind = 'type'; Expected = 'Widget.Base.GadgetParts' }
        @{ Name = 'get_gadget_part'; Language = 'gadget'; Kind = 'function'; Expected = 'get_gadget_part' }
        @{ Name = 'widget.base.gadget_parts'; Language = 'gadget'; Kind = 'type'; Expected = 'WidgetBaseGadgetParts' }
        @{ Name = 'base.repository'; Language = 'gadget'; Kind = 'folder'; Expected = 'baserepository' }
    ) {
        ConvertFrom-NormalName $Name -Language $Language -NameKind $Kind | Should -BeExactly $Expected
    }

    It 'renders in the case named, one of the language''s cases for the kind' {
        ConvertFrom-NormalName 'gadget_config' -Language widget -NameKind file -Case pascal |
            Should -BeExactly 'GadgetConfig'
        { ConvertFrom-NormalName 'gadget_config' -Language widget -NameKind file -Case snake } |
            Should -Throw "*'snake' is not a widget file case*"
    }

    It 'throws on a name not in the normal form, and on words that start with no approved verb' {
        { ConvertFrom-NormalName 'Get-Gadget' -Language widget } |
            Should -Throw "*'Get-Gadget' is not in the normal form*"
        { ConvertFrom-NormalName 'gadget_part' -Language widget } | Should -Throw '*no approved verb*'
    }
}
