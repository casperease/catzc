Describe 'Get-ImportMix' -Tag 'L0', 'logic' {
    BeforeEach {
        InModuleScope Catzc.Base.ModuleSystem { $script:importMix = $null }
        Mock Resolve-ImportMix -ModuleName Catzc.Base.ModuleSystem {
            [Catzc.Base.ModuleSystem.ImportMix]::new(@('widget'), @('pwsh'), @('Widget.Alpha'), @(), @())
        }
    }

    AfterAll {
        InModuleScope Catzc.Base.ModuleSystem { $script:importMix = $null }
    }

    It 'returns the record Set-ImportMix kept for the session, without resolving again' -Tag 'ADR-AUTO-IMPORTER-ONEMIXRECORD' {
        InModuleScope Catzc.Base.ModuleSystem {
            $script:importMix = [Catzc.Base.ModuleSystem.ImportMix]::new(@('gadget'), @('pwsh'), @('Widget.Beta'), @(), @())
        }
        (Get-ImportMix).languages | Should -Be @('gadget')
        Should -Invoke Resolve-ImportMix -ModuleName Catzc.Base.ModuleSystem -Times 0
    }

    It 'resolves the record from the configuration once when none is kept' -Tag 'ADR-AUTO-IMPORTER-ONEMIXRECORD' {
        (Get-ImportMix).modules | Should -Be @('Widget.Alpha')
        (Get-ImportMix).modules | Should -Be @('Widget.Alpha')
        Should -Invoke Resolve-ImportMix -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly
    }
}
