<#
---
catzc:
  immutable:
    with_body_sha: "12258780c277"
  edges:
    code: pwsh/Catzc.Base.QualityGates/types/EditRemindersConfig.cs
    cites:
      - ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG
---
#>

Describe 'EditRemindersConfig' -Tag 'L0', 'logic', 'ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG' {
    BeforeAll {
        $script:config = [Catzc.Base.QualityGates.EditRemindersConfig]::new(@{
                reminders = @(
                    @{ paths = @('widgets/*.md'); say = 'check the widget' },
                    @{ paths = @('widgets/**', 'gadgets/cog.yml'); say = 'check everything' }
                )
            })
    }

    It 'says nothing by default' {
        [Catzc.Base.QualityGates.EditRemindersConfig]::new(@{}).For('widgets/spin.md').Count | Should -Be 0
    }

    It 'says every matching reminder in the config''s order, with * inside one folder and ** across folders' {
        $config = $script:config
        $config.For('widgets/spin.md') | Should -Be @('check the widget', 'check everything')
        $config.For('widgets/deep/spin.md') | Should -Be @('check everything')
        $config.For('widgets\spin.md') | Should -Be @('check the widget', 'check everything')
        $config.For('gadgets/cog.yml') | Should -Be @('check everything')
        $config.For('gadgets/spring.yml').Count | Should -Be 0
        $config.For('').Count | Should -Be 0
    }

    It 'writes the PostToolUse output that hands the reminders to the session, and nothing when none is owed' {
        $json = [Catzc.Base.QualityGates.EditRemindersConfig]::HookOutput($script:config.For('widgets/spin.md')) | ConvertFrom-Json
        $json.hookSpecificOutput.hookEventName | Should -Be 'PostToolUse'
        $json.hookSpecificOutput.additionalContext | Should -Be "check the widget`ncheck everything"
        [Catzc.Base.QualityGates.EditRemindersConfig]::HookOutput([string[]] @()) | Should -BeNullOrEmpty
    }

    It 'rejects an unknown key, an entry without paths or say, and a path that is not repository-relative' {
        { [Catzc.Base.QualityGates.EditRemindersConfig]::new(@{ gadget = 1 }) } | Should -Throw '*unknown top-level key*reminders*'
        { [Catzc.Base.QualityGates.EditRemindersConfig]::new(@{ reminders = @(@{ say = 'x' }) }) } | Should -Throw '*paths must name at least one pattern*'
        { [Catzc.Base.QualityGates.EditRemindersConfig]::new(@{ reminders = @(@{ paths = @('widgets/*') }) }) } | Should -Throw '*say is required*'
        { [Catzc.Base.QualityGates.EditRemindersConfig]::new(@{ reminders = @(@{ paths = @('/widgets'); say = 'x' }) }) } | Should -Throw '*repository-relative*'
        { [Catzc.Base.QualityGates.EditRemindersConfig]::new(@{ reminders = @(@{ paths = @('widgets'); say = 'x'; colour = 'red' }) }) } | Should -Throw '*unknown key*paths, say*'
    }

    It 'finds the shipped config under the modules folder' -Tag 'L1' {
        $found = [Catzc.Base.QualityGates.EditRemindersConfig]::FindConfig((Get-RepositoryRoot))
        $found | Should -Not -BeNullOrEmpty
        $found.Replace('\', '/') | Should -BeLike '*/Catzc.Base.QualityGates/configs/edit-reminders.yml'
    }
}
