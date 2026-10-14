# Get-ContractCheckResults checks each contract asset against the real tree by its kind
# ([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4),
# [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)) and returns one result per asset; a
# failed check is a result, never an exception. Every kind has a passing and a failing case. Fixtures are a widget
# repository in TestDrive, its assets under contracts/widget/0.0.0/Catzc.Widget/.
Describe 'Get-ContractCheckResults' -Tag 'L0', 'logic' {
    BeforeAll {
        function Add-File {
            param([string] $Relative, [string] $Content = '')
            $file = Join-Path $script:root $Relative
            $null = New-Item -ItemType Directory -Force -Path ([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, $Content)
        }

        function Add-Asset {
            param([string] $Relative, [string] $Content = '')
            Add-File "contracts/widget/0.0.0/Catzc.Widget/$Relative" $Content
        }

        function Get-CheckResult {
            param([string] $Path)
            $results = @(Get-Contract -RepositoryRoot $script:root -Addressing full-path -Path $Path |
                    Get-ContractCheckResults -RepositoryRoot $script:root)
            $results.Count | Should -Be 1
            $results[0]
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $null = New-Item -ItemType Directory -Force -Path $script:root
    }

    Context 'presence' -Tag 'ADR-REPO-CONTRACT#6' {
        BeforeEach {
            Add-Asset 'docs/gadget.md'
        }

        It 'passes when the target exists with the exact case of its path' {
            Add-File 'docs/gadget.md' '# Gadget'
            $result = Get-CheckResult 'docs/gadget.md'
            $result | Should -BeOfType ([Catzc.Base.Contracts.ContractCheckResult])
            $result.Asset.Kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind]::Presence)
            $result.Passed | Should -BeTrue
            $result.Findings | Should -BeNullOrEmpty
        }

        It 'fails when the target is missing' {
            Add-File 'docs/widget.md' '# Widget'
            $result = Get-CheckResult 'docs/gadget.md'
            $result.Passed | Should -BeFalse
            $result.Findings | Should -Be @("the target 'docs/gadget.md' does not exist: 'docs' holds no 'gadget.md'.")
        }

        It 'fails when the target exists only in another case' {
            Add-File 'docs/Gadget.md' '# Gadget'
            $result = Get-CheckResult 'docs/gadget.md'
            $result.Passed | Should -BeFalse
            $result.Findings | Should -Be @("the target 'docs/gadget.md' is missing in that case: 'docs' holds 'Gadget.md', not 'gadget.md'; a contract names its target with the exact case of its path.")
        }

        It 'fails when a folder of the path exists only in another case' {
            Add-File 'Docs/gadget.md' '# Gadget'
            (Get-CheckResult 'docs/gadget.md').Findings | Should -BeLike "*the repository root holds 'Docs', not 'docs'*"
        }

        It 'fails when the target is a folder' {
            Add-File 'docs/gadget.md/widget.md' '# Widget'
            (Get-CheckResult 'docs/gadget.md').Findings | Should -Be @("the target 'docs/gadget.md' is a folder, not a file.")
        }
    }

    Context 'a fragment' -Tag 'ADR-REPO-CONTRACT#6' {
        It 'passes a YAML key subset' {
            Add-Asset '.widget/build.yml' @'
on:
  push:
jobs:
  gadget:
    steps:
      - uses: sprocket
'@
            Add-File '.widget/build.yml' @'
name: widget
on:
  push:
    branches: [main]
jobs:
  gadget:
    runs-on: cog
    steps:
      - run: make
      - uses: sprocket
'@
            (Get-CheckResult '.widget/build.yml').Passed | Should -BeTrue
        }

        It 'fails a YAML fragment the target does not contain, naming each key path' {
            Add-Asset '.widget/build.yml' "jobs:`n  gadget:`n    runs-on: cog`n  widget:`n"
            Add-File '.widget/build.yml' "jobs:`n  gadget:`n    runs-on: sprocket`n"
            $result = Get-CheckResult '.widget/build.yml'
            $result.Passed | Should -BeFalse
            $result.Findings | Should -Be @(
                "`$.jobs.gadget.runs-on: expected 'cog', found 'sprocket'"
                '$.jobs.widget: the key is missing from the target'
            )
        }

        It 'passes and fails a JSON key subset with an array subset' {
            Add-Asset 'gadget.json' '{"widgets":[{"name":"cog"}]}'
            Add-File 'gadget.json' '{"widgets":[{"name":"sprocket"},{"name":"cog","size":2}],"other":1}'
            (Get-CheckResult 'gadget.json').Passed | Should -BeTrue

            Add-File 'gadget.json' '{"widgets":[{"name":"sprocket"}]}'
            (Get-CheckResult 'gadget.json').Findings | Should -Be @("`$.widgets: fragment element [0] ({name: 'cog'}) is matched by no element of the target array")
        }

        It 'reports a target that does not parse' {
            Add-Asset 'gadget.json' '{"widget":1}'
            Add-File 'gadget.json' '{"widget":'
            (Get-CheckResult 'gadget.json').Findings | Should -BeLike "'gadget.json' does not parse as Json:*"
        }

        It 'passes the non-blank lines of a text fragment in order' {
            Add-Asset 'README.md' "# Widget`n`n[![gadget](badge.svg)](ci)`n"
            Add-File 'README.md' "# Widget   `n`nIntro.`n`n[![gadget](badge.svg)](ci)`n`nMore.`n"
            (Get-CheckResult 'README.md').Passed | Should -BeTrue
        }

        It 'fails a text fragment out of order' {
            Add-Asset 'README.md' "# Widget`nGadget`n"
            Add-File 'README.md' "Gadget`n# Widget`n"
            (Get-CheckResult 'README.md').Findings | Should -Be @("fragment line 2 'Gadget' is out of order: the target has it only at or before line 2, where fragment line 1 matched")
        }

        It 'reports only presence when the target is missing' {
            Add-Asset 'README.md' "# Widget`n"
            (Get-CheckResult 'README.md').Findings | Should -Be @("the target 'README.md' does not exist: the repository root holds no 'README.md'.")
        }
    }

    Context 'a schema' -Tag 'ADR-REPO-CONTRACT#6' {
        BeforeEach {
            Add-Asset 'gadget.yml.schema.json' '{"type":"object","required":["widget"],"properties":{"widget":{"enum":["cog","sprocket"]}}}'
        }

        It 'passes a YAML target that validates' {
            Add-File 'gadget.yml' @'
size: 2
widget: cog
'@
            $result = Get-CheckResult 'gadget.yml.schema.json'
            $result.Asset.Kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind]::Schema)
            $result.Passed | Should -BeTrue
        }

        It 'fails a YAML target that does not validate' {
            Add-File 'gadget.yml' "widget: gear`n"
            (Get-CheckResult 'gadget.yml.schema.json').Findings | Should -Be @("`$.widget: 'gear' is not one of the enum values 'cog', 'sprocket'")
        }

        It 'still validates a real target against a schema with annotations' {
            Add-Asset 'gadget.yml.schema.json' '{"$schema":"https://json-schema.org/draft/2020-12/schema","description":"a gadget","type":"object","required":["widget"]}'
            Add-File 'gadget.yml' "size: 2`n"
            $result = Get-CheckResult 'gadget.yml.schema.json'
            $result.Asset.Target | Should -Be 'gadget.yml'
            $result.Findings | Should -Be @("`$: the required property 'widget' is missing")
        }

        It 'fails on a keyword outside the subset' {
            Add-Asset 'gadget.yml.schema.json' '{"type":"object","minProperties":1}'
            Add-File 'gadget.yml' "widget: cog`n"
            (Get-CheckResult 'gadget.yml.schema.json').Findings | Should -Be @('schema #: unsupported keyword minProperties')
        }

        It 'reports only presence when the target is missing' {
            (Get-CheckResult 'gadget.yml.schema.json').Findings | Should -Be @("the target 'gadget.yml' does not exist: the repository root holds no 'gadget.yml'.")
        }

        It 'reports a target that is neither JSON nor YAML' {
            Add-Asset 'gadget.md.schema.json' '{"type":"object"}'
            Add-File 'gadget.md' '# Gadget'
            (Get-CheckResult 'gadget.md.schema.json').Findings | Should -Be @("'gadget.md' is neither JSON nor YAML (.json, .yml, .yaml), so it cannot be parsed.")
        }
    }

    Context 'a sample payload' -Tag 'ADR-REPO-CONTRACT#6' {
        It 'passes a sample with no schema beside it when it parses' {
            Add-Asset 'rest/gadget.sample.json' '{"widget":1}'
            $result = Get-CheckResult 'rest/gadget.sample.json'
            $result.Asset.Kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind]::Sample)
            $result.Passed | Should -BeTrue
        }

        It 'fails a sample with no schema beside it when it does not parse' {
            Add-Asset 'rest/gadget.sample.yml' "widget: [1`n"
            (Get-CheckResult 'rest/gadget.sample.yml').Findings | Should -BeLike "'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.sample.yml' does not parse as Yaml:*"
        }

        It 'fails a sample that is neither JSON nor YAML' {
            Add-Asset 'rest/gadget.sample.txt' 'widget'
            (Get-CheckResult 'rest/gadget.sample.txt').Findings | Should -BeLike '*is neither JSON nor YAML*'
        }

        It 'passes a sample that validates against the schema beside it' {
            Add-Asset 'rest/gadget.schema.json' '{"type":"object","required":["widget"]}'
            Add-Asset 'rest/gadget.sample.json' '{"widget":1}'
            (Get-CheckResult 'rest/gadget.sample.json').Passed | Should -BeTrue
        }

        It 'fails a sample that does not validate against the schema beside it, with one finding on the sample only' {
            Add-Asset 'rest/gadget.schema.json' '{"$schema":"https://json-schema.org/draft/2020-12/schema","title":"Gadget","type":"object","required":["widget"]}'
            Add-Asset 'rest/gadget.sample.json' '{"gadget":1}'
            $results = @(Get-Contract -RepositoryRoot $script:root -Addressing full-path | Get-ContractCheckResults -RepositoryRoot $script:root)
            $results.Count | Should -Be 2
            $findings = @($results | ForEach-Object { $_.Findings })
            $findings | Should -Be @("`$: the required property 'widget' is missing")
            $sample = $results | Where-Object { $_.Asset.Kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Sample }
            $sample.Passed | Should -BeFalse
            $sample.Findings | Should -Be @("`$: the required property 'widget' is missing")
            $schema = $results | Where-Object { $_.Asset.Kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Schema }
            $schema.Asset.Target | Should -Be 'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.sample.json'
            $schema.Passed | Should -BeTrue
        }

        It 'fails a malformed schema beside a sample on the schema''s result' {
            Add-Asset 'rest/gadget.schema.json' '{"type":"object","minProperties":1}'
            Add-Asset 'rest/gadget.sample.json' '{"gadget":1}'
            $schema = Get-CheckResult 'rest/gadget.schema.json'
            $schema.Passed | Should -BeFalse
            $schema.Findings | Should -Be @('schema #: unsupported keyword minProperties')
        }

        It 'fails a schema beside a sample on the schema''s result when it does not parse' {
            Add-Asset 'rest/gadget.schema.json' '{"type":'
            Add-Asset 'rest/gadget.sample.json' '{"gadget":1}'
            (Get-CheckResult 'rest/gadget.schema.json').Findings | Should -BeLike "'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.schema.json' does not parse as Json:*"
        }
    }

    Context 'the input' -Tag 'ADR-REPO-CONTRACT#4' {
        BeforeEach {
            Add-Asset 'docs/gadget.md'
            Add-Asset 'docs/widget.md'
            Add-File 'docs/gadget.md' '# Gadget'
        }

        It 'checks every asset of the draft when given none' {
            $results = @(Get-ContractCheckResults -RepositoryRoot $script:root)
            $results.Asset.Path | Should -Be @('docs/gadget.md', 'docs/widget.md')
            $results.Passed | Should -Be @($true, $false)
        }

        It 'checks the assets given by -Asset' {
            $assets = @(Get-Contract -RepositoryRoot $script:root -Addressing full-path -Path 'docs/widget.md')
            @(Get-ContractCheckResults -Asset $assets -RepositoryRoot $script:root).Asset.Path | Should -Be @('docs/widget.md')
        }

        It 'checks nothing for an empty pipeline' {
            @(@() | Get-ContractCheckResults -RepositoryRoot $script:root).Count | Should -Be 0
        }

        It 'throws on a null asset' {
            { Get-ContractCheckResults -Asset $null -RepositoryRoot $script:root } | Should -Throw
        }

        It 'throws on a repository root that does not exist' {
            { Get-ContractCheckResults -RepositoryRoot (Join-Path $script:root 'gadget') } | Should -Throw '*does not exist*'
        }
    }
}
