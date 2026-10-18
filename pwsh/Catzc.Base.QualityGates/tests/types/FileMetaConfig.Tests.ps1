Describe 'FileMetaConfig' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#2' {
    It 'lists the keys the imprint kinds write under each part, in registry order' -Tag 'ADR-REPO-FILEMETA#13' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{
                    stamp  = @{ keys = @('with_stamp') }
                    cites  = @{ section = 'edges'; keys = @('cites') }
                    size   = @{ keys = @('size') }
                    widget = @{ direction = 'gather'; target = 'widgets' }
                    links  = @{ section = 'edges' }
                }
            })
        $config.KeysOf('immutable') | Should -Be @('with_stamp', 'size')
        $config.KeysOf('edges') | Should -Be @('cites', 'links')
    }

    It 'takes the declared defaults for every omitted key of a kind' -Tag 'ADR-AUTO-DEFAULT#6' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'body-sha' = $null } })
        $kind = $config.kinds[0]
        $kind.id | Should -BeExactly 'body-sha'
        $kind.direction | Should -Be ([Catzc.Base.QualityGates.FileMetaDirection]::Imprint)
        $kind.select.Count | Should -Be 1
        $kind.select[0].classes.Count | Should -Be 0
        $kind.select[0].languages.Count | Should -Be 0
        $kind.keys | Should -Be @('body_sha')
        $kind.section | Should -BeExactly 'immutable'
        $kind.processor | Should -BeExactly 'Get-BodyShaFileMetaFact'
        $kind.target | Should -BeNullOrEmpty
        $kind.settings.Count | Should -Be 0
    }

    It 'selects every file, root-level and dot-prefixed files included, when a kind names no select' -Tag 'ADR-REPO-FILEMETA#2' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ widget = @{} } })
        foreach ($fileClass in 'other', 'script', 'type', 'function/gate') {
            $config.Selects($config.kinds[0], $fileClass, $null) | Should -BeTrue -Because $fileClass
            $config.SelectsAny($fileClass, 'markdown') | Should -BeTrue -Because $fileClass
        }
    }

    It 'no longer holds the file classes, which the file-kinds registry owns' {
        { [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ classes = @(@{ class = 'widget'; files = @('a/**') }) }) } |
            Should -Throw '*unknown key ''classes'' (allowed: kinds, head_policy)*'
    }

    It 'matches a class pattern with one star, and a class name exactly' -ForEach @(
        @{ Pattern = 'widget-*'; Class = 'widget-type'; Expected = $true }
        @{ Pattern = '*-function'; Class = 'gate-function'; Expected = $true }
        @{ Pattern = '*-function'; Class = 'function'; Expected = $false }
        @{ Pattern = 'widget-type'; Class = 'widget-types'; Expected = $false }
        @{ Pattern = 'w*e'; Class = 'we'; Expected = $true }
    ) {
        [Catzc.Base.QualityGates.FileSelector]::ClassMatches($Pattern, $Class) | Should -Be $Expected
    }

    It 'lets a kind pattern select the kind whatever its subkind, and a kind/subkind pattern only that subkind' -ForEach @(
        @{ Pattern = 'gadget'; Class = 'gadget/cog'; Expected = $true }
        @{ Pattern = 'gadget'; Class = 'gadget'; Expected = $true }
        @{ Pattern = 'gadget/cog'; Class = 'gadget/cog'; Expected = $true }
        @{ Pattern = 'gadget/cog'; Class = 'gadget'; Expected = $false }
        @{ Pattern = 'gadget/cog'; Class = 'gadget/sprocket'; Expected = $false }
        @{ Pattern = 'gadget'; Class = 'gadgets/cog'; Expected = $false }
        @{ Pattern = 'gad*'; Class = 'gadget/cog'; Expected = $true }
    ) {
        [Catzc.Base.QualityGates.FileSelector]::ClassMatches($Pattern, $Class) | Should -Be $Expected
    }

    It 'defaults a class-list setting to the classes the kind selects' -Tag 'ADR-AUTO-DEFAULT#6' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{ widget = @{ select = @(@{ languages = @('markdown') }, @{ classes = @('widget-type', 'gadget-*') }); settings = @{ held_classes = @('cog') } } }
            })
        $config.kinds[0].ClassSetting('domain_classes') | Should -Be @('widget-type', 'gadget-*')
        $config.kinds[0].ClassSetting('held_classes') | Should -Be @('cog')
    }

    It 'maps every key it is given, in file order' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{
                    widget = @{ keys = @('size', 'shape'); select = @(@{ classes = @('widget-*'); languages = @('markdown') }); settings = @{ limit = 3 } }
                    gadget = @{ direction = 'gather'; target = 'gadgets'; processor = 'Get-CustomGadget' }
                }
            })
        $config.kinds.id | Should -Be @('widget', 'gadget')
        $config.kinds[0].keys | Should -Be @('size', 'shape')
        $config.kinds[0].select[0].classes | Should -Be @('widget-*')
        $config.kinds[0].select[0].languages | Should -Be @('markdown')
        $config.kinds[0].settings['limit'] | Should -Be 3
        $config.kinds[1].direction | Should -Be ([Catzc.Base.QualityGates.FileMetaDirection]::Gather)
        $config.kinds[1].processor | Should -BeExactly 'Get-CustomGadget'
    }

    It 'names the subscribed function from the kind''s id' -ForEach @(
        @{ Id = 'body-sha'; Direction = 'Imprint'; Expected = 'Get-BodyShaFileMetaFact' }
        @{ Id = 'widget'; Direction = 'Imprint'; Expected = 'Get-WidgetFileMetaFact' }
        @{ Id = 'gadget-list'; Direction = 'Gather'; Expected = 'Get-GadgetListMarkdownConfigContribution' }
    ) -Tag 'ADR-REPO-FILEMETA#4' {
        [Catzc.Base.QualityGates.FileMetaKind]::ConventionName($Id, [Catzc.Base.QualityGates.FileMetaDirection]$Direction) | Should -BeExactly $Expected
    }

    It 'lists the imprint kinds in order and the gather kinds of one config' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{
                    widget   = @{}
                    gadget   = @{ direction = 'gather'; target = 'gadgets'; keys = @('gadgets') }
                    sprocket = @{ direction = 'gather'; target = 'other'; keys = @('other') }
                    doodad   = @{}
                }
            })
        $config.Imprint().id | Should -Be @('widget', 'doodad')
        $config.GatherFor('gadgets').id | Should -Be @('gadget')
        @($config.GatherFor('nothing')).Count | Should -Be 0
    }

    It 'rejects a malformed registry, naming the kind and the allowed set' -ForEach @(
        @{ Raw = @{ other = 1 }; Message = '*unknown key ''other'' (allowed: kinds, head_policy)*' }
        @{ Raw = @{ kinds = 'x' }; Message = '*kinds must be a map*' }
        @{ Raw = @{ kinds = @{ 'Bad_Id' = @{} } }; Message = '*kind id ''Bad_Id''*' }
        @{ Raw = @{ kinds = @{ widget = 'x' } }; Message = '*kind ''widget'' must be a map*' }
        @{ Raw = @{ kinds = @{ widget = @{ nope = 1 } } }; Message = '*unknown key ''nope'' (allowed: direction, section, select, keys, processor, target, settings)*' }
        @{ Raw = @{ kinds = @{ widget = @{ files = @('docs/**') } } }; Message = '*unknown key ''files''*' }
        @{ Raw = @{ kinds = @{ widget = @{ direction = 'sideways' } } }; Message = '*direction ''sideways'' is not one of: imprint, gather*' }
        @{ Raw = @{ kinds = @{ widget = @{ direction = 'gather' } } }; Message = '*a gather kind names the config it feeds*' }
        @{ Raw = @{ kinds = @{ widget = @{ target = 'gadgets' } } }; Message = '*only a gather kind has a ''target''*' }
        @{ Raw = @{ kinds = @{ widget = @{ keys = @('Bad Key') } } }; Message = '*keys entry ''Bad Key'' is not valid*' }
        @{ Raw = @{ kinds = @{ widget = @{ keys = @('a', 'a') } } }; Message = '*keys lists an entry twice*' }
        @{ Raw = @{ kinds = @{ widget = @{ select = @() } } }; Message = '*select must not be empty*' }
        @{ Raw = @{ kinds = @{ widget = @{ select = @(@{}) } } }; Message = '*names classes, languages, or both*' }
        @{ Raw = @{ kinds = @{ widget = @{ select = @(@{ files = @('a') }) } } }; Message = '*unknown select key ''files''*' }
        @{ Raw = @{ kinds = @{ widget = @{ select = @(@{ classes = @('*-*') }) } } }; Message = '*more than one ''*''*' }
        @{ Raw = @{ kinds = @{ widget = @{ settings = 'x' } } }; Message = '*settings must be a map*' }
        @{ Raw = @{ kinds = [ordered]@{ widget = @{ keys = @('size') }; gadget = @{ keys = @('size') } } }; Message = '*key ''size'' is owned by both ''widget'' and ''gadget''*' }
        @{ Raw = @{ kinds = [ordered]@{ widget = @{ section = 'derived' } } }; Message = '*kind ''widget'': section ''derived'' is not one of: immutable, edges*' }
        @{ Raw = @{ kinds = [ordered]@{ widget = @{ direction = 'gather'; target = 'widgets'; section = 'edges' } } }; Message = '*kind ''widget'': only an imprint kind has a ''section''*' }
    ) {
        { [Catzc.Base.QualityGates.FileMetaConfig]::new($Raw) } | Should -Throw $Message
    }
}
