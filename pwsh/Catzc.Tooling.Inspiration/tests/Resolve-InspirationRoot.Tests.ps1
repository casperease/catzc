<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Resolve-InspirationRoot' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:workspace = [IO.Path]::GetFullPath((Join-Path $TestDrive 'widgets'))
        $script:repository = Join-Path $script:workspace 'catzc'

        # The Git Bash view of a Windows path: 'C:\a\b' -> '/c/a/b'.
        function ConvertTo-BashView {
            param([string] $Path)
            '/' + $Path.Substring(0, 1).ToLowerInvariant() + $Path.Substring(2).Replace('\', '/')
        }
    }

    It 'resolves the workspace anchor to a sibling of the repository root (pwsh view)' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Inspiration { $script:repository }
        $resolved = & (Get-Module Catzc.Tooling.Inspiration) { Resolve-InspirationRoot '{workspace}/gadget' }
        $resolved | Should -BeExactly ([IO.Path]::GetFullPath((Join-Path $script:workspace 'gadget')))
    }

    It 'resolves the workspace anchor the same from the Git Bash view of the repository root' -Skip:(-not $IsWindows) {
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Inspiration { $script:repository }
        $fromPwsh = & (Get-Module Catzc.Tooling.Inspiration) { Resolve-InspirationRoot '{workspace}/gadget' }
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Inspiration { ConvertTo-BashView $script:repository }
        $fromBash = & (Get-Module Catzc.Tooling.Inspiration) { Resolve-InspirationRoot '{workspace}/gadget' }
        $fromBash | Should -BeExactly $fromPwsh
    }

    It 'resolves an absolute root given in the Git Bash view to the same path as the pwsh view' -Skip:(-not $IsWindows) {
        $gadget = Join-Path $script:workspace 'gadget'
        $bash = ConvertTo-BashView $gadget
        $resolved = & (Get-Module Catzc.Tooling.Inspiration) { param($p) Resolve-InspirationRoot $p } $bash
        $resolved | Should -BeExactly ([IO.Path]::GetFullPath($gadget))
    }

    It 'resolves a repository-relative root against the repository root' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Repository { $script:repository }
        $resolved = & (Get-Module Catzc.Tooling.Inspiration) { Resolve-InspirationRoot 'widget/docs' }
        $resolved | Should -BeExactly ([IO.Path]::GetFullPath((Join-Path $script:repository 'widget/docs')))
    }
}
