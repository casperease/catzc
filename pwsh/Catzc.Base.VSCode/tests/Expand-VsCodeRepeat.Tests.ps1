Describe 'Expand-VsCodeRepeat' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:expand = {
            param([System.Collections.IDictionary] $Contributes)
            InModuleScope Catzc.Base.VSCode -Parameters @{ Contributes = $Contributes } {
                param($Contributes)
                Mock Get-Config -ParameterFilter { $Config -eq 'widgets' } {
                    [pscustomobject]@{ widgets = @([pscustomobject]@{ name = 'red'; title = 'the red widget' }, [pscustomobject]@{ name = 'blue'; title = 'the blue widget' }) }
                }
                Mock Get-Config -ParameterFilter { $Config -eq 'gadgets' } {
                    [pscustomobject]@{ gadgets = @([pscustomobject]@{ name = 'cog'; tag = 'cg' }, [pscustomobject]@{ name = 'sprocket'; tag = $null }, [pscustomobject]@{ name = 'gear'; tag = 'gr' }) }
                }
                Expand-VsCodeRepeat -Contributes $Contributes
            }
        }
        $script:contributes = [ordered]@{
            repeat   = [ordered]@{ widget = [ordered]@{ config = 'widgets'; list = 'widgets'; key = 'name'; title = 'title'; first = @([ordered]@{ name = 'gizmo'; title = 'the gizmo' }); plus = @([ordered]@{ name = 'gadget'; title = 'the gadget' }) } }
            commands = @(
                [ordered]@{ repeat = 'widget'; command = 'widget.{widget}.toggle'; title = '{widget}, {widget.title}'; icon = [ordered]@{ dark = 'media/{widget}.svg' } }
                [ordered]@{ command = 'gadget.run'; title = 'Gadget' }
            )
            menus    = [ordered]@{ 'view/title' = @([ordered]@{ repeat = 'widget'; command = 'widget.{widget}.toggle'; group = 'navigation@9{widget.position}' }) }
        }
    }

    It 'writes a repeating entry once per leading item, item of its config list and trailing item, in order, and leaves the rest alone' {
        $commands = @((& $script:expand $script:contributes)['commands'])
        $commands.ForEach({ $_['command'] }) | Should -Be @('widget.gizmo.toggle', 'widget.red.toggle', 'widget.blue.toggle', 'widget.gadget.toggle', 'gadget.run')
        $commands[2]['title'] | Should -Be 'blue, the blue widget'
        $commands[3]['icon']['dark'] | Should -Be 'media/gadget.svg'
        $commands[0].Contains('repeat') | Should -BeFalse
    }

    It 'fills menu entries the same way, with each item''s position, and drops the repeat block' {
        $expanded = & $script:expand $script:contributes
        @($expanded['menus']['view/title']).ForEach({ $_['group'] }) | Should -Be @('navigation@91', 'navigation@92', 'navigation@93', 'navigation@94')
        $expanded.Contains('repeat') | Should -BeFalse
    }

    It 'keeps only the items that carry the where field, numbering the kept ones' {
        $contributes = [ordered]@{
            repeat   = [ordered]@{ gadget = [ordered]@{ config = 'gadgets'; list = 'gadgets'; key = 'name'; title = 'tag'; where = 'tag' } }
            commands = @([ordered]@{ repeat = 'gadget'; command = 'gadget.{gadget}'; title = '{gadget.title} {gadget.position}' })
        }
        $commands = @((& $script:expand $contributes)['commands'])
        $commands.ForEach({ $_['command'] }) | Should -Be @('gadget.cog', 'gadget.gear')
        $commands.ForEach({ $_['title'] }) | Should -Be @('cg 1', 'gr 2')
    }

    It 'refuses an entry that repeats an undeclared source' {
        $broken = [ordered]@{ repeat = [ordered]@{}; commands = @([ordered]@{ repeat = 'gizmo'; command = 'gizmo.{gizmo}' }) }
        { & $script:expand $broken } | Should -Throw '*does not declare*'
    }
}
