Describe 'ConvertTo-NormalName' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{
                naming    = [ordered]@{ normal_form = 'snake' }
                languages = [ordered]@{
                    widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; naming = [ordered]@{ function = 'verb-noun'; type = 'pascal-dotted'; file = @('verb-noun', 'pascal') } }
                    gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never'; naming = [ordered]@{ function = 'snake'; type = 'pascal' } }
                    plain  = [ordered]@{ extensions = @('.pln'); no_formatter = 'never' }
                }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'languages' } { $script:fixture }
    }

    It 'renders a language''s name in the normal form, its namespace segments joined by a dot' -Tag 'ADR-AUTO-IDIOM-NORMALFORM' -ForEach @(
        @{ Name = 'Get-GadgetPart'; Language = 'widget'; Kind = 'function'; Expected = 'get_gadget_part' }
        @{ Name = 'ConvertTo-GadgetName'; Language = 'widget'; Kind = 'function'; Expected = 'convert_to_gadget_name' }
        @{ Name = 'Widget.Base.GadgetParts'; Language = 'widget'; Kind = 'type'; Expected = 'widget.base.gadget_parts' }
        @{ Name = 'GadgetConfig'; Language = 'widget'; Kind = 'file'; Expected = 'gadget_config' }
        @{ Name = 'get_gadget_part'; Language = 'gadget'; Kind = 'function'; Expected = 'get_gadget_part' }
        @{ Name = 'GadgetPart'; Language = 'gadget'; Kind = 'type'; Expected = 'gadget_part' }
    ) {
        ConvertTo-NormalName $Name -Language $Language -Kind $Kind | Should -BeExactly $Expected
    }

    It 'reads an acronym as one ordinary word' -Tag 'ADR-AUTO-IDIOM-ACRONYMISWORD' {
        ConvertTo-NormalName 'Get-AdoGadget' -Language widget | Should -BeExactly 'get_ado_gadget'
    }

    It 'takes names from the pipeline' {
        @('Get-Gadget', 'Set-Gadget' | ConvertTo-NormalName -Language widget) | Should -Be @('get_gadget', 'set_gadget')
    }

    It 'throws on a name in none of the language''s cases, and on a language with no case for the kind' {
        { ConvertTo-NormalName 'gadget_part' -Language widget } | Should -Throw "*'gadget_part' is not a widget function name*verb-noun*"
        { ConvertTo-NormalName 'Get-Gadget' -Language plain } | Should -Throw "*naming names no function case*"
        { ConvertTo-NormalName 'Get-Gadget' -Language gadget -Kind folder } | Should -Throw "*naming names no folder case*"
    }
}

Describe 'ConvertTo-NormalName and ConvertFrom-NormalName over the tracked functions' -Tag 'L1', 'integrity' {
    It 'round-trips every tracked PowerShell function name through the normal form' -Tag 'ADR-AUTO-IDIOM-ROUNDTRIP' {
        $names = @(foreach ($path in Get-GitTrackedPath -Path (Get-CatzcModulesFolder)) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($path)
                if ($path.EndsWith('.ps1', [System.StringComparison]::Ordinal) -and $stem -cmatch '^[A-Z][A-Za-z0-9]*-[A-Z][A-Za-z0-9]*$') {
                    $stem
                }
            })
        $names.Count | Should -BeGreaterThan 100
        $broken = @(foreach ($name in $names) {
                $back = ConvertFrom-NormalName (ConvertTo-NormalName $name -Language powershell) -Language powershell
                if ($back -cne $name) {
                    "$name -> $back"
                }
            })
        $broken | Should -BeNullOrEmpty
    }
}
