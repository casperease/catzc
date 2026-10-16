<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-GitAttributeValue.Tests.ps1
    folder: tests
    name: get-git-attribute-value-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-GitAttributeValue' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot '.git')) | Out-Null
        $script:scratchRoot = Join-Path $TestDrive 'widget-scratch'
        [System.IO.Directory]::CreateDirectory($script:scratchRoot) | Out-Null
    }

    BeforeEach {
        Mock Invoke-Executable {
            [pscustomobject]@{
                ExitCode = 0
                Output   = (@(
                        'docs/widget.md', 'linguist-vendored', 'unspecified'
                        'docs/widget.md', 'catzc-fixture', 'unspecified'
                        'docs/gadget.md', 'linguist-vendored', 'set'
                        'docs/gadget.md', 'catzc-fixture', 'unspecified'
                        'docs/sprocket.md', 'linguist-vendored', 'unspecified'
                        'docs/sprocket.md', 'catzc-fixture', 'unset'
                        'docs/odd: name.md', 'catzc-fixture', 'set'
                    ) -join "`0") + "`0"
            }
        } -ModuleName Catzc.Base.QualityGates
    }

    It 'returns only the specified attributes, per path' {
        $values = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-GitAttributeValue -RepositoryRoot $Root -Path 'docs/widget.md', 'docs/gadget.md', 'docs/sprocket.md' -Attribute linguist-vendored, catzc-fixture
        }
        $values.ContainsKey('docs/widget.md') | Should -BeFalse
        $values['docs/gadget.md']['linguist-vendored'] | Should -Be 'set'
        $values['docs/sprocket.md']['catzc-fixture'] | Should -Be 'unset'
    }

    It 'asks git once, whatever the number of paths, and hands it every path on stdin' {
        $paths = 1..250 | ForEach-Object { "docs/widget$_.md" }
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Paths = $paths } {
            param($Root, $Paths)
            Get-GitAttributeValue -RepositoryRoot $Root -Path $Paths -Attribute catzc-fixture
        } | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -like '*check-attr -z --stdin catzc-fixture' -and
            ($InputText -split "`0" | Where-Object { $_ }).Count -eq 250 -and $InputText.EndsWith("`0")
        }
    }

    It 'keeps a path that holds a colon and a space whole, since paths are never split on text' {
        $values = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-GitAttributeValue -RepositoryRoot $Root -Path 'docs/odd: name.md' -Attribute catzc-fixture
        }
        $values['docs/odd: name.md']['catzc-fixture'] | Should -Be 'set'
    }

    It 'asks nothing when there are no paths' {
        $values = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-GitAttributeValue -RepositoryRoot $Root -Path @() -Attribute catzc-fixture
        }
        $values.Count | Should -Be 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'returns nothing, without asking git, outside a git work tree' {
        $values = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:scratchRoot } {
            param($Root)
            Get-GitAttributeValue -RepositoryRoot $Root -Path 'docs/widget.md' -Attribute catzc-fixture
        }
        $values.Count | Should -Be 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
