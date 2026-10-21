<#
---
catzc:
  immutable:
    with_body_sha: fa7d76ffe1f9
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-ScopeLookup.ps1
---
#>

Describe 'Get-ScopeLookup' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "# Widget`n")
        $script:lookup = {
            param([string[]] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Path = $Path } {
                param($Root, $Path)
                Push-Location $Root
                try {
                    Get-ScopeLookup -RepositoryRoot $Root -Path $Path -Command Get-WidgetScope
                }
                finally {
                    Pop-Location
                }
            }
        }
    }

    BeforeEach {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -contains 'docs/gone-gadget.md' } { 'docs/gone-gadget.md' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { }
    }

    It 'gives the whole repository for no path' {
        & $script:lookup | Should -Be @('.')
    }

    It 'gives a path on disk relative to the root' {
        & $script:lookup 'docs/widget.md' | Should -Be @('docs/widget.md')
    }

    It 'keeps a tracked path the working tree has lost' {
        & $script:lookup 'docs/gone-gadget.md' | Should -Be @('docs/gone-gadget.md')
    }

    It 'refuses a path neither on disk nor tracked' {
        { & $script:lookup 'docs/no-such-gizmo.md' } | Should -Throw "*'docs/no-such-gizmo.md' does not exist and is not tracked*"
    }

    It 'refuses a path outside the repository' {
        { & $script:lookup '../outside-widget.md' } | Should -Throw '*lies outside the repository*'
    }
}
