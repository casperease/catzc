Describe 'FileMetaConfig' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-METAKIND' {
    It 'lists the keys the imprint kinds write at the block''s first level, in registry order, and no gather kind''s' -Tag 'ADR-REPO-FILEMETA-FILEISNODE' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{
                    stamp  = @{ keys = @('with_stamp') }
                    cites  = @{ keys = @('cites') }
                    size   = @{ keys = @('size') }
                    widget = @{ direction = 'gather'; target = 'widgets' }
                    links  = $null
                }
            })
        $config.ImprintKeys() | Should -Be @('with_stamp', 'cites', 'size', 'links')
    }

    It 'refuses a header note, since an authored file carries no head to close with one' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        { [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ header = 'widget' }) } |
            Should -Throw '*unknown key ''header'' (allowed: kinds, head_policy)*'
    }

    It 'takes the declared defaults for every omitted key of a kind' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'widget-shade' = $null } })
        $kind = $config.kinds[0]
        $kind.id | Should -BeExactly 'widget-shade'
        $kind.direction | Should -Be ([Catzc.Base.QualityGates.FileMetaDirection]::Imprint)
        $kind.select.Count | Should -Be 1
        $kind.select[0].classes.Count | Should -Be 0
        $kind.select[0].languages.Count | Should -Be 0
        $kind.keys | Should -Be @('widget_shade')
        $kind.processor | Should -BeExactly 'Get-WidgetShadeFileMetaFact'
        $kind.target | Should -BeNullOrEmpty
        $kind.settings.Count | Should -Be 0
    }

    It 'selects every file, root-level and dot-prefixed files included, when a kind names no select' -Tag 'ADR-REPO-FILEMETA-METAKIND' {
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

    It 'defaults a class-list setting to the classes the kind selects' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{ widget = @{ select = @(@{ languages = @('markdown') }, @{ classes = @('widget-type',
                                    'gadget-*')
                            }); settings               = @{ held_classes = @('cog') }
                    }
                }
            })
        $config.kinds[0].ClassSetting('domain_classes') | Should -Be @('widget-type', 'gadget-*')
        $config.kinds[0].ClassSetting('held_classes') | Should -Be @('cog')
    }

    It 'maps every key it is given, in file order' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{
                    widget = @{ keys = @('size',
                            'shape'); select = @(@{ classes = @('widget-*'); languages = @('markdown') }); settings = @{ limit = 3 }
                    }
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
        @{ Id = 'widget-shade'; Direction = 'Imprint'; Expected = 'Get-WidgetShadeFileMetaFact' }
        @{ Id = 'widget'; Direction = 'Imprint'; Expected = 'Get-WidgetFileMetaFact' }
        @{ Id = 'gadget-list'; Direction = 'Gather'; Expected = 'Get-GadgetListMarkdownConfigContribution' }
    ) -Tag 'ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION' {
        [Catzc.Base.QualityGates.FileMetaKind]::ConventionName($Id,
            [Catzc.Base.QualityGates.FileMetaDirection]$Direction) | Should -BeExactly $Expected
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
        @{ Raw = @{ kinds = @{ widget = @{ nope = 1 } } }; Message = '*unknown key ''nope'' (allowed: direction, select, keys, processor, target, settings)*' }
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
        @{ Raw = @{ kinds = [ordered]@{ widget = @{ section = 'edges' } } }; Message = '*kind ''widget'': unknown key ''section''*' }
    ) {
        { [Catzc.Base.QualityGates.FileMetaConfig]::new($Raw) } | Should -Throw $Message
    }
}

