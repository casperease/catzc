# The per-machine test duration history: Save-TestDurationHistory merges a run's measurements, Get-TestDurationHistory
# reads them back. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Save-TestDurationHistory' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:path = Join-Path $TestDrive "history-$([guid]::NewGuid().ToString('N'))/durations.json"
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'writes the measurements sorted by path, and reads them back' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } {
            param($Path)
            Save-TestDurationHistory -Path $Path -DurationMs @{ 'b/widget.Tests.ps1' = 1200.4; 'a/gadget.Tests.ps1' = 300 }
        }
        $raw = [System.IO.File]::ReadAllText($script:path)
        $raw.IndexOf('a/gadget') | Should -BeLessThan $raw.IndexOf('b/widget')
        $history = InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } { param($Path) Get-TestDurationHistory -Path $Path }
        $history['b/widget.Tests.ps1'] | Should -Be 1200
        $history['a/gadget.Tests.ps1'] | Should -Be 300
    }

    It 'replaces the files a run measured and keeps the files it did not run' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } {
            param($Path)
            Save-TestDurationHistory -Path $Path -DurationMs @{ 'a/gadget.Tests.ps1' = 300; 'b/widget.Tests.ps1' = 1200 }
            Save-TestDurationHistory -Path $Path -DurationMs @{ 'a/gadget.Tests.ps1' = 450 }
        }
        $history = InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } { param($Path) Get-TestDurationHistory -Path $Path }
        $history['a/gadget.Tests.ps1'] | Should -Be 450
        $history['b/widget.Tests.ps1'] | Should -Be 1200
    }

    It 'reads a missing or unreadable history as an empty one' {
        $missing = InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } { param($Path) Get-TestDurationHistory -Path $Path }
        $missing.Count | Should -Be 0
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($script:path)) | Out-Null
        [System.IO.File]::WriteAllText($script:path, '{ not json')
        $broken = InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } { param($Path) Get-TestDurationHistory -Path $Path }
        $broken.Count | Should -Be 0
    }
}
