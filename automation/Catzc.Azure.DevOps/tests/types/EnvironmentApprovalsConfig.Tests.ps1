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
            $config.timeout_hours | Should -Be ([Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::DefaultTimeoutHours)
        }

        It 'takes an approver group and a timeout the file sets' {
            $config = [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new([ordered]@{
                    approver_group = 'Widget Approvers'; timeout_hours = 8; environments = @('widget-psub')
                })
            $config.approver_group | Should -Be 'Widget Approvers'
            $config.timeout_hours | Should -Be 8
        }

        It 'throws on an unknown key' {
            Get-ViolationMessage ([ordered]@{ environments = @('widget-psub'); gadget = 1 }) | Should -BeLike "*Unknown top-level key: 'gadget'*"
        }

        It 'throws on a missing or empty environment list' {
            Get-ViolationMessage ([ordered]@{ approver_group = 'Widget Approvers' }) | Should -BeLike '*environments must be a non-empty list*'
        }

        It 'throws on an environment listed twice' {
            Get-ViolationMessage ([ordered]@{ environments = @('widget-psub', 'Widget-PSUB') }) | Should -BeLike "*lists 'Widget-PSUB' twice*"
        }

        It 'throws on a timeout outside 1 to the ADO ceiling' -ForEach @(@{ Hours = 0 }, @{ Hours = 721 }, @{ Hours = 'soon' }) {
            Get-ViolationMessage ([ordered]@{ timeout_hours = $Hours; environments = @('widget-psub') }) | Should -BeLike '*timeout_hours*whole number from 1 to 720*'
        }
    }

    Context 'integrity' -Tag 'integrity' {
        It 'loads the shipped environment-approvals.yml' {
            { Get-Config -Config environment-approvals } | Should -Not -Throw
        }
    }
}
