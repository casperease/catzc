Describe 'Assert-ToolsConfig' -Tag 'L0' {
    # Reads the shipped tools.yml — guards real repository content (ADR-TEST:14).
    Context 'integrity (shipped tools.yml)' -Tag 'integrity' {
        It 'accepts the shipped tools.yml (all snake_case)' {
            $path = Join-Path $PSScriptRoot '../configs/tools.yml'
            $config = Get-Content $path -Raw | ConvertFrom-Yaml -Ordered
            { & (Get-Module Catzc.Tooling.Core) { Assert-ToolsConfig $args[0] } $config } |
                Should -Not -Throw
        }
    }

    # Validator logic on an inline (synthetic) config — independent of any shipped asset (ADR-TEST:14).
    Context 'logic (inline configs)' -Tag 'logic' {
        It 'throws on a non-snake_case key' {
            $bad = [ordered]@{ Python = [ordered]@{ version = '3.11' } }
            { & (Get-Module Catzc.Tooling.Core) { Assert-ToolsConfig $args[0] } $bad } |
                Should -Throw '*snake_case*'
        }
    }
}
