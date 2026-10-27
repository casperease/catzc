Describe 'ConvertFrom-BicepRuntimeSlotsJson' -Tag 'L0', 'logic' {
    It 'yields exactly the slotted entries as env-slot, in list order' {
        InModuleScope Catzc.Azure.Templates {
            $json = '[{"env":"alpha","serviceConnection":"sc-widget"},{"env":"alpha","slot":"red","serviceConnection":"sc-widget"},{"env":"beta","slot":"l3"}]'
            @(ConvertFrom-BicepRuntimeSlotsJson -Json $json) | Should -Be @('alpha-red', 'beta-l3')
        }
    }

    It 'yields nothing for an empty list, an empty string, or a list with no slotted entry' {
        InModuleScope Catzc.Azure.Templates {
            @(ConvertFrom-BicepRuntimeSlotsJson -Json '[]').Count | Should -Be 0
            @(ConvertFrom-BicepRuntimeSlotsJson -Json '').Count | Should -Be 0
            @(ConvertFrom-BicepRuntimeSlotsJson -Json '[{"env":"alpha"}]').Count | Should -Be 0
        }
    }

    It 'refuses an entry without an env' {
        InModuleScope Catzc.Azure.Templates {
            { ConvertFrom-BicepRuntimeSlotsJson -Json '[{"slot":"red"}]' } | Should -Throw '*every entry needs an env*'
        }
    }
}
