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
    }

    Context 'logic' -Tag 'logic' {
        It 'takes the declared defaults when the file names only the environments' {
            $config = [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new([ordered]@{ environments = @('widget-psub', 'gadget-prod') })
            $config.environments | Should -Be @('widget-psub', 'gadget-prod')
            $config.approver_group | Should -Be ([Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::DefaultApproverGroup)
            $config.approver_description | Should -Be ([Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::DefaultApproverDescription)
            $config.approver_members.Count | Should -Be 0
            $config.timeout_hours | Should -Be ([Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::DefaultTimeoutHours)
        }

        It 'takes the group, its members and a timeout the file sets' {
            $config = [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new([ordered]@{
                    approver_group = [ordered]@{ name = 'Widget Approvers'; description = 'Widgets'; members = @('a@widget.test', 'b@widget.test') }
                    timeout_hours  = 8
                    environments   = @('widget-psub')
                })
            $config.approver_group | Should -Be 'Widget Approvers'
            $config.approver_description | Should -Be 'Widgets'
            $config.approver_members | Should -Be @('a@widget.test', 'b@widget.test')
            $config.timeout_hours | Should -Be 8
        }

        It 'throws on an unknown key, top-level or in the group' {
            Get-ViolationMessage ([ordered]@{ environments = @('widget-psub'); gadget = 1 }) | Should -BeLike "*Unknown top-level key: 'gadget'*"
            Get-ViolationMessage ([ordered]@{ approver_group = [ordered]@{ owner = 'x' }; environments = @('widget-psub') }) |
                Should -BeLike "*Unknown approver_group key: 'owner'*"
        }

        It 'throws when approver_group is not a mapping' {
            Get-ViolationMessage ([ordered]@{ approver_group = 'Widget Approvers'; environments = @('widget-psub') }) |
                Should -BeLike '*approver_group must be a mapping*'
        }

        It 'throws on a member listed twice' {
            Get-ViolationMessage ([ordered]@{ approver_group = [ordered]@{ members = @('a@widget.test', 'A@widget.test') }; environments = @('widget-psub') }) |
                Should -BeLike "*members lists 'A@widget.test' twice*"
        }

        It 'throws on a missing or empty environment list' {
            Get-ViolationMessage ([ordered]@{ timeout_hours = 8 }) | Should -BeLike '*environments must be a non-empty list*'
        }

        It 'throws on an environment listed twice' {
            Get-ViolationMessage ([ordered]@{ environments = @('widget-psub', 'Widget-PSUB') }) | Should -BeLike "*lists 'Widget-PSUB' twice*"
        }

        It 'throws on a timeout outside 1 to the ADO ceiling' -ForEach @(@{ Hours = 0 }, @{ Hours = 721 }, @{ Hours = 'soon' }) {
            Get-ViolationMessage ([ordered]@{ timeout_hours = $Hours; environments = @('widget-psub') }) | Should -BeLike '*timeout_hours*whole number from 1 to 720*'
        }
    }

    Context 'integrity (shipped config)' -Tag 'integrity' {
        It 'loads the shipped environment-approvals.yml' {
            { Get-Config -Config environment-approvals } | Should -Not -Throw
        }
    }
}
