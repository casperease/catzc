Describe 'New-TestAutomationRunDirectory' -Tag 'L0', 'logic' {
    It 'creates a timestamped run directory under the base' {
        $base = Join-Path $TestDrive 'reports'
        $dir = InModuleScope Catzc.Base.QualityGates -Parameters @{ B = $base } {
            param($B) New-TestAutomationRunDirectory -OutputFolder $B
        }
        $dir | Should -Exist
        (Split-Path $dir -Parent) | Should -Be $base
        (Split-Path $dir -Leaf) | Should -Match '^\d{8}-\d{6}$'
    }

    It 'suffixes to avoid colliding with an existing same-second directory' {
        $base = Join-Path $TestDrive 'reports2'
        $pair = InModuleScope Catzc.Base.QualityGates -Parameters @{ B = $base } {
            param($B)
            Mock Get-Date { '20260101-000000' }
            $first = New-TestAutomationRunDirectory -OutputFolder $B
            $second = New-TestAutomationRunDirectory -OutputFolder $B
            @($first, $second)
        }
        (Split-Path $pair[0] -Leaf) | Should -Be '20260101-000000'
        (Split-Path $pair[1] -Leaf) | Should -Be '20260101-000000-2'
    }
}
