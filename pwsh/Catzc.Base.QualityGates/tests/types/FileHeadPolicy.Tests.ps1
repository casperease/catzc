<#
---
catzc:
  immutable:
    with_body_sha: "0ab77ad75581"
  edges:
    code: pwsh/Catzc.Base.QualityGates/types/FileHeadPolicy.cs
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-REPO-FILEMETA-HEADPOLICY
      - ADR-REPO-FILEMETA-METAKIND
      - ADR-REPO-VARIANT-FILEHEADS
---
#>

Describe 'FileHeadPolicy' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-HEADPOLICY' {
    It 'forbids a block by default, declared once on the type' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $policy = [Catzc.Base.QualityGates.FileHeadPolicy]::new($null)
        $policy.default | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
        [Catzc.Base.QualityGates.FileHeadPolicy]::DefaultPolicy | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
        $policy.For('widget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
    }

    It 'gives an authored file in a code carrier the file-heads variant: required when minimal, forbidden when none' -Tag 'ADR-REPO-VARIANT-FILEHEADS' {
        $policy = [Catzc.Base.QualityGates.FileHeadPolicy]::new($null)
        $policy.For('widget', $true, $true) | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Required)
        $policy.For('widget', $true, $false) | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
        $policy.For('widget', $false, $true) | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
    }

    It 'reads config as the policy of a block that keeps only its authored config part' {
        [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ classes = @{ gadget = 'config' } }).For('gadget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Config)
    }

    It 'lets a class entry decide before the variant' {
        $policy = [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ classes = @{ gadget = 'forbidden' } })
        $policy.For('gadget', $true, $true) | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
        $policy.For('widget', $true, $true) | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Required)
    }

    It 'takes the configured default for a class no entry names' {
        $policy = [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ default = 'optional' })
        $policy.For('widget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Optional)
    }

    It 'lets the first class entry that matches decide, a subkind and a star included' {
        $policy = [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{
                default = 'forbidden'
                classes = [ordered]@{ 'gadget/sprocket' = 'optional'; 'gadget' = 'required'; 'widget-*' = 'required' }
            })
        $policy.For('gadget/sprocket') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Optional)
        $policy.For('gadget/cog') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Required)
        $policy.For('widget-code') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Required)
        $policy.For('other') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
    }

    It 'rejects a value that is no policy and a key it does not know, naming each' {
        { [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ default = 'sometimes' }) } | Should -Throw '*head_policy.default is ''sometimes''*'
        { [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ pages = 'required' }) } | Should -Throw '*unknown key ''pages''*'
        { [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ classes = @{ widget = 'always' } }) } | Should -Throw '*head_policy.classes.widget*'
        { [Catzc.Base.QualityGates.FileHeadPolicy]::new(@{ fallback = 'required' }) } | Should -Throw '*unknown key ''fallback''*'
    }

    It 'is read from the head_policy key of the meta-kind registry' -Tag 'ADR-REPO-FILEMETA-METAKIND' {
        $config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ head_policy = @{ classes = @{ widget = 'required' } } })
        $config.PolicyFor('widget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Required)
        $config.PolicyFor('gadget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
        [Catzc.Base.QualityGates.FileMetaConfig]::new(@{}).PolicyFor('widget') | Should -Be ([Catzc.Base.QualityGates.HeadPolicy]::Forbidden)
    }
}
