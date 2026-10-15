<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1
    kind: test
---
#>

# Write-TestRunFailures over fixture rows and file entries, with the console seam (Write-Message / Write-Header /
# Write-Footer) mocked and its lines collected. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Write-TestRunFailures' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:lines = [System.Collections.Generic.List[string]]::new()
        $script:headers = [System.Collections.Generic.List[string]]::new()
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { $script:lines.Add("$Message") }
        Mock Write-Header -ModuleName Catzc.Base.QualityGates { $script:headers.Add("$Message") }
        Mock Write-Footer -ModuleName Catzc.Base.QualityGates { }
        $script:write = {
            param($Rows, $Files)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ R = $Rows; F = $Files } {
                param($R, $F)
                Write-TestRunFailures -Rows $R -Files $F
            }
        }
    }

    It 'writes each failed test with its whole message, and nothing for passed or skipped tests' {
        $rows = @(
            [pscustomobject]@{ Result = 'Passed'; ExpandedPath = 'Widget.spins'; ErrorMessage = $null }
            [pscustomobject]@{ Result = 'Failed'; ExpandedPath = 'Widget.fits the gadget'; ErrorMessage = ('Expected 2, but got 1.', 'because the gadget is wide') -join "`n" }
            [pscustomobject]@{ Result = 'Skipped'; ExpandedPath = 'Widget.needs a gizmo'; ErrorMessage = $null }
        )
        & $script:write $rows @()
        $script:headers | Should -Be @('Failures (1)')
        $script:lines | Should -Contain 'FAIL Widget.fits the gadget'
        $script:lines | Should -Contain '     Expected 2, but got 1.'
        $script:lines | Should -Contain '     because the gadget is wide'
        @($script:lines | Where-Object { $_ -like '*spins*' -or $_ -like '*gizmo*' }) | Should -HaveCount 0
    }

    It 'writes a file that failed before its tests ran, with the file''s own error' {
        $files = @(
            [pscustomobject]@{ File = 'C:\widget\Gadget.Tests.ps1'; Result = 'Failed'; ErrorMessage = 'gadget discovery broke' }
            [pscustomobject]@{ File = 'C:\widget\Widget.Tests.ps1'; Result = 'Failed'; ErrorMessage = '' }
            [pscustomobject]@{ File = 'C:\widget\Gizmo.Tests.ps1'; Result = 'Passed'; ErrorMessage = '' }
        )
        & $script:write @() $files
        $script:headers | Should -Be @('Failures (1)') -Because 'a file whose tests failed has no error of its own; its rows carry them'
        $script:lines | Should -Contain 'FAIL C:\widget\Gadget.Tests.ps1 (failed before its tests ran)'
        $script:lines | Should -Contain '     gadget discovery broke'
    }

    It 'writes nothing when nothing failed' {
        & $script:write @([pscustomobject]@{ Result = 'Passed'; ExpandedPath = 'Widget.spins'; ErrorMessage = $null }) @()
        $script:headers | Should -HaveCount 0
        $script:lines | Should -HaveCount 0
    }
}
