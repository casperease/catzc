# The real-asset test of
# [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3): Format-Automation
# imports the vendored PSScriptAnalyzer
# (<code root>/.vendor) and formats with the shipped settings file (<code root>/.internal/assets), nothing mocked —
# integrity, and not source-only, so it runs in the source and the build run. An explicit -Path over a
# throwaway file keeps it off the source tree, which the default file set needs.
Describe 'Format-Automation (real vendored analyzer and settings)' -Tag 'L2', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    BeforeAll {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'reports an off-style file under -DryRun without writing it, then formats it to the repo style' {
        $subject = Join-Path $TestDrive 'Get-Widget.ps1'
        # Off-style on purpose: a same-line brace body and a missing final newline.
        $offStyle = 'function Get-Widget { $value = 1; $value }'
        [System.IO.File]::WriteAllText($subject, $offStyle)

        $wouldChange = @(Format-Automation -Path $subject -DryRun)

        $wouldChange | Should -Be @($subject)
        [System.IO.File]::ReadAllText($subject) | Should -BeExactly $offStyle

        $changed = @(Format-Automation -Path $subject)

        $changed | Should -Be @($subject)
        $formatted = [System.IO.File]::ReadAllText($subject)
        $formatted | Should -Not -BeExactly $offStyle
        $formatted | Should -Match "`n$"
        $formatted | Should -Not -Match "`r"
    }
}
