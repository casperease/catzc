Describe 'ContractsConfig' -Tag 'L0', 'logic' {
    It 'defaults to the track-module form with no exceptions' {
        $config = [Catzc.Base.Contracts.ContractsConfig]::new(@{})
        $config.form | Should -BeExactly 'track_module'
        $config.exceptions.Count | Should -Be 0
        $config.GroupOf('Catzc.Widget', 'gizmo', 'widget') | Should -BeExactly 'gizmo.widget'
    }

    It 'names an excepted module''s group outright, and maps the group back to it' {
        $config = [Catzc.Base.Contracts.ContractsConfig]::new(@{ groups = @{ exceptions = @{ 'Catzc.Widget' = 'gizmo.gadget' } } })
        $config.GroupOf('Catzc.Widget', 'gizmo', 'widget') | Should -BeExactly 'gizmo.gadget'
        $config.ExceptionModuleOf('gizmo.gadget') | Should -BeExactly 'Catzc.Widget'
        $config.ExceptionModuleOf('gizmo.widget') | Should -BeNullOrEmpty
    }

    It 'refuses an unknown key, an unknown form, a malformed group and one group for two modules' {
        { [Catzc.Base.Contracts.ContractsConfig]::new(@{ modes = 1 }) } | Should -Throw '*unknown key*groups*'
        { [Catzc.Base.Contracts.ContractsConfig]::new(@{ groups = @{ form = 'namespace' } }) } | Should -Throw '*not a group form*'
        { [Catzc.Base.Contracts.ContractsConfig]::new(@{ groups = @{ exceptions = @{ 'Catzc.Widget' = 'Widget' } } }) } |
            Should -Throw '*no group*'
        { [Catzc.Base.Contracts.ContractsConfig]::new(@{ groups = @{ exceptions = [ordered]@{ 'Catzc.Widget' = 'gizmo.w'; 'Catzc.Gadget' = 'gizmo.w' } } }) } |
            Should -Throw '*named for two modules*'
    }

    It 'reads the shipped config' -Tag 'L1' {
        (Get-Config -Config contracts).form | Should -BeExactly 'track_module'
    }
}
