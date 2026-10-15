<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-ContentExemptPath.Tests.ps1
    kind: test
---
#>

Describe 'Get-ContentExemptPath' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory($script:widgetRoot) | Out-Null
        $script:paths = @(
            'docs/widget.md'
            'automation/.vendor/Gadget/README.md'
            'docs/generated-widget.md'
            'automation/Widget/tests/assets/fixture.md'
            'contracts/widget/0.0.0/Gadget/.github/README.md'
            'docs/gadget.md'
            'docs/sprocket.md'
            'notes/widget-plan.md'
        )
    }

    BeforeEach {
        # git check-attr is the one boundary: the declared classes, as .gitattributes would report them.
        Mock Get-GitAttributeValue {
            @{
                'automation/.vendor/Gadget/README.md'             = @{ 'linguist-vendored' = 'set' }
                'docs/generated-widget.md'                        = @{ 'linguist-generated' = 'true' }
                'automation/Widget/tests/assets/fixture.md'       = @{ 'catzc-fixture' = 'set' }
                'contracts/widget/0.0.0/Gadget/.github/README.md' = @{ 'catzc-contract' = 'set' }
                'docs/gadget.md'                                  = @{ 'catzc-contract' = 'unset' }
                'docs/sprocket.md'                                = @{ 'catzc-meta' = 'unset' }
                'notes/widget-plan.md'                            = @{ 'catzc-notes' = 'set' }
            }
        } -ModuleName Catzc.Base.QualityGates
    }

    It 'names the vendored, generated, fixture, contract, and notes files, in the given order' {
        $exempt = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Paths = $script:paths } {
            param($Root, $Paths)
            Get-ContentExemptPath -RepositoryRoot $Root -Path $Paths
        }
        $exempt | Should -Be @(
            'automation/.vendor/Gadget/README.md'
            'docs/generated-widget.md'
            'automation/Widget/tests/assets/fixture.md'
            'contracts/widget/0.0.0/Gadget/.github/README.md'
            'notes/widget-plan.md'
        )
    }

    It 'keeps a file with no class, an unset class, or an unrelated class' {
        $exempt = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Paths = $script:paths } {
            param($Root, $Paths)
            Get-ContentExemptPath -RepositoryRoot $Root -Path $Paths
        }
        $exempt | Should -Not -Contain 'docs/widget.md'
        $exempt | Should -Not -Contain 'docs/gadget.md'
        $exempt | Should -Not -Contain 'docs/sprocket.md'
    }

    It 'asks .gitattributes about the five classes in one call' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Paths = $script:paths } {
            param($Root, $Paths)
            Get-ContentExemptPath -RepositoryRoot $Root -Path $Paths
        } | Out-Null
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Attribute.Count -eq 5 -and 'linguist-vendored' -in $Attribute -and 'linguist-generated' -in $Attribute -and
            'catzc-fixture' -in $Attribute -and 'catzc-contract' -in $Attribute -and 'catzc-notes' -in $Attribute
        }
    }

    It 'returns nothing, without asking git, for no paths' {
        $exempt = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-ContentExemptPath -RepositoryRoot $Root -Path @()
        }
        @($exempt).Count | Should -Be 0
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
