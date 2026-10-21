<#
---
catzc:
  immutable:
    with_body_sha: "285f75980b98"
  edges:
    docs: "[Save-TestDurationHistory.Tests.ps1.md](docs/references/pwsh/catzc-base-quality-gates/tests/Save-TestDurationHistory.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/private/Save-TestDurationHistory.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

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

    It 'lowers a slower entry only by the decay, so one fast run does not hide a cold-cache spike' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } {
            param($Path)
            Save-TestDurationHistory -Path $Path -DurationMs @{ 'a/gadget.Tests.ps1' = 10000 } -Decay 0.9
            Save-TestDurationHistory -Path $Path -DurationMs @{ 'a/gadget.Tests.ps1' = 1000 } -Decay 0.9
        }
        (InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } { param($Path) Get-TestDurationHistory -Path $Path })['a/gadget.Tests.ps1'] | Should -Be 9000
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } {
            param($Path)
            Save-TestDurationHistory -Path $Path -DurationMs @{ 'a/gadget.Tests.ps1' = 1000 } -Decay 0.9
        }
        (InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } { param($Path) Get-TestDurationHistory -Path $Path })['a/gadget.Tests.ps1'] | Should -Be 8100
    }

    It 'trusts only the last run with a decay of 0' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } {
            param($Path)
            Save-TestDurationHistory -Path $Path -DurationMs @{ 'a/gadget.Tests.ps1' = 10000 } -Decay 0
            Save-TestDurationHistory -Path $Path -DurationMs @{ 'a/gadget.Tests.ps1' = 1000 } -Decay 0
        }
        (InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } { param($Path) Get-TestDurationHistory -Path $Path })['a/gadget.Tests.ps1'] | Should -Be 1000
    }

    It 'reads the decay from test-policy.yml when none is passed' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } {
            param($Path)
            Mock Get-Config { [Catzc.Base.QualityGates.TestPolicyConfig]::new([ordered]@{ duration_decay = 0.5 }) }
            Save-TestDurationHistory -Path $Path -DurationMs @{ 'a/gadget.Tests.ps1' = 10000 }
            Save-TestDurationHistory -Path $Path -DurationMs @{ 'a/gadget.Tests.ps1' = 1000 }
        }
        (InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:path } { param($Path) Get-TestDurationHistory -Path $Path })['a/gadget.Tests.ps1'] | Should -Be 5000
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
