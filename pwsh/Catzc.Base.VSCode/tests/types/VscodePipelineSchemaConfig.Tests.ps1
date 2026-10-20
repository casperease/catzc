<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/tests/types/VscodePipelineSchemaConfig.Tests.ps1
    folder: tests/types
    name: vscode-pipeline-schema-config-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[VscodePipelineSchemaConfig.Tests.ps1.md](docs/references/pwsh/catzc-base-vscode/tests/types/VscodePipelineSchemaConfig.Tests.ps1.md)"
---
#>

Describe 'Catzc.Base.VSCode.VscodePipelineSchemaConfig' -Tag 'L0' {
    BeforeAll {
        $script:valid = {
            [ordered]@{
                '$schema'   = 'http://example.test/schema#'
                title       = 'widget'
                type        = 'object'
                properties  = [ordered]@{ gadget = [ordered]@{ '$ref' = '#/definitions/tst' } }
                definitions = [ordered]@{
                    tst  = [ordered]@{ type = 'array'; items = [ordered]@{ '$ref' = '#/definitions/step' } }
                    step = [ordered]@{ type = 'object'; properties = [ordered]@{ task = [ordered]@{ type = 'string' } } }
                }
            }
        }

        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.VSCode.VscodePipelineSchemaConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the VscodePipelineSchemaConfig constructor to throw'
        }
    }

    Context 'logic' -Tag 'logic' {
        It 'keeps the schema document as an ordered passthrough map' {
            $config = [Catzc.Base.VSCode.VscodePipelineSchemaConfig]::new((& $script:valid))
            @($config.document.Keys) | Should -Be @('$schema', 'title', 'type', 'properties', 'definitions')
            $config.document['definitions']['step']['type'] | Should -Be 'object'
            $config.document.IsReadOnly | Should -BeTrue
        }

        It 'throws when the root is not an open object schema' {
            $raw = & $script:valid
            $raw['type'] = 'array'
            $raw['properties']['gadget']['additionalProperties'] = $false
            $message = Get-ViolationMessage $raw
            $message | Should -BeLike "*'type' must be 'object'*"
            $message | Should -BeLike "*'properties.gadget.additionalProperties' is false*"
        }

        It 'throws when the step definition branches with anyOf or oneOf' {
            $raw = & $script:valid
            $raw['definitions']['step']['properties']['task']['anyOf'] = @([ordered]@{ pattern = '^Widget@2$' })
            Get-ViolationMessage $raw | Should -BeLike "*'definitions.step.properties.task.anyOf' branches the step shape*"
        }

        It 'reports every violation in one throw: an unknown key, a missing $schema, and a dangling $ref' {
            $raw = & $script:valid
            $raw.Remove('$schema')
            $raw['$comment'] = 'authored'
            $raw['properties']['gadget']['$ref'] = '#/definitions/missing'
            $message = Get-ViolationMessage $raw
            $message | Should -BeLike "*unknown top-level key '`$comment'*"
            $message | Should -BeLike "*'`$schema' must be a non-empty meta-schema URI*"
            $message | Should -BeLike "*'properties.gadget.`$ref' points at '#/definitions/missing', which is not a definition*"
        }
    }

    Context 'integrity (shipped config)' -Tag 'integrity' {
        It 'the shipped vscode-pipeline-schema.yml loads and validates' {
            $config = Get-Config -Config vscode-pipeline-schema
            $config | Should -BeOfType ([Catzc.Base.VSCode.VscodePipelineSchemaConfig])
            $config.document['definitions'].Contains('step') | Should -BeTrue
        }
    }
}
