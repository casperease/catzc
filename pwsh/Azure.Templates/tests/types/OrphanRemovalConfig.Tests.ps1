Describe 'OrphanRemovalConfig' -Tag 'L0', 'logic' {
    It 'declares a SQL server''s master database as Azure-created by default, whatever the case of the listing' {
        $config = [Catzc.Azure.Templates.OrphanRemovalConfig]::new($null)
        @($config.azure_created) | Should -Contain 'Microsoft.Sql/servers/databases/master'
        $config.IsAzureCreated('microsoft.sql/servers/databases', 'widget-sql/MASTER') | Should -BeTrue
        $config.IsAzureCreated('Microsoft.Sql/servers/databases', 'widget-sql/gadget') | Should -BeFalse
        $config.IsAzureCreated('Microsoft.Sql/servers', 'master') | Should -BeFalse
    }

    It 'takes the file''s list in place of the default' {
        $config = [Catzc.Azure.Templates.OrphanRemovalConfig]::new(@{ azure_created = @('Widget.Parts/widgets/gadgets/sprocket') })
        @($config.azure_created) | Should -Be @('Widget.Parts/widgets/gadgets/sprocket')
        $config.IsAzureCreated('Widget.Parts/widgets/gadgets', 'widget/sprocket') | Should -BeTrue
        $config.IsAzureCreated('Microsoft.Sql/servers/databases', 'widget-sql/master') | Should -BeFalse
    }

    It 'refuses an unknown key, a list that is not one, and an entry that is not a child type and a name' {
        { [Catzc.Azure.Templates.OrphanRemovalConfig]::new(@{ widget = 1 }) } | Should -Throw "*unknown top-level key 'widget'*"
        { [Catzc.Azure.Templates.OrphanRemovalConfig]::new(@{ azure_created = 'Widget.Parts/widgets/gadgets/sprocket' }) } | Should -Throw '*azure_created must be a list*'
        { [Catzc.Azure.Templates.OrphanRemovalConfig]::new(@{ azure_created = @('Widget.Parts/widgets/sprocket') }) } | Should -Throw '*azure_created`[0`]*must be a child resource type and a name*'
        { [Catzc.Azure.Templates.OrphanRemovalConfig]::new(@{ azure_created = @('Widget/widgets/gadgets/sprocket') }) } | Should -Throw '*azure_created`[0`]*'
    }
}
