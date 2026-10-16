<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1
    folder: tests
    name: get-uncovered-internal-asset-dependency-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-modulesystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1.md
    cites:
      - ADR-AUTO-ASSETDEP
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-UncoveredInternalAssetDependency' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        $citation = 'ADR-AUTO-ASSETDEP' + '#3'
        $functionFile = { param([string] $Name, [string] $ChildPath) "function $Name {`n    Get-CatzcModuleRoot '$ChildPath'`n}" }

        $script:fake = New-FakeRepositoryRoot -Modules @{
            'Catzc.Base.Widget' = @{
                Files = @{
                    # covered: the citation on the Describe, the It inherits it
                    'Get-Gadget.ps1'                         = & $functionFile 'Get-Gadget' 'assets/gadget.txt'
                    'tests/Get-Gadget.Tests.ps1'             = "Describe 'g' -Tag 'L1', 'integrity', '$citation' {`n    It 'reads' { }`n}"
                    # covered through a suffixed test file, the citation on the It itself (colon form on the Context)
                    'Get-Sprocket.ps1'                       = & $functionFile 'Get-Sprocket' 'configs/sprocket.yml'
                    'tests/Get-Sprocket.Tests.ps1'           = "Describe 's' -Tag 'L0', 'logic' { It 'logic' { } }"
                    'tests/Get-Sprocket.Integrity.Tests.ps1' = "Describe 's' {`n    Context 'real' -Tag:@('L1', 'integrity') {`n        It 'reads' -Tag '$citation' { }`n    }`n}"
                    # uncovered: the only citing test is source-only (inherited from the Describe)
                    'Set-Gadget.ps1'                         = & $functionFile 'Set-Gadget' 'assets/set.txt'
                    'tests/Set-Gadget.Tests.ps1'             = "Describe 's' -Tag 'L1', 'integrity', 'source-only' {`n    It 'reads' -Tag '$citation' { }`n}"
                    # uncovered: no test file at all; a sibling's test file does not count
                    'private/Get-Cog.ps1'                    = "function Get-Cog {`n    Get-CatzcModuleRoot 'assets/cog-b.txt'`n    Get-CatzcModuleRoot 'assets/cog-a.txt'`n    Get-CatzcModuleRoot 'assets/cog-a.txt'`n}"
                    'tests/Get-CogWheel.Tests.ps1'           = "Describe 'w' -Tag 'L1', 'integrity', '$citation' { It 'reads' { } }"
                    # uncovered: the citation sits on a Describe with no It under it
                    'Find-Gadget.ps1'                        = & $functionFile 'Find-Gadget' 'assets/find.txt'
                    'tests/Find-Gadget.Tests.ps1'            = "Describe 'f' -Tag 'L1', 'integrity', '$citation' { }`nDescribe 'other' -Tag 'L0', 'logic' { It 'logic' { } }"
                }
            }
        }

        # The fake root is not the loaded code root, so the run mode reads 'build'; the guard is the seam.
        Mock Assert-SourceTree -ModuleName Catzc.Base.ModuleSystem { }

        $script:uncovered = @(InModuleScope Catzc.Base.ModuleSystem -Parameters @{ Root = $script:fake.Automation } {
                param($Root)
                Get-UncoveredInternalAssetDependency -AutomationRoot $Root
            })
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'names exactly the uncovered functions, sorted' {
        $script:uncovered.Function | Should -Be @('Find-Gadget', 'Get-Cog', 'Set-Gadget')
    }

    It 'counts a citation inherited from the Describe and one on the It in a suffixed test file' {
        $script:uncovered.Function | Should -Not -Contain 'Get-Gadget'
        $script:uncovered.Function | Should -Not -Contain 'Get-Sprocket'
    }

    It 'rejects a citing test that is source-only, listing the file it inspected' {
        $record = $script:uncovered | Where-Object Function -EQ 'Set-Gadget'
        $record.Reason | Should -BeLike "*without 'source-only'*"
        $record.TestFile | Should -Be @('automation/Catzc.Base.Widget/tests/Set-Gadget.Tests.ps1')
    }

    It 'reports a function with no test file of its own, with its unique child paths sorted' {
        $record = $script:uncovered | Where-Object Function -EQ 'Get-Cog'
        $record.Module | Should -Be 'Catzc.Base.Widget'
        $record.ChildPath | Should -Be @('assets/cog-a.txt', 'assets/cog-b.txt')
        @($record.TestFile) | Should -HaveCount 0
        $record.Reason | Should -BeLike '*no test file named Get-Cog.Tests.ps1*'
    }

    It 'needs an It block under the citation — a citing Describe without tests covers nothing' {
        $script:uncovered.Function | Should -Contain 'Find-Gadget'
    }

    It 'returns nothing when the inventory is empty' {
        $none = @(InModuleScope Catzc.Base.ModuleSystem -Parameters @{ Root = $script:fake.Automation } {
                param($Root)
                Get-UncoveredInternalAssetDependency -AutomationRoot $Root -Dependency @()
            })
        $none | Should -HaveCount 0
    }
}
