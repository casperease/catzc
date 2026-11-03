Describe 'Get-FileAspect' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-AspectGlobSet -ModuleName Catzc.Base.Globs {
            [ordered]@{
                live  = @([Catzc.Base.Globs.GlobSet]::new('widget-live', 'd', 'module', @('widget/*.ps1'), @(), @(),
                        @(), -1, $null))
                tests = @([Catzc.Base.Globs.GlobSet]::new('widget-tests', 'd', 'module', @('widget/tests/**'), @(), @(),
                        @(), -1, $null))
            }
        }
    }

    It 'maps each path, in input order, to its aspect, and to an empty string when no aspect claims it' {
        $aspects = Get-FileAspect -Path 'widget/tests/a.Tests.ps1', 'gadget/b.md', 'widget/Get-Widget.ps1'
        @($aspects.Keys) | Should -Be @('widget/tests/a.Tests.ps1', 'gadget/b.md', 'widget/Get-Widget.ps1')
        $aspects['widget/tests/a.Tests.ps1'] | Should -Be 'tests'
        $aspects['gadget/b.md'] | Should -Be ''
        $aspects['widget/Get-Widget.ps1'] | Should -Be 'live'
    }

    It 'builds the sets once per call, however many paths it is given' {
        $null = Get-FileAspect -Path 'widget/a.ps1', 'widget/b.ps1', 'widget/c.ps1'
        Should -Invoke Get-AspectGlobSet -ModuleName Catzc.Base.Globs -Times 1 -Exactly
    }

    It 'returns an empty map for no paths' {
        (Get-FileAspect -Path @()).Count | Should -Be 0
    }
}

Describe 'Get-FileAspect in build mode' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.Globs { 'build' }
        Mock Get-ModuleGlobSet -ModuleName Catzc.Base.Globs { throw 'the module glob sets are source-only' }
        Mock Get-Track -ModuleName Catzc.Base.Globs {
            param([string] $Path)
            if ($Path.StartsWith('widgets/', [System.StringComparison]::Ordinal)) {
                [pscustomobject]@{ name = 'widgets'; places = @('widgets') }
            }
        }
        Mock Get-Aspect -ModuleName Catzc.Base.Globs {
            [pscustomobject]@{ Name = 'live'; Patterns = @('*.ps1') }
            [pscustomobject]@{ Name = 'tests'; Patterns = @('**') }
        }
    }

    It 'finds the aspect from the aspect definitions of the track, never from the module glob sets' {
        $aspects = Get-FileAspect -Path 'widgets/Widget/Get-Thing.ps1', 'widgets/Widget/tests/Get-Thing.Tests.ps1', 'docs/readme.md'
        $aspects['widgets/Widget/Get-Thing.ps1'] | Should -Be 'live'
        $aspects['widgets/Widget/tests/Get-Thing.Tests.ps1'] | Should -Be 'tests'
        $aspects['docs/readme.md'] | Should -Be ''
        Should -Invoke Get-ModuleGlobSet -ModuleName Catzc.Base.Globs -Times 0 -Exactly
    }

    It 'gives a file that sits in no module folder of its track no aspect' {
        (Get-FileAspect -Path 'widgets/readme.md')['widgets/readme.md'] | Should -Be ''
    }
}
