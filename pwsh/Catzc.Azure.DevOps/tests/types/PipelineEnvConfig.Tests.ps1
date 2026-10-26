<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-azure-dev-ops/tests/types/PipelineEnvConfig.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Catzc.Azure.DevOps.PipelineEnvConfig' -Tag 'L0' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Azure.DevOps.PipelineEnvConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the PipelineEnvConfig constructor to throw'
        }
    }

    Context 'logic' -Tag 'logic' {
        It 'maps a sequence of variable names, in file order' {
            $config = [Catzc.Azure.DevOps.PipelineEnvConfig]::new([System.Collections.Generic.List[object]] @('WIDGET_ID', 'gadget_Path', '_TST'))
            $config.variables | Should -Be @('WIDGET_ID', 'gadget_Path', '_TST')
        }

        It 'throws when the file is a mapping, not a sequence' {
            Get-ViolationMessage ([ordered]@{ widget = 'WIDGET_ID' }) | Should -BeLike '*must be a sequence*'
        }

        It 'throws when the sequence is empty' {
            Get-ViolationMessage ([System.Collections.Generic.List[object]]::new()) |
                Should -BeLike '*sequence is empty*'
        }

        It 'reports every violation in one throw: a bad name, a nested entry, and a duplicate' {
            $message = Get-ViolationMessage ([System.Collections.Generic.List[object]] @(
                    'WIDGET_ID', 'widget_id', 'GADGET-NAME', '9TST', [ordered]@{ tst = 1 }
                ))
            $message | Should -BeLike "*duplicate environment variable 'widget_id'*"
            $message | Should -BeLike "*'GADGET-NAME' is not an environment variable name*"
            $message | Should -BeLike "*'9TST' is not an environment variable name*"
            $message |
                Should -BeLike "*'System.Collections.Specialized.OrderedDictionary' is not an environment variable name*"
        }
    }

    Context 'integrity (shipped config)' -Tag 'integrity' {
        It 'the shipped pipeline-env.yml loads and validates' {
            $config = Get-Config -Config pipeline-env
            $config | Should -BeOfType ([Catzc.Azure.DevOps.PipelineEnvConfig])
            $config.variables | Should -Contain 'TF_BUILD'
        }
    }
}
