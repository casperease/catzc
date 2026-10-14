Describe 'Get-TimeoutSeconds' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Timeouts {
            [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ default_seconds = 7; executables = @{ widget = 90 } })
        }
    }

    It 'returns default_seconds without an executable' {
        Get-TimeoutSeconds | Should -Be 7
    }

    It "returns an executable's own limit" {
        Get-TimeoutSeconds -Executable 'C:\tools\widget.exe' | Should -Be 90
    }

    It 'returns default_seconds for an unlisted executable' {
        Get-TimeoutSeconds -Executable gadget | Should -Be 7
    }
}
