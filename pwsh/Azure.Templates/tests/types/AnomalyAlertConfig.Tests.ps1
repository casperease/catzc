Describe 'AnomalyAlertConfig' -Tag 'L0', 'logic' {
    It 'declares a template of each kind on the type by default, two different ones' {
        $config = [Catzc.Azure.Templates.AnomalyAlertConfig]::new($null)
        $config.configuration_template | Should -Not -BeNullOrEmpty
        $config.vault_template | Should -Not -BeNullOrEmpty
        $config.vault_template | Should -Not -Be $config.configuration_template
    }

    It 'takes the file''s templates in place of the defaults' {
        $config = [Catzc.Azure.Templates.AnomalyAlertConfig]::new(@{ configuration_template = 'widget'; vault_template = 'gadget' })
        $config.configuration_template | Should -BeExactly 'widget'
        $config.vault_template | Should -BeExactly 'gadget'
    }

    It 'refuses an unknown key and a template that is no name' {
        { [Catzc.Azure.Templates.AnomalyAlertConfig]::new(@{ widget = 1 }) } | Should -Throw "*unknown top-level key 'widget'*"
        { [Catzc.Azure.Templates.AnomalyAlertConfig]::new(@{ vault_template = '' }) } | Should -Throw '*vault_template must be a template name*'
        { [Catzc.Azure.Templates.AnomalyAlertConfig]::new(@{ configuration_template = @('widget') }) } | Should -Throw '*configuration_template must be a template name*'
    }
}
