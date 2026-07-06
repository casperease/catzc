Describe 'New-VSCodePipelineSchema' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the config seam (ADR-PESTER:2): a small fixture schema registry.
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [ordered]@{
                '$schema'  = 'http://example.test/schema#'
                title      = 'fixture'
                type       = 'object'
                properties = [ordered]@{ widget = [ordered]@{ type = 'string' } }
            }
        }
    }

    It 'renders strict JSON (no // header) that parses' {
        $text = New-VSCodePipelineSchema
        # Strict JSON — unlike settings/extensions/launch.json there is no leading // comment block.
        ($text -split "`n") | Should -Not -Contain '// GENERATED FILE — do not edit. Single source of truth:'
        $text | Should -Not -Match '(?m)^//'
        { $text | ConvertFrom-Json } | Should -Not -Throw
    }

    It 'fronts the meta-schema then a $comment provenance marker' {
        $json = New-VSCodePipelineSchema | ConvertFrom-Json
        $json.'$schema' | Should -Be 'http://example.test/schema#'
        $json.'$comment' | Should -Match 'GENERATED FILE'
        $json.'$comment' | Should -Match 'vscode-pipeline-schema\.yml'
    }

    It 'carries the authored schema body verbatim' {
        $json = New-VSCodePipelineSchema | ConvertFrom-Json
        $json.type | Should -Be 'object'
        $json.properties.widget.type | Should -Be 'string'
    }
}

Describe 'New-VSCodePipelineSchema — real vscode-pipeline-schema.yml' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:schema = New-VSCodePipelineSchema
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
