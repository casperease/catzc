<#
---
catzc:
  immutable:
    with_body_sha: b94416981ac6
  edges:
    code: pwsh/Catzc.Azure.DevOps/types/EnvironmentApprovalsConfig.cs
    cites:
      - FDR-CD-RUNGSREGISTRY
---
#>

Describe 'Catzc.Azure.DevOps.EnvironmentApprovalsConfig' -Tag 'L0' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the EnvironmentApprovalsConfig constructor to throw'
        }

        $script:ladder = [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = [ordered]@{
                    'widget-uat'  = @{ environment = 'widget'; gate = 'none' }
                    'gadget-uat'  = @{ environment = 'gadget'; gate = 'rc' }
                    'gizmo-stage' = @{ environment = 'gizmo'; gate = 'rbc' }
                    'live'        = @{ environment = 'live'; gate = 'prod-approval' }
                }
            })
    }

    Context 'logic' -Tag 'logic' {
        It 'takes the declared defaults when the file names only the units' {
            $config = [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new([ordered]@{ units = @('widget') })
            $config.units | Should -Be @('widget')
            $config.prod_environments | Should -BeNullOrEmpty
            $config.approver_group | Should -Be ([Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::DefaultApproverGroup)
            $config.approver_description | Should -Be ([Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::DefaultApproverDescription)
            $config.approver_members.Count | Should -Be 0
            $config.timeout_hours | Should -Be ([Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::DefaultTimeoutHours)
        }

        It 'derives each unit''s release-gate environments from the rungs registry, then the prod tier' -Tag 'FDR-CD-RUNGSREGISTRY' {
            $config = [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new([ordered]@{ units = @('widget', 'gadget'); prod_environments = @('widget-psub') })
            $config.Environments($ladder) | Should -Be @('widget-gadget-uat', 'widget-gizmo-stage', 'gadget-gadget-uat', 'gadget-gizmo-stage', 'widget-psub')
        }

        It 'follows a renamed rung without an edit here' -Tag 'FDR-CD-RUNGSREGISTRY' {
            $renamed = [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = [ordered]@{ 'sprocket-uat' = @{ environment = 'sprocket'; gate = 'rc' } } })
            $config = [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new([ordered]@{ units = @('widget') })
            $config.Environments($renamed) | Should -Be @('widget-sprocket-uat')
        }

        It 'stops when a prod environment repeats a rung environment' {
            $config = [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new([ordered]@{ units = @('widget'); prod_environments = @('widget-gadget-uat') })
            { $config.Environments($ladder) } | Should -Throw "*name 'widget-gadget-uat' twice*"
        }

        It 'takes the group, its members and a timeout the file sets' {
            $config = [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new([ordered]@{
                    approver_group = [ordered]@{ name = 'Widget Approvers'; description = 'Widgets'; members = @('a@widget.test', 'b@widget.test') }
                    timeout_hours  = 8
                    units          = @('widget')
                })
            $config.approver_group | Should -Be 'Widget Approvers'
            $config.approver_description | Should -Be 'Widgets'
            $config.approver_members | Should -Be @('a@widget.test', 'b@widget.test')
            $config.timeout_hours | Should -Be 8
        }

        It 'throws on an unknown key, top-level or in the group' {
            Get-ViolationMessage ([ordered]@{ units = @('widget'); gadget = 1 }) | Should -BeLike "*Unknown top-level key: 'gadget'*"
            Get-ViolationMessage ([ordered]@{ approver_group = [ordered]@{ owner = 'x' }; units = @('widget') }) |
                Should -BeLike "*Unknown approver_group key: 'owner'*"
        }

        It 'throws when approver_group is not a mapping' {
            Get-ViolationMessage ([ordered]@{ approver_group = 'Widget Approvers'; units = @('widget') }) |
                Should -BeLike '*approver_group must be a mapping*'
        }

        It 'throws on a member listed twice' {
            Get-ViolationMessage ([ordered]@{ approver_group = [ordered]@{ members = @('a@widget.test', 'A@widget.test') }; units = @('widget') }) |
                Should -BeLike "*members lists 'A@widget.test' twice*"
        }

        It 'throws on a missing or empty unit list' {
            Get-ViolationMessage ([ordered]@{ timeout_hours = 8 }) | Should -BeLike '*units must be a non-empty list*'
        }

        It 'throws on a unit or a prod environment listed twice' {
            Get-ViolationMessage ([ordered]@{ units = @('widget', 'Widget') }) | Should -BeLike "*units lists 'Widget' twice*"
            Get-ViolationMessage ([ordered]@{ units = @('widget'); prod_environments = @('widget-psub', 'WIDGET-psub') }) |
                Should -BeLike "*prod_environments lists 'WIDGET-psub' twice*"
        }

        It 'throws on a timeout outside 1 to the ADO ceiling' -ForEach @(@{ Hours = 0 }, @{ Hours = 721 }, @{ Hours = 'soon' }) {
            Get-ViolationMessage ([ordered]@{ timeout_hours = $Hours; units = @('widget') }) | Should -BeLike '*timeout_hours*whole number from 1 to 720*'
        }
    }

    Context 'integrity (shipped config)' -Tag 'integrity' {
        It 'derives the shipped approval environments from the shipped rungs registry' -Tag 'FDR-CD-RUNGSREGISTRY' {
            $names = (Get-Config -Config environment-approvals).Environments((Get-Config -Config rungs))
            $names | Should -Contain 'apex-release-uat'
            $names | Should -Contain 'apex-pre-prod'
            $names | Should -Contain 'apex-prod'
        }
    }
}
