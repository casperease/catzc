Describe 'Get-PipelineType' -Tag 'L0', 'logic' {
    It 'reads <Name> as type <Type> of unit <Unit>' -ForEach @(
        @{ Name = 'ci-widget'; Type = 'CI'; Unit = 'widget' }
        @{ Name = 'cd-widget'; Type = 'CD'; Unit = 'widget' }
        @{ Name = 'cde-widget'; Type = 'CDe'; Unit = 'widget' }
        @{ Name = 'deploy-gadget'; Type = 'DEPLOY'; Unit = 'gadget' }
        @{ Name = 'cron-gadget'; Type = 'CRON'; Unit = 'gadget' }
        @{ Name = 'input-gadget'; Type = 'INPUT'; Unit = 'gadget' }
        @{ Name = 'widget-tool'; Type = 'unknown'; Unit = 'widget-tool' }
    ) {
        $kind = Get-PipelineType $Name
        $kind.Type | Should -Be $Type
        $kind.Unit | Should -Be $Unit
    }
}
