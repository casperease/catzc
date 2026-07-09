Describe 'Get-PipelineTemplateReference' -Tag 'L0', 'logic' {
    # Get-PipelineTemplateReference is private, so it is exercised through the module (ADR-AUTO-PESTER:4).
    BeforeAll {
        function New-Yaml {
            param([string] $Content)
            $path = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '.yaml')
            Set-Content -Path $path -Value $Content -Encoding utf8
            $path
        }
        $script:getRefs = {
            param($Path)
            InModuleScope Catzc.Azure.DevOps -Parameters @{ P = $Path } { param($P) Get-PipelineTemplateReference -Path $P }
        }
    }

    It 'extracts a steps-style list include and an extends-block reference' {
        $p = New-Yaml @'
extends:
  template: /pipelines/extends/cd-customer.yaml
steps:
  - template: /pipelines/steps/invoke-automation.yaml
'@
        $refs = & $script:getRefs $p
        $refs | Should -HaveCount 2
        $refs | Should -Contain '/pipelines/extends/cd-customer.yaml'
        $refs | Should -Contain '/pipelines/steps/invoke-automation.yaml'
    }

    It 'returns a relative reference verbatim (so the caller can flag it)' {
        $p = New-Yaml "steps:`n  - template: steps/local.yaml"
        & $script:getRefs $p | Should -Be @('steps/local.yaml')
    }

    It 'strips surrounding quotes' {
        $p = New-Yaml "steps:`n  - template: '/pipelines/steps/x.yaml'"
        & $script:getRefs $p | Should -Be @('/pipelines/steps/x.yaml')
    }

    It 'skips template expressions and runtime variables (no static target)' {
        $p = New-Yaml @'
steps:
  - template: ${{ parameters.stepTemplate }}
  - template: /pipelines/$(kind)/x.yaml
'@
        & $script:getRefs $p | Should -BeNullOrEmpty
    }

    It 'ignores a template key whose value is not a .yaml path' {
        # A `parameters:` declaration named template, or any non-path value, is not a reference.
        $p = New-Yaml "parameters:`n  - name: template`n    default: none"
        & $script:getRefs $p | Should -BeNullOrEmpty
    }

    It 'does not match commented-out references' {
        $p = New-Yaml @'
# - template: /pipelines/steps/old.yaml
steps: []
'@
        & $script:getRefs $p | Should -BeNullOrEmpty
    }
}
