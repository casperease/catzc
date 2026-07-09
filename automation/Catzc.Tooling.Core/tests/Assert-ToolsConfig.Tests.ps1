Describe 'Assert-ToolsConfig' -Tag 'L0' {
    # Reads the shipped tools.yml — guards real repository content (ADR-AUTO-TEST:14).
    Context 'integrity (shipped tools.yml)' -Tag 'integrity' {
        It 'accepts the shipped tools.yml (all snake_case)' {
            $path = Join-Path $PSScriptRoot '../configs/tools.yml'
            $config = Get-Content $path -Raw | ConvertFrom-Yaml -Ordered
            { & (Get-Module Catzc.Tooling.Core) { Assert-ToolsConfig $args[0] } $config } |
                Should -Not -Throw
        }
    }

    # Validator logic on an inline (synthetic) config — independent of any shipped asset (ADR-AUTO-TEST:14).
    Context 'logic (inline configs)' -Tag 'logic' {
        It 'throws on a non-snake_case key' {
            $bad = [ordered]@{ Widget = [ordered]@{ version = '3.11' } }
            { & (Get-Module Catzc.Tooling.Core) { Assert-ToolsConfig $args[0] } $bad } |
                Should -Throw '*snake_case*'
        }

        # The rule keys on the literal `python` tool (the pinned interpreter); the tool declaring max_python
        # is incidental, so it uses the fixture token faketool (ADR-AUTO-TEST:3).
        It 'throws when the python pin exceeds a tool''s max_python' {
            $bad = [ordered]@{ python = [ordered]@{ version = '3.14' }; faketool = [ordered]@{ max_python = '3.13' } }
            { & (Get-Module Catzc.Tooling.Core) { Assert-ToolsConfig $args[0] } $bad } |
                Should -Throw '*supports Python <= 3.13*'
        }

        It 'accepts a python pin at or below max_python' {
            $ok = [ordered]@{ python = [ordered]@{ version = '3.13' }; faketool = [ordered]@{ max_python = '3.13' } }
            { & (Get-Module Catzc.Tooling.Core) { Assert-ToolsConfig $args[0] } $ok } |
                Should -Not -Throw
        }
    }
}
