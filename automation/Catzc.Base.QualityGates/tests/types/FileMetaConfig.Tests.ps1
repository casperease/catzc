<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-FILEMETA#2
      - ADR-REPO-FILEMETA#4
---
#>

Describe 'FileMetaConfig' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#2' {
    It 'takes the declared defaults for every omitted key of a kind' -Tag 'ADR-AUTO-DEFAULT#6' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'body-sha' = $null } })
        $kind = $config.kinds[0]
        $kind.id | Should -BeExactly 'body-sha'
        $kind.direction | Should -Be ([Catzc.Base.QualityGates.FileMetaDirection]::Imprint)
        $kind.files | Should -Be @('**/*')
        $kind.keys | Should -Be @('body_sha')
        $kind.processor | Should -BeExactly 'Get-BodyShaFileMetaFact'
        $kind.target | Should -BeNullOrEmpty
        $kind.settings.Count | Should -Be 0
    }

    It 'defaults to every file, root-level and dot-prefixed files included, so a kind for one carrier lists its own globs' -Tag 'ADR-REPO-FILEMETA#2' {
        $default = [Catzc.Base.QualityGates.FileMetaKind]::DefaultFiles
        foreach ($path in 'importer.sh', '.gitignore', 'docs/adr/widget.md', 'automation/Catzc.Base.Widget/types/Gadget.cs') {
            [Catzc.Base.Globs.GlobPattern]::new($default).Matches($path) | Should -BeTrue -Because $path
        }
    }

    It 'maps every key it is given, in file order' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{
                    widget = @{ keys = @('size', 'shape'); files = @('docs/**'); settings = @{ limit = 3 } }
                    gadget = @{ direction = 'gather'; target = 'gadgets'; processor = 'Get-CustomGadget' }
                }
            })
        $config.kinds.id | Should -Be @('widget', 'gadget')
        $config.kinds[0].keys | Should -Be @('size', 'shape')
        $config.kinds[0].files | Should -Be @('docs/**')
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
        @{ Raw = @{ other = 1 }; Message = '*unknown key ''other''*' }
        @{ Raw = @{ kinds = 'x' }; Message = '*kinds must be a map*' }
        @{ Raw = @{ kinds = @{ 'Bad_Id' = @{} } }; Message = '*kind id ''Bad_Id''*' }
        @{ Raw = @{ kinds = @{ widget = 'x' } }; Message = '*kind ''widget'' must be a map*' }
        @{ Raw = @{ kinds = @{ widget = @{ nope = 1 } } }; Message = '*unknown key ''nope'' (allowed: direction, files, keys, processor, target, settings)*' }
        @{ Raw = @{ kinds = @{ widget = @{ direction = 'sideways' } } }; Message = '*direction ''sideways'' is not one of: imprint, gather*' }
        @{ Raw = @{ kinds = @{ widget = @{ direction = 'gather' } } }; Message = '*a gather kind names the config it feeds*' }
        @{ Raw = @{ kinds = @{ widget = @{ target = 'gadgets' } } }; Message = '*only a gather kind has a ''target''*' }
        @{ Raw = @{ kinds = @{ widget = @{ keys = @('Bad Key') } } }; Message = '*keys entry ''Bad Key'' is not valid*' }
        @{ Raw = @{ kinds = @{ widget = @{ keys = @('a', 'a') } } }; Message = '*keys lists an entry twice*' }
        @{ Raw = @{ kinds = @{ widget = @{ files = @() } } }; Message = '*files must not be empty*' }
        @{ Raw = @{ kinds = @{ widget = @{ settings = 'x' } } }; Message = '*settings must be a map*' }
        @{ Raw = @{ kinds = [ordered]@{ widget = @{ keys = @('size') }; gadget = @{ keys = @('size') } } }; Message = '*derived key ''size'' is owned by both ''widget'' and ''gadget''*' }
    ) {
        { [Catzc.Base.QualityGates.FileMetaConfig]::new($Raw) } | Should -Throw $Message
    }
}
