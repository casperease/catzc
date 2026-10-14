# The inventory of internal asset dependencies
# ([ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2)) — one record per
# Get-CatzcModuleRoot call
# site, derived from the code by AST. Logic over a TestKit fixture tree with neutral names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-InternalAssetDependency' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:fake = New-FakeRepositoryRoot -Modules @{
            'Catzc.Base.Widget'   = @{
                Files = @{
                    'Get-Gadget.ps1'             = "function Get-Gadget {`n    Get-CatzcModuleRoot 'assets/gadget.txt'`n}"
                    'Set-Gadget.ps1'             = "function Set-Gadget {`n    `$path = Get-CatzcModuleRoot -ChildPath 'configs/gadget.yml'`n    Get-CatzcModuleRoot -ChildPath:`"assets/colon.txt`"`n}"
                    'Get-GadgetFolder.ps1'       = "function Get-GadgetFolder {`n    Get-CatzcModuleRoot`n}"
                    'Get-GadgetPeer.ps1'         = "function Get-GadgetPeer {`n    Get-CatzcModuleRoot 'configs/peer.yml' -Module Catzc.Base.Sprocket`n}"
                    'Get-GadgetQuiet.ps1'        = "function Get-GadgetQuiet {`n    Get-CatzcModuleRoot -ErrorAction Stop 'assets/quiet.txt'`n}"
                    'private/Get-GadgetCore.ps1' = "function Get-GadgetCore {`n    Catzc.Base.Repository\Get-CatzcModuleRoot 'assets/core.txt'`n}"
                    'tests/Get-Gadget.Tests.ps1' = "Describe 'x' { It 'y' { Get-CatzcModuleRoot 'assets/from-test.txt' } }"
                    'assets/script.ps1'          = "Get-CatzcModuleRoot 'assets/from-asset.txt'"
                }
            }
            'Catzc.Base.Sprocket' = @{
                Files = @{
                    'Get-Sprocket.ps1' = "function Get-Sprocket {`n    'no asset read here'`n}"
                }
            }
        }

        # The fake root is not the loaded code root, so the run mode reads 'build'; the guard is the seam.
        Mock Assert-SourceTree -ModuleName Catzc.Base.ModuleSystem { }

        $script:records = @(Get-InternalAssetDependency -AutomationRoot $script:fake.Automation)
        $script:find = { param([string] $ChildPath) @($script:records | Where-Object { $_.ChildPath -eq $ChildPath }) }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'records a positional literal with its module, function, repository-relative file and line' {
        $record = & $script:find 'assets/gadget.txt'
        $record | Should -HaveCount 1
        $record[0].Module | Should -Be 'Catzc.Base.Widget'
        $record[0].Function | Should -Be 'Get-Gadget'
        $record[0].File | Should -Be 'automation/Catzc.Base.Widget/Get-Gadget.ps1'
        $record[0].Line | Should -Be 2
    }

    It 'records a named -ChildPath literal, in the space and the colon form' {
        (& $script:find 'configs/gadget.yml')[0].Function | Should -Be 'Set-Gadget'
        (& $script:find 'assets/colon.txt')[0].Line | Should -Be 3
    }

    It 'records a call without a child path as the module folder itself' {
        $record = @($script:records | Where-Object Function -EQ 'Get-GadgetFolder')
        $record | Should -HaveCount 1
        $record[0].ChildPath | Should -BeNullOrEmpty
    }

    It 'records an explicit -Module literal as the module the call reads from' {
        (& $script:find 'configs/peer.yml')[0].Module | Should -Be 'Catzc.Base.Sprocket'
    }

    It 'never takes the value of another parameter (-ErrorAction Stop) for the child path' {
        & $script:find 'assets/quiet.txt' | Should -HaveCount 1
        & $script:find 'Stop' | Should -HaveCount 0
    }

    It 'scans private/ and module-qualified calls, but not tests/ or assets/' {
        (& $script:find 'assets/core.txt')[0].File | Should -Be 'automation/Catzc.Base.Widget/private/Get-GadgetCore.ps1'
        & $script:find 'assets/from-test.txt' | Should -HaveCount 0
        & $script:find 'assets/from-asset.txt' | Should -HaveCount 0
    }

    It 'returns exactly one record per call site and nothing for a module without calls' {
        $script:records | Should -HaveCount 7
        @($script:records | Where-Object { $_.File -like '*Catzc.Base.Sprocket*' }) | Should -HaveCount 0
    }

    It '-Module limits the scan to the named module folders' {
        @(Get-InternalAssetDependency -AutomationRoot $script:fake.Automation -Module Catzc.Base.Sprocket) | Should -HaveCount 0
    }

    It 'returns nothing with -Violation when every call site is literal' {
        @(Get-InternalAssetDependency -AutomationRoot $script:fake.Automation -Violation) | Should -HaveCount 0
    }
}

Describe 'Get-InternalAssetDependency — non-literal call sites (ADR-AUTO-ASSETDEP#2)' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:fake = New-FakeRepositoryRoot -Modules @{
            'Catzc.Base.Widget' = @{
                Files = @{
                    'Get-Gadget.ps1'     = "function Get-Gadget {`n    `$name = 'gadget.txt'`n    Get-CatzcModuleRoot `"assets/`$name`"`n}"
                    'Set-Gadget.ps1'     = "function Set-Gadget {`n    Get-CatzcModuleRoot -ChildPath `$script:path`n}"
                    'Find-Gadget.ps1'    = "function Find-Gadget {`n    `$arguments = @{ ChildPath = 'assets/x' }`n    Get-CatzcModuleRoot @arguments`n}"
                    'Get-GadgetPeer.ps1' = "function Get-GadgetPeer {`n    Get-CatzcModuleRoot 'configs/peer.yml' -Module `$peer`n}"
                    'Get-GadgetOk.ps1'   = "function Get-GadgetOk {`n    Get-CatzcModuleRoot 'assets/ok.txt'`n}"
                }
            }
        }
        Mock Assert-SourceTree -ModuleName Catzc.Base.ModuleSystem { }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'throws by default, naming every violating call site, so the inventory is never silently partial' {
        { Get-InternalAssetDependency -AutomationRoot $script:fake.Automation } |
            Should -Throw '*4 Get-CatzcModuleRoot call site(s) cannot be inventoried*Get-Gadget.ps1:3*'
    }

    It '-Violation lists each non-literal site with its reason instead of throwing' {
        $violations = @(Get-InternalAssetDependency -AutomationRoot $script:fake.Automation -Violation)
        ($violations.Function | Sort-Object) | Should -Be @('Find-Gadget', 'Get-Gadget', 'Get-GadgetPeer', 'Set-Gadget')
        ($violations | Where-Object Function -EQ 'Get-Gadget').Reason | Should -BeLike '*-ChildPath is not a string literal*'
        ($violations | Where-Object Function -EQ 'Set-Gadget').Line | Should -Be 2
        ($violations | Where-Object Function -EQ 'Find-Gadget').Reason | Should -BeLike '*splatted*'
        ($violations | Where-Object Function -EQ 'Get-GadgetPeer').Reason | Should -BeLike '*-Module is not a string literal*'
    }
}

Describe 'Get-InternalAssetDependency — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        { Get-InternalAssetDependency -AutomationRoot $TestDrive } | Should -Throw '*Get-InternalAssetDependency operates on the catzc source tree*'
    }
}
