<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/types/FileKindsConfig.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Globs
    relatives:
      source: automation/Catzc.Base.Globs/types/FileKindsConfig.cs
    adrs:
      - ADR-REPO-FILEMETA#2
---
#>

Describe 'FileKindsConfig' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#2' {
    BeforeAll {
        function script:New-Config {
            param($Kinds)
            [Catzc.Base.Globs.FileKindsConfig]::new([ordered]@{ kinds = $Kinds })
        }

        $script:config = New-Config ([ordered]@{
                widget   = [ordered]@{ definition = 'A widget file.'; files = @('widgets/**/*.wdg') }
                gadget   = [ordered]@{
                    definition = 'A gadget file.'
                    subkinds   = [ordered]@{
                        cog    = [ordered]@{ definition = 'A cog of a gadget.'; files = @('gadgets/cog-*.gdg') }
                        sprock = [ordered]@{ definition = 'A sprocket of a gadget.'; files = @('gadgets/*sprock*.gdg') }
                    }
                    files      = @('gadgets/**/*.gdg')
                }
                sprocket = [ordered]@{ definition = 'A sprocket.'; files = @('**/*.wdg') }
            })
    }

    Context 'Resolve' {
        It 'names the first kind whose globs match, in the order declared' {
            $match = $script:config.Resolve('widgets/part.wdg')
            $match.kind | Should -BeExactly 'widget'
            $match.subkind | Should -BeNullOrEmpty
            $match.definition | Should -BeExactly 'A widget file.'
            $match.Class | Should -BeExactly 'widget'
        }

        It 'lets a later kind take what no earlier kind matches' {
            $script:config.Resolve('elsewhere/part.wdg').kind | Should -BeExactly 'sprocket'
        }

        It 'names a subkind before the kind''s own globs, and in the order the subkinds are written' {
            $cog = $script:config.Resolve('gadgets/cog-sprock.gdg')
            $cog.kind | Should -BeExactly 'gadget'
            $cog.subkind | Should -BeExactly 'cog'
            $cog.Class | Should -BeExactly 'gadget/cog'
            $script:config.Resolve('gadgets/deep/sprock-one.gdg').subkind | Should -BeNullOrEmpty
            $script:config.Resolve('gadgets/sprock-one.gdg').subkind | Should -BeExactly 'sprock'
        }

        It 'names the kind alone for a file only its own globs match' {
            $match = $script:config.Resolve('gadgets/deep/plain.gdg')
            $match.kind | Should -BeExactly 'gadget'
            $match.subkind | Should -BeNullOrEmpty
            $match.Class | Should -BeExactly 'gadget'
        }

        It 'names a file no entry selects other, with no definition' {
            $match = $script:config.Resolve('elsewhere/notes.txt')
            $match.kind | Should -BeExactly 'other'
            $match.subkind | Should -BeNullOrEmpty
            $match.definition | Should -BeNullOrEmpty
        }

        It 'names every file other when no kind is declared' {
            (New-Config $null).Resolve('widgets/part.wdg').kind | Should -BeExactly 'other'
        }
    }

    Context 'validation' {
        It 'accepts a kind that only has subkinds' {
            $config = New-Config ([ordered]@{
                    gadget = [ordered]@{ definition = 'A gadget.'; subkinds = [ordered]@{ cog = [ordered]@{ definition = 'A cog.'; files = @('a/**') } } }
                })
            $config.Resolve('a/b.txt').Class | Should -BeExactly 'gadget/cog'
            $config.Resolve('z/b.txt').kind | Should -BeExactly 'other'
        }

        It 'rejects <Name>' -ForEach @(
            @{ Name = 'a kind with no definition'; Kinds = @{ widget = @{ files = @('a/**') } }; Message = '*needs a definition*' }
            @{ Name = 'a kind with a blank definition'; Kinds = @{ widget = @{ definition = '  '; files = @('a/**') } }; Message = '*needs a definition*' }
            @{ Name = 'a kind with neither globs nor subkinds'; Kinds = @{ widget = @{ definition = 'A widget.' } }; Message = '*needs globs in ''files'', or subkinds*' }
            @{ Name = 'a subkind with no globs'; Kinds = @{ widget = @{ definition = 'A widget.'; subkinds = @{ cog = @{ definition = 'A cog.' } } } }; Message = '*subkind ''cog'' needs at least one glob*' }
            @{ Name = 'a subkind with no definition'; Kinds = @{ widget = @{ definition = 'A widget.'; subkinds = @{ cog = @{ files = @('a/**') } } } }; Message = '*subkind ''cog'' needs a definition*' }
            @{ Name = 'the kind other'; Kinds = @{ other = @{ definition = 'Other.'; files = @('a/**') } }; Message = '*not ''other''*' }
            @{ Name = 'an upper-case kind'; Kinds = @{ Widget = @{ definition = 'A widget.'; files = @('a/**') } }; Message = '*lowercase words joined by*' }
            @{ Name = 'an unknown key on a kind'; Kinds = @{ widget = @{ definition = 'A widget.'; files = @('a/**'); nope = 1 } }; Message = '*unknown key ''nope''*' }
            @{ Name = 'an unknown key on a subkind'; Kinds = @{ widget = @{ definition = 'A widget.'; subkinds = @{ cog = @{ definition = 'A cog.'; files = @('a/**'); nope = 1 } } } }; Message = '*unknown key ''nope''*' }
            @{ Name = 'an empty glob'; Kinds = @{ widget = @{ definition = 'A widget.'; files = @('a/**', ' ') } }; Message = '*a glob in ''files'' is empty*' }
            @{ Name = 'a kind that is not a map'; Kinds = @{ widget = 'x' }; Message = '*must be a map*' }
        ) {
            { New-Config $Kinds } | Should -Throw $Message
        }

        It 'rejects an unknown top-level key and a kinds value that is no map' {
            { [Catzc.Base.Globs.FileKindsConfig]::new(@{ widgets = @{} }) } | Should -Throw '*unknown key ''widgets''*'
            { [Catzc.Base.Globs.FileKindsConfig]::new(@{ kinds = 'x' }) } | Should -Throw '*kinds must be a map*'
            { [Catzc.Base.Globs.FileKindsConfig]::new($null) } | Should -Throw
        }
    }
}
