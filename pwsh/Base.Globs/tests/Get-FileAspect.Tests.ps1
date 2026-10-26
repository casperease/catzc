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
