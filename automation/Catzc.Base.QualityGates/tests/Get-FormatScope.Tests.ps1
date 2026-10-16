<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1
    folder: tests
    name: get-format-scope-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Get-FormatScope.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-CONTRACT#5
---
#>

Describe 'Get-FormatScope' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'repo'))
        foreach ($relative in 'widgets/a.wdg', 'widgets/tests/assets/b.wdg', 'third-party/c.wdg', 'gadgets/d.gdg', 'contracts/widget/v1/e.wdg') {
            $null = New-Item -ItemType File -Path (Join-Path $script:root $relative) -Force
        }
        $script:outside = Join-Path $TestDrive 'build/e.wdg'
        $null = New-Item -ItemType File -Path $script:outside -Force
        $script:full = { param($relative) [System.IO.Path]::GetFullPath((Join-Path $script:root $relative)) }
    }

    BeforeEach {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -eq '.' } {
            'widgets/a.wdg', 'widgets/tests/assets/b.wdg', 'third-party/c.wdg', 'gadgets/d.gdg', 'contracts/widget/v1/e.wdg', 'widgets/deleted.wdg'
        }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -eq 'widgets' } {
            'widgets/a.wdg', 'widgets/tests/assets/b.wdg'
        }
        Mock Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -ParameterFilter { ($Attribute -join ',') -eq 'linguist-vendored,catzc-contract' } {
            @{
                'third-party/c.wdg'         = @{ 'linguist-vendored' = 'set' }
                'contracts/widget/v1/e.wdg' = @{ 'catzc-contract' = 'set' }
            }
        }
    }

    It 'is every tracked file present on disk, fixtures included, minus vendored code and byte-frozen contract assets' -Tag 'ADR-REPO-CONTRACT#5' {
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } { param($Root) Get-FormatScope -RepositoryRoot $Root }
        $scope | Should -Be @((& $script:full 'widgets/a.wdg'), (& $script:full 'widgets/tests/assets/b.wdg'), (& $script:full 'gadgets/d.gdg'))
    }

    It 'narrows to a folder''s tracked files, and takes a given file as it is, even outside the repository' {
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Folder = (Join-Path $script:root 'widgets'); Outside = $script:outside } {
            param($Root, $Folder, $Outside)
            Get-FormatScope -RepositoryRoot $Root -Path $Folder, $Outside
        }
        $scope | Should -Be @((& $script:full 'widgets/a.wdg'), (& $script:full 'widgets/tests/assets/b.wdg'), [System.IO.Path]::GetFullPath($script:outside))
    }

    It 'leaves out a vendored file even when it is given explicitly' {
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Vendored = (Join-Path $script:root 'third-party/c.wdg') } {
            param($Root, $Vendored)
            @(Get-FormatScope -RepositoryRoot $Root -Path $Vendored)
        }
        $scope | Should -HaveCount 0
    }
}
