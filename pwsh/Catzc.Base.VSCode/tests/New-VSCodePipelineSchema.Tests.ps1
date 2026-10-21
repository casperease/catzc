<#
---
catzc:
  immutable:
    with_body_sha: "34d8490a1829"
  edges:
    docs: "[New-VSCodePipelineSchema.Tests.ps1.md](docs/references/pwsh/catzc-base-vs-code/tests/New-VSCodePipelineSchema.Tests.ps1.md)"
    code: pwsh/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
    cites:
      - ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS
---
#>

Describe 'New-VsCodePipelineSchema' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodePipelineSchemaConfig]::new([ordered]@{
                    '$schema'  = 'http://example.test/schema#'
                    title      = 'fixture'
                    type       = 'object'
                    properties = [ordered]@{ widget = [ordered]@{ type = 'string' } }
                })
        }
    }

    It 'renders strict JSON (no // header) that parses' {
        $text = New-VsCodePipelineSchema
        # Strict JSON — unlike settings/extensions/launch.json there is no leading // comment block.
        $text | Should -Not -Match '(?m)^//'
        { $text | ConvertFrom-Json } | Should -Not -Throw
    }

    It 'fronts the meta-schema and leaves the $comment key to the generated-file head' {
        $json = New-VsCodePipelineSchema | ConvertFrom-Json
        $json.'$schema' | Should -Be 'http://example.test/schema#'
        $json.PSObject.Properties.Name | Should -Not -Contain '$comment'
    }

    It 'carries the authored schema body verbatim' {
        $json = New-VsCodePipelineSchema | ConvertFrom-Json
        $json.type | Should -Be 'object'
        $json.properties.widget.type | Should -Be 'string'
    }
}

Describe 'New-VsCodePipelineSchema — real vscode-pipeline-schema.yml' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:schema = New-VsCodePipelineSchema
    }

    It 'renders the shipped registry to parseable JSON' {
        { $script:schema | ConvertFrom-Json } | Should -Not -Throw
    }

    It 'relaxes the task step — a real task ref and a template expression both validate' {
        Test-Json -Json '{"steps":[{"task":"PowerShell@2","inputs":{}}]}' -Schema $script:schema -ErrorAction SilentlyContinue |
            Should -BeTrue
        Test-Json -Json '{"steps":[{"task":"${{ parameters.x }}"}]}' -Schema $script:schema -ErrorAction SilentlyContinue |
            Should -BeTrue
    }

    It 'keeps structural teeth — a task missing its @version and a mistyped container are rejected' {
        # Catches the typo class the schema still exists to catch, without the per-task anyOf noise.
        Test-Json -Json '{"steps":[{"task":"PowerShell"}]}' -Schema $script:schema -ErrorAction SilentlyContinue |
            Should -BeFalse
        Test-Json -Json '{"steps":"not-an-array"}' -Schema $script:schema -ErrorAction SilentlyContinue |
            Should -BeFalse
    }

    It 'stays permissive on unknown top-level keys (never invents a new false positive)' {
        Test-Json -Json '{"somethingNew":true,"steps":[]}' -Schema $script:schema -ErrorAction SilentlyContinue |
            Should -BeTrue
    }
}
