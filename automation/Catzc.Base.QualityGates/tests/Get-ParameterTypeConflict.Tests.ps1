<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1
    kind: test
---
#>

# Get-ParameterTypeConflict over fixture function files in $TestDrive. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-ParameterTypeConflict' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:write = {
            param([string] $Name, [string] $Parameters)
            $path = Join-Path $TestDrive "$Name.ps1"
            [System.IO.File]::WriteAllText($path, "function $Name {`n    param($Parameters)`n}`n")
            $path
        }
        $script:find = {
            param([string[]] $Files)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ F = $Files } {
                param($F)
                Get-ParameterTypeConflict -Path $F
            }
        }
    }

    It 'reports a name typed two ways, with each type''s functions' {
        $files = @(
            (& $script:write 'Get-Widget' '[int] $TimeoutSeconds')
            (& $script:write 'Set-Widget' '[double] $TimeoutSeconds')
            (& $script:write 'Test-Widget' '[int] $TimeoutSeconds')
        )
        $conflicts = @(& $script:find $files)
        $conflicts | Should -HaveCount 1
        $conflicts[0].Name | Should -Be 'TimeoutSeconds'
        $conflicts[0].Types.Type | Should -Be @('double', 'int32')
        $conflicts[0].Types[1].Functions | Should -Be @('Get-Widget', 'Test-Widget')
    }

    It 'treats a scalar and a list of one type, and System.-prefixed names, as one type' {
        $files = @(
            (& $script:write 'Get-Gadget' '[string] $Path, [bool] $Loud')
            (& $script:write 'Set-Gadget' '[string[]] $Path, [System.Boolean] $Loud')
        )
        @(& $script:find $files) | Should -HaveCount 0
    }

    It 'never reports an untyped, [object] or [psobject] parameter' {
        $files = @(
            (& $script:write 'Get-Gizmo' '$Value')
            (& $script:write 'Set-Gizmo' '[object] $Value')
            (& $script:write 'Test-Gizmo' '[psobject] $Value, [string] $Name')
            (& $script:write 'Find-Gizmo' '[string] $Value, [string[]] $Name')
        )
        @(& $script:find $files) | Should -HaveCount 0
    }

    It 'groups names case-insensitively' {
        $files = @(
            (& $script:write 'Get-Sprocket' '[int] $Count')
            (& $script:write 'Set-Sprocket' '[string] $count')
        )
        @(& $script:find $files).Name | Should -Be @('Count')
    }
}
