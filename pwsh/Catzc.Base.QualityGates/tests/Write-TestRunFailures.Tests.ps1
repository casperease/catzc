<#
---
catzc:
  immutable:
    with_body_sha: "6527f8fee63d"
  edges:
    docs: "[Write-TestRunFailures.Tests.ps1.md](docs/references/pwsh/catzc-base-quality-gates/tests/Write-TestRunFailures.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/private/Write-TestRunFailures.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

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

    It 'names every failed test that shares a message, and writes the message once with its count' {
        $rows = @(
            [pscustomobject]@{ Result = 'Failed'; ExpandedPath = 'Widget.spins'; ErrorMessage = 'gadget lint failed' }
            [pscustomobject]@{ Result = 'Failed'; ExpandedPath = 'Widget.fits'; ErrorMessage = 'Expected 2, but got 1.' }
            [pscustomobject]@{ Result = 'Failed'; ExpandedPath = 'Widget.turns'; ErrorMessage = 'gadget lint failed' }
            [pscustomobject]@{ Result = 'Failed'; ExpandedPath = 'Widget.stops'; ErrorMessage = 'gadget lint failed' }
        )
        & $script:write $rows @()
        $script:headers | Should -Be @('Failures (4)')
        $script:lines | Should -Be @(
            ''
            'FAIL Widget.spins'
            'FAIL Widget.turns'
            'FAIL Widget.stops'
            '     3 failures share this message:'
            '     gadget lint failed'
            'FAIL Widget.fits'
            '     Expected 2, but got 1.'
        )
    }

    It 'writes nothing when nothing failed' {
        & $script:write @([pscustomobject]@{ Result = 'Passed'; ExpandedPath = 'Widget.spins'; ErrorMessage = $null }) @()
        $script:headers | Should -HaveCount 0
        $script:lines | Should -HaveCount 0
    }
}
