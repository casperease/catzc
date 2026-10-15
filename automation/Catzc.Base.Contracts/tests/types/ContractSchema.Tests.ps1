<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/types/ContractSchema.Tests.ps1
    kind: test
---
#>

# ContractSchema validates a parsed value against a bounded JSON Schema subset
# ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): type, required, properties,
# additionalProperties (a boolean), enum, items (one schema) and const; the annotations $schema, $id, $comment, title,
# description and examples are ignored. Every other keyword, and every unsupported form of a supported one, is a finding.
# Each keyword has a passing and a failing value; schemas and values are JSON literals.
Describe 'ContractSchema' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {
    BeforeAll {
        function Get-SchemaFinding {
            param([string] $Schema, [string] $Value)
            $parsedSchema = $Schema | ConvertFrom-Json -AsHashtable -NoEnumerate
            $parsedValue = $Value | ConvertFrom-Json -AsHashtable -NoEnumerate
            [Catzc.Base.Contracts.ContractSchema]::Validate($parsedSchema, $parsedValue)
        }
    }

    Context 'each keyword' {
        It '<Keyword> admits <Pass> and rejects <Fail>' -ForEach @(
            @{ Keyword = 'type'; Schema = '{"type":"string"}'; Pass = '"gadget"'; Fail = '7'; Finding = '$: expected type string, found integer (7)' }
            @{ Keyword = 'type (a list)'; Schema = '{"type":["string","null"]}'; Pass = 'null'; Fail = 'true'; Finding = '$: expected type string or null, found boolean (true)' }
            @{ Keyword = 'type number'; Schema = '{"type":"number"}'; Pass = '7'; Fail = '"7"'; Finding = "`$: expected type number, found string ('7')" }
            @{ Keyword = 'type integer'; Schema = '{"type":"integer"}'; Pass = '7.0'; Fail = '7.5'; Finding = '$: expected type integer, found number (7.5)' }
            @{ Keyword = 'type object'; Schema = '{"type":"object"}'; Pass = '{}'; Fail = '[]'; Finding = '$: expected type object, found array ([])' }
            @{ Keyword = 'required'; Schema = '{"required":["widget"]}'; Pass = '{"widget":1}'; Fail = '{"gadget":1}'; Finding = "`$: the required property 'widget' is missing" }
            @{ Keyword = 'properties'; Schema = '{"properties":{"widget":{"type":"boolean"}}}'; Pass = '{"widget":true,"gadget":1}'; Fail = '{"widget":"yes"}'; Finding = "`$.widget: expected type boolean, found string ('yes')" }
            @{ Keyword = 'additionalProperties'; Schema = '{"properties":{"widget":{}},"additionalProperties":false}'; Pass = '{"widget":1}'; Fail = '{"widget":1,"gadget":2}'; Finding = '$.gadget: the property is not allowed: additionalProperties is false and properties does not name it' }
            @{ Keyword = 'enum'; Schema = '{"enum":["widget",1]}'; Pass = '1.0'; Fail = '"gadget"'; Finding = "`$: 'gadget' is not one of the enum values 'widget', 1" }
            @{ Keyword = 'items'; Schema = '{"items":{"type":"string"}}'; Pass = '["widget","gadget"]'; Fail = '["widget",2]'; Finding = '$[1]: expected type string, found integer (2)' }
            @{ Keyword = 'const'; Schema = '{"const":{"widget":[1,2]}}'; Pass = '{"widget":[1,2]}'; Fail = '{"widget":[2,1]}'; Finding = '$: expected the constant {widget: [1, 2]}, found {widget: [2, 1]}' }
            @{ Keyword = 'a false schema'; Schema = '{"properties":{"widget":false}}'; Pass = '{"gadget":1}'; Fail = '{"widget":1}'; Finding = '$.widget: the schema #/properties/widget is false, which admits no value' }
        ) {
            @(Get-SchemaFinding $Schema $Pass) | Should -BeNullOrEmpty
            @(Get-SchemaFinding $Schema $Fail) | Should -Be @($Finding)
        }

        It 'names a key that is not a plain word in brackets' {
            @(Get-SchemaFinding '{"properties":{"widget.gadget":{"type":"string"}}}' '{"widget.gadget":1}') |
                Should -Be @("`$['widget.gadget']: expected type string, found integer (1)")
        }

        It 'reports every violation, not only the first' {
            @(Get-SchemaFinding '{"type":"object","required":["widget","gadget"]}' '{}').Count | Should -Be 2
        }
    }

    Context 'the bounded subset' {
        It 'reports a keyword outside the subset as unsupported, and validates nothing' {
            @(Get-SchemaFinding '{"type":"string","pattern":"^w"}' '7') | Should -Be @('schema #: unsupported keyword pattern')
        }

        It 'ignores the annotation <Keyword>, which constrains no value' -ForEach @(
            @{ Keyword = '$schema'; Schema = '{"$schema":"https://json-schema.org/draft/2020-12/schema","type":"string"}' }
            @{ Keyword = '$id'; Schema = '{"$id":"widget.schema.json","type":"string"}' }
            @{ Keyword = '$comment'; Schema = '{"$comment":"a widget","type":"string"}' }
            @{ Keyword = 'title'; Schema = '{"title":"Widget","type":"string"}' }
            @{ Keyword = 'description'; Schema = '{"description":"a widget name","type":"string"}' }
            @{ Keyword = 'examples'; Schema = '{"examples":[7, {"gadget":1}],"type":"string"}' }
        ) {
            @(Get-SchemaFinding $Schema '"widget"') | Should -BeNullOrEmpty
            @(Get-SchemaFinding $Schema '7') | Should -Be @('$: expected type string, found integer (7)')
        }

        It 'ignores an annotation in a nested schema' {
            @(Get-SchemaFinding '{"properties":{"widget":{"title":"Widget","description":"a gadget part"}}}' '{"widget":1}') |
                Should -BeNullOrEmpty
        }

        It 'still reports an unsupported keyword beside the annotations' {
            $schema = '{"$schema":"x","$id":"w","$comment":"c","title":"t","description":"d","examples":[],"format":"uri"}'
            @(Get-SchemaFinding $schema '"widget"') | Should -Be @('schema #: unsupported keyword format')
        }

        It 'lists the annotations among the keywords it reads' {
            [Catzc.Base.Contracts.ContractSchema]::Annotations | Should -Be @('$schema', '$id', '$comment', 'title', 'description', 'examples')
            [Catzc.Base.Contracts.ContractSchema]::Keywords | Should -Be @('type', 'required', 'properties', 'additionalProperties', 'enum', 'items', 'const',
                '$schema', '$id', '$comment', 'title', 'description', 'examples')
        }

        It 'inspects a schema alone, with no value: <Name>' -ForEach @(
            @{ Name = 'a valid schema'; Schema = '{"title":"Widget","type":"object","required":["widget"]}'; Findings = @() }
            @{ Name = 'an unsupported keyword'; Schema = '{"type":"object","minProperties":1}'; Findings = @('schema #: unsupported keyword minProperties') }
            @{ Name = 'a malformed keyword'; Schema = '{"required":"widget"}'; Findings = @('schema #/required: required is an array of property names') }
        ) {
            $parsed = $Schema | ConvertFrom-Json -AsHashtable -NoEnumerate
            $found = @([Catzc.Base.Contracts.ContractSchema]::Inspect($parsed))
            $found.Count | Should -Be $Findings.Count
            ($found -join "`n") | Should -Be ($Findings -join "`n")
        }

        It 'reports an unsupported keyword in a nested schema the value never reaches' {
            @(Get-SchemaFinding '{"properties":{"widget":{"minLength":1}}}' '{"gadget":1}') |
                Should -Be @('schema #/properties/widget: unsupported keyword minLength')
        }

        It 'reports <Form> as unsupported' -ForEach @(
            @{ Form = 'additionalProperties as a schema'; Schema = '{"additionalProperties":{"type":"string"}}'; Finding = 'schema #/additionalProperties: unsupported form of additionalProperties*' }
            @{ Form = 'items as an array'; Schema = '{"items":[{"type":"string"}]}'; Finding = 'schema #/items: unsupported form of items*' }
        ) {
            $findings = @(Get-SchemaFinding $Schema '{}')
            $findings.Count | Should -Be 1
            $findings[0] | Should -BeLike $Finding
        }

        It 'reports a malformed keyword of the subset: <Schema>' -ForEach @(
            @{ Schema = '{"type":"text"}'; Finding = "schema #/type: 'text' is not a JSON type*" }
            @{ Schema = '{"required":"widget"}'; Finding = 'schema #/required: required is an array of property names' }
            @{ Schema = '{"properties":[]}'; Finding = 'schema #/properties: properties is an object*' }
            @{ Schema = '{"enum":"widget"}'; Finding = 'schema #/enum: enum is an array of values' }
            @{ Schema = '"widget"'; Finding = "schema #: a schema is an object or a boolean, not 'widget'" }
        ) {
            $findings = @(Get-SchemaFinding $Schema '{}')
            $findings.Count | Should -Be 1
            $findings[0] | Should -BeLike $Finding
        }

        It 'escapes a JSON Pointer segment' {
            @(Get-SchemaFinding '{"properties":{"widget/gadget":{"format":"x"}}}' '{}') |
                Should -Be @('schema #/properties/widget~1gadget: unsupported keyword format')
        }
    }

    Context 'YAML values' {
        It 'validates a parsed YAML document the same as JSON' {
            $schema = '{"type":"object","properties":{"widget":{"type":"array","items":{"type":"number"}}}}' | ConvertFrom-Json -AsHashtable
            $pass = "widget:`n  - 1`n  - 1.5`n" | ConvertFrom-Yaml -Ordered
            $fail = "widget:`n  - one`n" | ConvertFrom-Yaml -Ordered
            @([Catzc.Base.Contracts.ContractSchema]::Validate($schema, $pass)) | Should -BeNullOrEmpty
            @([Catzc.Base.Contracts.ContractSchema]::Validate($schema, $fail)) | Should -Be @("`$.widget[0]: expected type number, found string ('one')")
        }
    }
}
