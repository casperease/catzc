<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-languages/tests/types/LanguageNaming.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'LanguagesConfig naming and layout' -Tag 'L0' {
    BeforeAll {
        $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Base.Languages.LanguagesConfig]::new($raw) }
    }

    Context 'LanguageNaming cases' -Tag 'logic' {
        It 'splits a name in its case into namespace segments of lowercase words, and joins them back' -Tag 'ADR-AUTO-IDIOM-CLOSEDCASES' -ForEach @(
            @{ Case = 'pascal'; Name = 'GadgetMetrics'; Words = 'gadget metrics' }
            @{ Case = 'camel'; Name = 'requireGadgetPart'; Words = 'require gadget part' }
            @{ Case = 'pascal-dotted'; Name = 'Widget.Base.GadgetParts'; Words = 'widget|base|gadget parts' }
            @{ Case = 'verb-noun'; Name = 'Get-GadgetPart'; Words = 'get gadget part' }
            @{ Case = 'verb-noun'; Name = 'ConvertTo-GadgetName'; Words = 'convert to gadget name' }
            @{ Case = 'kebab'; Name = 'widget-gadget-part'; Words = 'widget gadget part' }
            @{ Case = 'snake'; Name = 'widget_gadget_part'; Words = 'widget gadget part' }
            @{ Case = 'flat'; Name = 'widgetgadget'; Words = 'widgetgadget' }
        ) {
            $segments = [Catzc.Base.Objects.NameCase]::Split($Case, $Name)
            ($segments.ForEach({ $_ -join ' ' }) -join '|') | Should -BeExactly $Words
            [Catzc.Base.Objects.NameCase]::Join($Case, $segments) | Should -BeExactly $Name
        }

        It 'renders one name in every case, the namespaces joined as one run where a case has none' -Tag 'ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM' -ForEach @(
            @{ Case = 'snake'; Expected = 'widget_base_gadget_parts' }
            @{ Case = 'kebab'; Expected = 'widget-base-gadget-parts' }
            @{ Case = 'flat'; Expected = 'widgetbasegadgetparts' }
            @{ Case = 'pascal'; Expected = 'WidgetBaseGadgetParts' }
            @{ Case = 'camel'; Expected = 'widgetBaseGadgetParts' }
            @{ Case = 'pascal-dotted'; Expected = 'Widget.Base.GadgetParts' }
        ) {
            $segments = [Catzc.Base.Objects.NameCase]::Split('pascal-dotted', 'Widget.Base.GadgetParts')
            [Catzc.Base.Objects.NameCase]::Join($Case, $segments) | Should -BeExactly $Expected
        }

        It 'reads an acronym as one ordinary word, so a capitalised run does not round-trip' -Tag 'ADR-AUTO-IDIOM-ACRONYMISWORD' {
            $segments = [Catzc.Base.Objects.NameCase]::Split('pascal', 'HTTPGadget')
            $segments[0] | Should -Be @('http', 'gadget')
            [Catzc.Base.Objects.NameCase]::Join('pascal', $segments) | Should -BeExactly 'HttpGadget'
        }

        It 'takes the longest leading approved verb, and throws when the words start with none' -Tag 'ADR-AUTO-IDIOM-ROUNDTRIP' {
            [Catzc.Base.Objects.NameCase]::Join('verb-noun', [string[][]] @(, [string[]] @('convert', 'from',
                        'gadget'))) | Should -BeExactly 'ConvertFrom-Gadget'
            { [Catzc.Base.Objects.NameCase]::Join('verb-noun', [string[][]] @(, [string[]] @('gadget', 'part'))) } |
                Should -Throw '*no approved verb*'
            { [Catzc.Base.Objects.NameCase]::Join('verb-noun', [string[][]] @(, [string[]] @('get'))) } |
                Should -Throw '*no approved verb*'
        }

        It 'keeps snake''s leading and trailing underscores outside the case' -Tag 'ADR-AUTO-IDIOM-CLOSEDCASES' {
            [Catzc.Base.Objects.NameCase]::Split('snake', '__init__')[0] | Should -Be @('init')
            [Catzc.Base.Objects.NameCase]::Split('snake', '_private_part')[0] | Should -Be @('private', 'part')
        }

        It 'splits nothing for a name outside the case, and throws on an unknown case or a word that is not lowercase' -Tag 'ADR-AUTO-IDIOM-CLOSEDCASES' {
            [Catzc.Base.Objects.NameCase]::Split('kebab', 'Gadget-Part') | Should -BeNullOrEmpty
            [Catzc.Base.Objects.NameCase]::Split('pascal', 'Widget.Gadget') | Should -BeNullOrEmpty
            { [Catzc.Base.Objects.NameCase]::Split('title', 'Gadget Part') } | Should -Throw "*unknown case 'title'*"
            { [Catzc.Base.Objects.NameCase]::Join('kebab', [string[][]] @(, [string[]] @('Gadget'))) } |
                Should -Throw "*'Gadget' is not a lowercase word*"
        }

        It 'renders any text by its words, a case boundary and any non-letter starting a word' -Tag 'ADR-AUTO-IDIOM-CLOSEDCASES' -ForEach @(
            @{ Text = 'HelveticaMetrics'; Expected = 'helvetica-metrics' }
            @{ Text = 'Get-FooBar'; Expected = 'get-foo-bar' }
            @{ Text = 'Catzc.Internal.Types'; Expected = 'catzc-internal-types' }
            @{ Text = 'already-kebab'; Expected = 'already-kebab' }
            @{ Text = '..'; Expected = '' }
        ) {
            [Catzc.Base.Objects.NameCase]::Render($Text, 'kebab') | Should -BeExactly $Expected
        }

        It 'names a module''s test folder in each language''s first folder case, and throws for a language without one or a name not dotted pascal' -Tag 'ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM' {
            $config = & $script:make ([ordered]@{ languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; naming = [ordered]@{ folder = @('snake', 'kebab') } }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never'; naming = [ordered]@{ folder = 'flat' } }
                        plain  = [ordered]@{ extensions = @('.pln'); no_formatter = 'never'; naming = [ordered]@{ file = 'kebab' } }
                        bare   = [ordered]@{ extensions = @('.bre'); no_formatter = 'never' }
                    }
                })
            $config.TestFolderOf('widget', 'Widget.Base.GadgetParts') | Should -BeExactly 'widget_base_gadget_parts'
            $config.TestFolderOf('gadget', 'Widget.Base.GadgetParts') | Should -BeExactly 'widgetbasegadgetparts'
            { $config.TestFolderOf('plain', 'Widget.Base') } | Should -Throw '*names no folder case*'
            { $config.TestFolderOf('bare', 'Widget.Base') } | Should -Throw "*languages?'bare'?: no naming entry*"
            { $config.TestFolderOf('widget', '.internal') } |
                Should -Throw "*module '.internal' is not a pascal-dotted name*"
        }

        It 'judges a defined function or type by its kind''s cases and its round trip, past exempt files and folders' -Tag 'ADR-AUTO-IDIOM-ROUNDTRIP' {
            $config = & $script:make ([ordered]@{
                    naming    = [ordered]@{ exempt_folders = @('assets'); normal_form = 'snake' }
                    languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; naming = [ordered]@{ function = 'verb-noun'; type = 'pascal'; exempt = @('Fixed.wdg') } }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never'; naming = [ordered]@{ function = 'snake' } }
                    }
                })
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'function', 'Get-Gadget') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'function', 'ConvertTo-GadgetName') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'function', 'get_gadget') |
                Should -BeExactly "a/Get-Gadget.wdg: the function 'get_gadget' is not verb-noun (widget)"
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'function', 'Get-HTTPGadget') |
                Should -BeExactly "a/Get-Gadget.wdg: the function 'Get-HTTPGadget' does not round-trip through the normal form (it renders back as Get-HttpGadget) (widget)"
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'function', 'Gadget-Part') |
                Should -BeLike "*'Gadget-Part' does not round-trip*no approved verb*"
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'type', 'GadgetConfig') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('a/gadgets.gdg', 'function', '__init__') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('a/gadgets.gdg', 'type', 'Anything_Goes') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('Fixed.wdg', 'function', 'get_gadget') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('a/assets/x.wdg', 'function', 'get_gadget') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('notes.md', 'function', 'get_gadget') | Should -BeNullOrEmpty
        }

        It 'carries a name to the normal form and back, snake''s outer underscores outside the case' -Tag 'ADR-AUTO-IDIOM-NORMALFORM' {
            [Catzc.Base.Objects.NameCase]::ToNormal('pascal-dotted', 'Widget.Base.GadgetParts', 'snake') |
                Should -BeExactly 'widget.base.gadget_parts'
            [Catzc.Base.Objects.NameCase]::FromNormal('widget.base.gadget_parts', 'pascal-dotted', 'snake') |
                Should -BeExactly 'Widget.Base.GadgetParts'
            [Catzc.Base.Objects.NameCase]::ToNormal('snake', '__init__', 'snake') | Should -BeExactly '__init__'
            [Catzc.Base.Objects.NameCase]::FromNormal('__init__', 'snake', 'snake') | Should -BeExactly '__init__'
            [Catzc.Base.Objects.NameCase]::FromNormal('_private_part', 'pascal', 'snake') |
                Should -BeExactly 'PrivatePart'
            { [Catzc.Base.Objects.NameCase]::ToNormal('kebab', 'Gadget', 'snake') } |
                Should -Throw "*'Gadget' is not kebab*"
        }

        It 'tells a dotted normal-form name in one call, while a case stays strict about the dot' -Tag 'ADR-AUTO-IDIOM-NORMALFORM' {
            [Catzc.Base.Objects.NameCase]::IsNormal('widget.base.gadget_parts', 'snake') | Should -BeTrue
            [Catzc.Base.Objects.NameCase]::IsNormal('__init__', 'snake') | Should -BeTrue
            [Catzc.Base.Objects.NameCase]::IsNormal('widget.Base', 'snake') | Should -BeFalse
            [Catzc.Base.Objects.NameCase]::IsNormal('widget..gadget', 'snake') | Should -BeFalse
            [Catzc.Base.Objects.NameCase]::IsNormal($null, 'snake') | Should -BeFalse
            [Catzc.Base.Objects.NameCase]::IsInCase('snake', 'widget.gadget') | Should -BeFalse
        }

        It 'judges a file name past its role suffix and the one qualifier before it' -Tag 'ADR-AUTO-IDIOM-LANGUAGEIDIOM' {
            $naming = [Catzc.Base.Languages.LanguageNaming]::new(@(), @('verb-noun', 'pascal'), @())
            $naming.IsFileIdiomatic('Get-Gadget.Tests') | Should -BeTrue
            $naming.IsFileIdiomatic('GadgetConfig.Tests') | Should -BeTrue
            $naming.IsFileIdiomatic('Get-Gadget.L2.Tests') | Should -BeTrue
            $naming.IsFileIdiomatic('Build-Gadget.SampleWidget.Tests') | Should -BeTrue
            $naming.IsFileIdiomatic('Get-Gadget.L2.Extra.Tests') | Should -BeFalse
            $naming.IsFileIdiomatic('Get-Gadget.l2.Tests') | Should -BeFalse
            $naming.IsFileIdiomatic('Get-Gadget.Spec') | Should -BeFalse
        }
    }

    Context 'integrity (shipped languages.yml layout)' -Tag 'integrity' {
        It 'places the five live folders the aspects were written with and each language track''s root scripts, and the shared tests folder is not live' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
            $config = Get-Config -Config languages
            $config.LivePatterns() | Should -Be @('*.ps1', 'private/**', 'types/**', 'configs/**', '*.py', '*.go',
                '*.sh', '*.js', 'assets/**')
            $config.IsLaidOut(@('python')) | Should -BeTrue
            $config.IsLaidOut(@('go')) | Should -BeTrue
            $config.IsLaidOut(@('bash')) | Should -BeTrue
            $config.IsLaidOut(@('javascript')) | Should -BeTrue
            $config.IsLaidOut(@('markdown', 'asset')) | Should -BeFalse
            $config.LayoutFolders() | Should -Be @('private', 'extension', 'types', 'configs', 'accosted', 'assets',
                'tests')
            $config.ShippedFolders() | Should -Be @('types', 'configs', 'assets')
        }
    }
}
