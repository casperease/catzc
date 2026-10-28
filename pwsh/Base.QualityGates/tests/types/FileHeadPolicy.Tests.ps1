Describe 'FileHeadPolicy' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-HEADPOLICY' {
    It 'gives a file the facts its kinds produce by default, declared once on the type' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $policy = [Catzc.Base.QualityGates.FileHeadPolicy]::new($null)
        $policy.default | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Facts)
        [Catzc.Base.QualityGates.FileHeadPolicy]::DefaultPolicy |
            Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Facts)
        $policy.For('widget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Facts)
    }

    It 'reads config as the policy of a block that keeps only its authored config part' {
        [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ classes = @{ gadget = 'config' } }).For('gadget') |
            Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Config)
    }

    It 'lets a class entry decide before the default' {
        $policy = [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ classes = @{ gadget = 'forbidden' } })
        $policy.For('gadget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
        $policy.For('widget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Facts)
    }

    It 'takes the configured default for a class no entry names' {
        $policy = [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ default = 'forbidden' })
        $policy.For('widget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
    }

    It 'lets the first class entry that matches decide, a subkind and a star included' {
        $policy = [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{
                default = 'forbidden'
                classes = [ordered]@{ 'gadget/sprocket' = 'config'; 'gadget' = 'facts'; 'widget-*' = 'facts' }
            })
        $policy.For('gadget/sprocket') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Config)
        $policy.For('gadget/cog') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Facts)
        $policy.For('widget-code') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Facts)
        $policy.For('other') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
    }

    It 'rejects a value that is no policy and a key it does not know, naming each' {
        { [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ default = 'sometimes' }) } |
            Should -Throw '*head_policy.default is ''sometimes''*'
        { [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ default = 'required' }) } |
            Should -Throw '*allowed: facts, forbidden, config*'
        { [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ pages = 'facts' }) } |
            Should -Throw '*unknown key ''pages''*'
        { [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ classes = @{ widget = 'always' } }) } |
            Should -Throw '*head_policy.classes.widget*'
        { [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ fallback = 'facts' }) } |
            Should -Throw '*unknown key ''fallback''*'
    }

    It 'is read from the head_policy key of the meta-kind registry' -Tag 'ADR-REPO-FILEMETA-METAKIND' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ head_policy = @{ classes = @{ widget = 'forbidden' } } })
        $config.PolicyFor('widget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
        $config.PolicyFor('gadget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Facts)
        [Catzc.Base.QualityGates.FileMetaConfig]::new(@{}).PolicyFor('widget') |
            Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Facts)
    }

    It 'ships the policy the rule names: agents forbidden, capabilities and slides config, diagram declarations forbidden, the rest facts' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $shipped = Get-Config -Config file-meta
        $shipped.head_policy.default | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Facts)
        @($shipped.ImprintKeys()) |
            Should -BeNullOrEmpty -Because 'an authored file carries no head: its comment page is derived on demand, never imprinted'
        $shipped.PolicyFor('agent') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
        $shipped.PolicyFor('capability') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Config)
        $shipped.PolicyFor('slide') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Config)
        $shipped.PolicyFor('diagram-declaration') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
        foreach ($class in 'function', 'type', 'config', 'test', 'record', 'reference', 'index', 'glossary') {
            $shipped.PolicyFor($class) |
                Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Facts) -Because "a $class file carries a head only when a fact is non-empty"
        }
    }
}
