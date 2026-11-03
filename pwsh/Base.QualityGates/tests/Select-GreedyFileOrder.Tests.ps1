Describe 'Select-GreedyFileOrder' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-ONESCHEDULINGPOOL' {
    BeforeAll {
        $script:root = 'C:\widget'
        $script:policy = [Catzc.Base.QualityGates.TestPolicyConfig]::new(@{ greedy_apart = @('Gadget.Apart', 'Sprocket.Apart') })
        $script:files = @(
            'C:\widget\tests\Slow.Tests.ps1'
            'C:\widget\tests\Gadget.Apart.Tests.ps1'
            'C:\widget\tests\Fresh.Tests.ps1'
            'C:\widget\tests\Quick.Tests.ps1'
            'C:\widget\tests\Sprocket.Apart.Tests.ps1'
        )
        $script:history = @{
            'tests/Slow.Tests.ps1'           = 90000.0
            'tests/Quick.Tests.ps1'          = 5000.0
            'tests/Gadget.Apart.Tests.ps1'   = 2000.0
            'tests/Sprocket.Apart.Tests.ps1' = 40000.0
        }
        $script:order = { InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = $files; History = $history; Root = $root; Policy = $policy } {
                Select-GreedyFileOrder -File $Files -DurationMs $History -RepositoryRoot $Root -Policy $Policy
            } }
    }

    It 'puts the apart files first, longest first, since their chain runs one at a time' {
        @(& $script:order)[0..1] | ForEach-Object { [System.IO.Path]::GetFileName($_) } |
            Should -Be @('Sprocket.Apart.Tests.ps1', 'Gadget.Apart.Tests.ps1')
    }

    It 'then an unmeasured file before every measured one, then the rest longest first' {
        @(& $script:order)[2..4] | ForEach-Object { [System.IO.Path]::GetFileName($_) } |
            Should -Be @('Fresh.Tests.ps1', 'Slow.Tests.ps1', 'Quick.Tests.ps1')
    }

    It 'breaks a tie on the file path, so the order is deterministic' {
        $tied = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $root; Policy = $policy } {
            Select-GreedyFileOrder -File @('C:\widget\tests\B.Tests.ps1', 'C:\widget\tests\A.Tests.ps1') -DurationMs @{} -RepositoryRoot $Root -Policy $Policy
        }
        @($tied | ForEach-Object { [System.IO.Path]::GetFileName($_) }) | Should -Be @('A.Tests.ps1', 'B.Tests.ps1')
    }

    It 'returns an empty array for no file' {
        $none = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $root; Policy = $policy } {
            Select-GreedyFileOrder -File @() -RepositoryRoot $Root -Policy $Policy
        }
        @($none) | Should -HaveCount 0
    }
}
