Describe 'ModuleTypesConfig' -Tag 'L0', 'logic', 'DDR-TRACK-ONETECHSTACK' {
    BeforeAll {
        function script:New-Config {
            param($Types)
            [Catzc.Base.Variants.ModuleTypesConfig]::new([ordered]@{ module_types = $Types })
        }

        $script:config = New-Config ([ordered]@{
                'widget-folder' = [ordered]@{
                    definition = 'A widget that is a folder.'
                    places     = @(
                        @{ root = 'widgetry'; name = 'folder' }
                        @{ root = 'widgetry/.core'; name = 'folder'; prefix = 'Widget.Core.'; internal = $true }
                    )
                }
                'widget-file'   = [ordered]@{ definition = 'A widget that is one file.'; places = @(@{ root = 'widgetry/.core'; name = 'file'; extension = 'wdg' }) }
                'widget-tool'   = [ordered]@{ definition = 'A tool dot-folder.'; places = @(@{ root = '.gizmo/deep'; name = 'root' }, @{ root = '.gizmo'; name = 'root' }) }
                'widget-shelf'  = [ordered]@{
                    definition = 'A shelf whose folders are modules, except the ones the track keeps for itself.'
                    places     = @(
                        @{ root = 'shelf'; name = 'folder'; except = @('tests', 'assets') }
                        @{ root = 'shelf'; name = 'root' }
                    )
                }
            })
    }

    Context 'Resolve' {
        It 'names the first folder under a root, whatever the file''s depth, with its type' {
            $module = $script:config.Resolve('widgetry/Gadget/private/Cog.ps1')
            $module.name | Should -BeExactly 'Gadget'
            $module.type | Should -BeExactly 'widget-folder'
        }

        It 'gives the path under the module as the tail, for each way a place names its module' -ForEach @(
            @{ Path = 'widgetry/Gadget/private/Cog.ps1'; Tail = 'private/Cog.ps1' }
            @{ Path = 'widgetry/Gadget/Cog.ps1'; Tail = 'Cog.ps1' }
            @{ Path = 'widgetry/.core/Widget.Core.Kit.wdg'; Tail = 'Widget.Core.Kit.wdg' }
            @{ Path = '.gizmo/deep/x/y.json'; Tail = 'x/y.json' }
            @{ Path = '.gizmo/other.json'; Tail = 'other.json' }
            @{ Path = '.gizmo'; Tail = '' }
        ) {
            $script:config.Resolve($Path).tail | Should -BeExactly $Tail
        }

        It 'never takes a dot-prefixed folder as a module' {
            $script:config.Resolve('widgetry/.hidden/Cog.ps1') | Should -BeNullOrEmpty
        }

        It 'puts the prefix before the PascalCase of the folder' -ForEach @(
            @{ Path = 'widgetry/.core/tests/Cog.ps1'; Expected = 'Widget.Core.Tests' }
            @{ Path = 'widgetry/.core/test-kit/Cog.ps1'; Expected = 'Widget.Core.TestKit' }
        ) {
            $script:config.Resolve($Path).name | Should -BeExactly $Expected
        }

        It 'names a file directly under a root by the file without its extension' {
            $module = $script:config.Resolve('widgetry/.core/Widget.Core.Kit.wdg')
            $module.name | Should -BeExactly 'Widget.Core.Kit'
            $module.type | Should -BeExactly 'widget-file'
        }

        It 'places a file that is no module file, or sits in a folder of a file place, in no file module' -ForEach @(
            @{ Path = 'widgetry/.core/Kit.txt' }
            @{ Path = 'widgetry/.core/Kit.wdg.bak' }
            @{ Path = 'widgetry/.core/.wdg' }
        ) {
            $module = $script:config.Resolve($Path)
            ($null -eq $module -or $module.type -ne 'widget-file') | Should -BeTrue
        }

        It 'names the root folder itself, by its last segment, for a root place' {
            $script:config.Resolve('.gizmo/deep/x/y.json').name | Should -BeExactly 'deep'
            $script:config.Resolve('.gizmo/other.json').name | Should -BeExactly '.gizmo'
            $script:config.Resolve('.gizmo').name | Should -BeExactly '.gizmo'
        }

        It 'takes the first place that names a path, in the order written' {
            $script:config.Resolve('.gizmo/deep/z.json').name | Should -BeExactly 'deep'
        }

        It 'does not take a root that only shares a prefix' {
            $script:config.Resolve('widgetry-extra/Gadget/Cog.ps1') | Should -BeNullOrEmpty
            $script:config.Resolve('.gizmos/a.json') | Should -BeNullOrEmpty
        }

        It 'places a file directly in a folder root, and an empty path, in no module' {
            $script:config.Resolve('widgetry/Cog.ps1') | Should -BeNullOrEmpty
            $script:config.Resolve('') | Should -BeNullOrEmpty
            $script:config.Resolve($null) | Should -BeNullOrEmpty
        }

        It 'reads a backslash path' {
            $script:config.Resolve('widgetry\Gadget\Cog.ps1').name | Should -BeExactly 'Gadget'
        }

        It 'leaves a folder the place excepts to the root place behind it, and names every other folder' -ForEach @(
            @{ Path = 'shelf/tests/gadget-kit/test_gadget.py'; Name = 'shelf'; Tail = 'tests/gadget-kit/test_gadget.py' }
            @{ Path = 'shelf/assets/cog.png'; Name = 'shelf'; Tail = 'assets/cog.png' }
            @{ Path = 'shelf/Gadget.Kit/gadget.py'; Name = 'Gadget.Kit'; Tail = 'gadget.py' }
            @{ Path = 'shelf/project.toml'; Name = 'shelf'; Tail = 'project.toml' }
        ) {
            $module = $script:config.Resolve($Path)
            $module.name | Should -BeExactly $Name
            $module.type | Should -BeExactly 'widget-shelf'
            $module.tail | Should -BeExactly $Tail
        }
    }

    Context 'except' {
        It 'reads the excepted folders of a folder place and leaves every other place with none' {
            $places = $script:config.types[3].places
            @($places[0].except) | Should -Be @('tests', 'assets')
            @($places[1].except) | Should -HaveCount 0
            @($script:config.types[0].places[0].except) | Should -HaveCount 0
        }
    }

    Context 'internal places' {
        It 'reads a place declared internal, and leaves every other place public, the default the type declares' {
            $places = $script:config.types[0].places
            $places[1].internal | Should -BeTrue
            $places[0].internal | Should -BeFalse
            $script:config.types[1].places[0].internal | Should -Be ([Catzc.Base.Variants.ModulePlace]::DefaultInternal)
            [Catzc.Base.Variants.ModulePlace]::DefaultInternal | Should -BeFalse
        }
    }

    Context 'validation' {
        It 'rejects <Name>' -ForEach @(
            @{ Name = 'a type with no definition'; Types = @{ 'widget-x' = @{ places = @(@{ root = 'a'; name = 'root' }) } }; Message = '*needs a definition*' }
            @{ Name = 'a type with no place'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @() } }; Message = '*needs at least one place*' }
            @{ Name = 'an upper-case type'; Types = @{ 'Widget' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'root' }) } }; Message = '*lowercase words joined by*' }
            @{ Name = 'an unknown key on a type'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'root' }); nope = 1 } }; Message = '*unknown key ''nope''*' }
            @{ Name = 'an unknown key on a place'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'root'; nope = 1 }) } }; Message = '*unknown place key ''nope''*' }
            @{ Name = 'a place with no root'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ name = 'root' }) } }; Message = '*a place''s root is a repository-relative folder*' }
            @{ Name = 'a root with a trailing slash'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a/'; name = 'root' }) } }; Message = '*a place''s root is a repository-relative folder*' }
            @{ Name = 'a root with a backslash'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a\b'; name = 'root' }) } }; Message = '*a place''s root is a repository-relative folder*' }
            @{ Name = 'a place naming no way to name'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'sideways' }) } }; Message = '*folder, file or root*' }
            @{ Name = 'a file place with no extension'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'file' }) } }; Message = '*names the extension, without its dot*' }
            @{ Name = 'a file place with a dotted extension'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'file'; extension = '.wdg' }) } }; Message = '*without its dot*' }
            @{ Name = 'an extension on a folder place'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'folder'; extension = 'wdg' }) } }; Message = '*only a file place has an extension*' }
            @{ Name = 'a prefix on a root place'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'root'; prefix = 'X.' }) } }; Message = '*only a folder place has a prefix*' }
            @{ Name = 'an internal that is no boolean'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'root'; internal = 'yes' }) } }; Message = '*internal is true or false*' }
            @{ Name = 'an except on a root place'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'root'; except = @('tests') }) } }; Message = '*only a folder place has an except*' }
            @{ Name = 'an except on a file place'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'file'; extension = 'wdg'; except = @('tests') }) } }; Message = '*only a folder place has an except*' }
            @{ Name = 'an except that is no list'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'folder'; except = 'tests' }) } }; Message = '*except is a list of folder names*' }
            @{ Name = 'an except entry with a path'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'folder'; except = @('tests/deep') }) } }; Message = '*one folder name directly under the root*' }
            @{ Name = 'an except entry named twice'; Types = @{ 'widget-x' = @{ definition = 'A widget.'; places = @(@{ root = 'a'; name = 'folder'; except = @('tests', 'tests') }) } }; Message = '*except names ''tests'' twice*' }
        ) {
            { New-Config $Types } | Should -Throw $Message
        }

        It 'rejects an unknown top-level key and a module_types value that is no map' {
            { [Catzc.Base.Variants.ModuleTypesConfig]::new(@{ types = @{} }) } | Should -Throw '*unknown key ''types''*'
            { [Catzc.Base.Variants.ModuleTypesConfig]::new(@{ module_types = 'x' }) } | Should -Throw '*module_types must be a map*'
            { [Catzc.Base.Variants.ModuleTypesConfig]::new($null) } | Should -Throw
        }

        It 'declares no module for an empty registry' {
            (New-Config $null).Resolve('widgetry/Gadget/Cog.ps1') | Should -BeNullOrEmpty
        }
    }
}
