<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1
    folder: tests
    name: get-inspiration-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Inspiration
    moduletype: pwsh-folder
    catzc_bundle: full
    relatives:
      page: docs/references/automation/catzc-tooling-inspiration/tests/Get-Inspiration.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-INSPIRE#1
---
#>

Describe 'Get-Inspiration' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:workspace = [IO.Path]::GetFullPath((Join-Path $TestDrive 'workspace'))
        $script:repository = Join-Path $script:workspace 'catzc'
        foreach ($folder in 'catzc', 'widget', 'gadget') {
            [void] [IO.Directory]::CreateDirectory((Join-Path $script:workspace $folder))
        }

        $script:fixture = [Catzc.Tooling.Inspiration.InspirationConfig]::new([ordered]@{
                inspirations = @(
                    [ordered]@{ id = 'widget'; root = '{workspace}/widget'; description = 'The widget inspiration.'; paths = @('docs', 'specs') }
                    [ordered]@{ id = 'gizmo'; root = '{workspace}/gizmo'; description = 'The gizmo inspiration, absent here.' }
                    [ordered]@{ id = 'gadget'; root = '{workspace}/gadget'; description = 'The gadget inspiration.' }
                )
            })
        $script:config = $script:fixture

        function Get-PickOrder {
            param([object[]] $Pick)
            @(foreach ($inspiration in $Pick) {
                    $inspiration.Id
                }) -join ','
        }
    }

    BeforeEach {
        $script:config = $script:fixture
        Mock Get-Config -ModuleName Catzc.Tooling.Inspiration -ParameterFilter { $Config -eq 'inspiration' } { $script:config }
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Inspiration { $script:repository }
    }

    Context 'no arguments' {
        It 'returns every available inspiration, in file order' {
            $result = @(Get-Inspiration)
            Get-PickOrder $result | Should -BeExactly 'widget,gadget'
            @($result.Available) | Should -Be @($true, $true)
        }

        It 'resolves each root against the workspace and carries the description and paths' {
            $widget = Get-Inspiration -Id 'widget'
            $widget | Should -BeOfType ([Catzc.Tooling.Inspiration.Inspiration])
            $widget.Root | Should -BeExactly ([IO.Path]::GetFullPath((Join-Path $script:workspace 'widget')))
            $widget.Description | Should -BeExactly 'The widget inspiration.'
            $widget.Paths | Should -Be @('docs', 'specs')
        }

        It 'lists the unavailable ones too with -IncludeUnavailable' {
            $result = @(Get-Inspiration -IncludeUnavailable)
            Get-PickOrder $result | Should -BeExactly 'widget,gizmo,gadget'
            @($result.Available) | Should -Be @($true, $false, $true)
        }

        It 'reads the declared default when the file is empty, and reports eac unavailable when it is absent' {
            $script:config = [Catzc.Tooling.Inspiration.InspirationConfig]::new($null)
            @(Get-Inspiration).Count | Should -Be 0
            $eac = Get-Inspiration -Id 'eac'
            $eac.Available | Should -BeFalse
            $eac.Root | Should -BeExactly ([IO.Path]::GetFullPath((Join-Path $script:workspace 'eac')))
        }
    }

    Context '-Id' {
        It 'picks that inspiration by position' {
            (Get-Inspiration 'gadget').Id | Should -BeExactly 'gadget'
        }

        It 'reports an unavailable inspiration without throwing' {
            $gizmo = Get-Inspiration -Id 'gizmo'
            $gizmo.Available | Should -BeFalse
            $gizmo.Paths.Count | Should -Be 0
        }

        It 'throws on an unknown id, naming the known ones' {
            { Get-Inspiration -Id 'sprocket' } | Should -Throw "*Unknown inspiration 'sprocket'*widget, gizmo, gadget*"
        }
    }

    Context '-Count' {
        It 'picks none for 0' {
            @(Get-Inspiration -Count 0 -Seed 1).Count | Should -Be 0
        }

        It 'picks one available inspiration for 1' {
            $pick = @(Get-Inspiration -Count 1 -Seed 1)
            $pick.Count | Should -Be 1
            $pick[0].Id | Should -BeIn @('widget', 'gadget')
        }

        It 'picks every available inspiration, distinct, for N' {
            $pick = @(Get-Inspiration -Count 2 -Seed 1)
            @($pick.Id | Sort-Object) | Should -Be @('gadget', 'widget')
        }

        It 'clamps more than N to the available ones' {
            $pick = @(Get-Inspiration -Count 5 -Seed 1)
            @($pick.Id | Sort-Object) | Should -Be @('gadget', 'widget')
        }

        It 'clamps more than N to every one with -IncludeUnavailable' {
            $pick = @(Get-Inspiration -Count 5 -Seed 1 -IncludeUnavailable)
            @($pick.Id | Sort-Object) | Should -Be @('gadget', 'gizmo', 'widget')
        }

        It 'picks without a seed' {
            @(Get-Inspiration -Count 1).Count | Should -Be 1
        }

        It 'rejects a negative count' {
            { Get-Inspiration -Count -1 } | Should -Throw
        }
    }

    Context '-Seed' {
        It 'gives identical picks on two calls with the same seed' {
            $first = Get-PickOrder @(Get-Inspiration -Count 3 -Seed 42 -IncludeUnavailable)
            $second = Get-PickOrder @(Get-Inspiration -Count 3 -Seed 42 -IncludeUnavailable)
            $second | Should -BeExactly $first
        }

        It 'gives different picks for different seeds' {
            $orders = @(foreach ($seed in 1..10) {
                    Get-PickOrder @(Get-Inspiration -Count 3 -Seed $seed -IncludeUnavailable)
                })
            @($orders | Sort-Object -Unique).Count | Should -BeGreaterThan 1
        }
    }
}
