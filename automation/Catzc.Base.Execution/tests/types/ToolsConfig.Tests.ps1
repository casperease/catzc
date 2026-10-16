<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Execution
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-execution/tests/types/ToolsConfig.Tests.ps1.md
    adrs:
      - ADR-AUTO-DEPS#4
      - ADR-AUTO-TEST#{3,14}
---
#>

Describe 'ToolsConfig' -Tag 'L0' {
    Context 'integrity (shipped tools.yml)' -Tag 'integrity' {
        It 'accepts the shipped tools.yml (all snake_case)' {
            $path = Join-Path $PSScriptRoot '../../configs/tools.yml'
            $config = Get-Content $path -Raw | ConvertFrom-Yaml -Ordered
            { [Catzc.Base.Execution.ToolsConfig]::new($config) } | Should -Not -Throw
        }
    }

    Context 'logic (inline configs)' -Tag 'logic' {
        BeforeAll {
            $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Base.Execution.ToolsConfig]::new($raw) }
            # A well-formed tool entry; each test copies it and changes one thing.
            $script:tool = {
                param([hashtable] $extra = @{})
                $entry = [ordered]@{
                    version         = '1.0'
                    command         = 'widget'
                    version_command = 'widget --version'
                    version_pattern = '^(?<ver>.+)$'
                    winget_id       = 'Widget.Widget'
                }
                foreach ($key in $extra.Keys) {
                    $entry[$key] = $extra[$key]
                }
                $entry
            }
        }

        It 'maps every entry to a ToolConfig, keyed by tool identity in file order' {
            $tools = & $script:make ([ordered]@{ widget = (& $script:tool); gadget = (& $script:tool @{ depends_on = 'widget' }) })
            @($tools.Keys) | Should -Be @('widget', 'gadget')
            $tools['gadget'] | Should -BeOfType [Catzc.Base.Execution.ToolConfig]
            $tools['gadget'].depends_on | Should -Be 'widget'
            $tools.widget.command | Should -Be 'widget'
            $tools.Contains('widget') | Should -BeTrue
            $tools['missing'] | Should -BeNullOrEmpty
        }

        It 'throws on a non-snake_case key' {
            $bad = [ordered]@{ Widget = (& $script:tool) }
            { & $script:make $bad } | Should -Throw '*snake_case*'
        }

        It 'throws on a non-snake_case field key (unknown key)' {
            $bad = [ordered]@{ widget = (& $script:tool @{ WingetId = 'x' }) }
            { & $script:make $bad } | Should -Throw "*tool 'widget': unknown key 'WingetId'*"
        }

        It 'throws when the python pin exceeds a tool''s max_python' {
            $bad = [ordered]@{ python = (& $script:tool @{ version = '3.14' }); faketool = (& $script:tool @{ max_python = '3.13' }) }
            { & $script:make $bad } | Should -Throw '*supports Python <= 3.13*'
        }

        It 'accepts a python pin at or below max_python' {
            $ok = [ordered]@{ python = (& $script:tool @{ version = '3.13' }); faketool = (& $script:tool @{ max_python = '3.13' }) }
            { & $script:make $ok } | Should -Not -Throw
        }

        It 'throws when depends_on names an undeclared tool' -Tag 'ADR-AUTO-DEPS#4' {
            $bad = [ordered]@{ widget = (& $script:tool @{ depends_on = 'gadget' }) }
            { & $script:make $bad } | Should -Throw "*depends_on 'gadget' is not a declared tool*"
        }

        It 'throws when a tool declares no install mechanism' {
            $entry = & $script:tool
            $entry.Remove('winget_id')
            { & $script:make ([ordered]@{ widget = $entry }) } | Should -Throw "*tool 'widget': needs an install mechanism*"
        }

        It 'throws on an empty file' {
            { & $script:make ([ordered]@{}) } | Should -Throw '*non-empty map*'
        }

        It 'reports every violation in one throw' {
            $bad = [ordered]@{
                Widget = (& $script:tool)
                gadget = (& $script:tool @{ depends_on = 'nothing' })
                python = (& $script:tool @{ version = '3.14' })
                tst    = (& $script:tool @{ max_python = '3.13' })
            }
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*'Widget'*snake_case*"
            $err.Exception.Message | Should -BeLike "*depends_on 'nothing'*"
            $err.Exception.Message | Should -BeLike '*supports Python <= 3.13*'
        }
    }
}