Describe 'FileMetaConfig.EngineInputs' -Tag 'L0', 'logic', 'ADR-AUTO-CACHE-CROSSSESSIONFILES' {
    BeforeEach {
        $script:root = Join-Path $TestDrive "modules-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
        $script:gates = Join-Path $script:root 'Catzc.Base.QualityGates'
        $script:languages = Join-Path $script:root 'Catzc.Base.Languages'
        $files = [ordered]@{
            "$script:gates/configs/file-meta.yml"                  = "kinds: {}`n"
            "$script:languages/configs/file-carriers.yml"          = "carriers: {}`n"
            "$script:gates/Format-FileMeta.ps1"                    = "function Format-FileMeta {}`n"
            "$script:gates/Get-FileMetaFact.ps1"                   = "function Get-FileMetaFact {}`n"
            "$script:gates/private/Invoke-FileMetaEngine.ps1"      = "function Invoke-FileMetaEngine {}`n"
            "$script:gates/private/Get-WidgetFileMetaFact.ps1"     = "function Get-WidgetFileMetaFact {}`n"
            "$script:gates/tests/Get-WidgetFileMetaFact.Tests.ps1" = "Describe 'widget' {}`n"
            "$script:gates/types/FileMetaConfig.cs"                = "class FileMetaConfig {}`n"
            "$script:gates/types/FileHeadPolicy.cs"                = "class FileHeadPolicy {}`n"
            "$script:gates/types/HeadPolicy.cs"                    = "enum HeadPolicy {}`n"
            "$script:gates/types/GadgetConfig.cs"                  = "class GadgetConfig {}`n"
        }
        foreach ($file in $files.Keys) {
            [System.IO.Directory]::CreateDirectory((Split-Path $file -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($file, $files[$file])
        }
        $script:inputs = { [Catzc.Base.QualityGates.FileMetaConfig]::EngineInputs($script:root) }
        $script:stamp = { Get-InputStamp -Path (& $script:inputs) -Root $script:root }
    }

    It 'names the registries, the engine, every fact processor and the registry types under the modules root, each once' {
        $relative = @(& $script:inputs | ForEach-Object { [System.IO.Path]::GetRelativePath($script:root,
                    $_).Replace('\', '/') })
        $relative | Should -Be @(
            'Catzc.Base.Languages/configs/file-carriers.yml', 'Catzc.Base.QualityGates/Format-FileMeta.ps1',
            'Catzc.Base.QualityGates/Get-FileMetaFact.ps1',
            'Catzc.Base.QualityGates/configs/file-meta.yml',
            'Catzc.Base.QualityGates/private/Get-WidgetFileMetaFact.ps1',
            'Catzc.Base.QualityGates/private/Invoke-FileMetaEngine.ps1',
            'Catzc.Base.QualityGates/types/FileHeadPolicy.cs',
            'Catzc.Base.QualityGates/types/FileMetaConfig.cs', 'Catzc.Base.QualityGates/types/HeadPolicy.cs'
        ) -Because 'a test file and a type outside FileMeta*.cs and *HeadPolicy.cs feed no head'
    }

    It 'rejects an empty modules root' {
        { [Catzc.Base.QualityGates.FileMetaConfig]::EngineInputs('') } | Should -Throw '*modulesRoot*'
    }

    It 'changes the stamp when file-meta.yml changes, so a changed registry invalidates every file''s memo' {
        $before = & $script:stamp
        [System.IO.File]::WriteAllText("$script:gates/configs/file-meta.yml", "kinds: { gadget: {} }`n")
        & $script:stamp | Should -Not -Be $before
    }

    It 'changes the stamp when the carrier registry, the engine or a fact processor changes, or a processor is added' {
        $before = & $script:stamp
        [System.IO.File]::WriteAllText("$script:languages/configs/file-carriers.yml", "carriers: { widget: {} }`n")
        $carrier = & $script:stamp
        $carrier | Should -Not -Be $before
        [System.IO.File]::WriteAllText("$script:gates/private/Invoke-FileMetaEngine.ps1",
            "function Invoke-FileMetaEngine { 'gadget' }`n")
        $engine = & $script:stamp
        $engine | Should -Not -Be $carrier
        [System.IO.File]::WriteAllText("$script:gates/private/Get-GadgetFileMetaFact.ps1",
            "function Get-GadgetFileMetaFact {}`n")
        & $script:stamp | Should -Not -Be $engine
    }

    It 'keeps the stamp while nothing it reads changes' {
        & $script:stamp | Should -Be (& $script:stamp)
    }
}
