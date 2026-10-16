<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Format-FileMeta.Contract.Tests.ps1
    folder: tests
    name: format-file-meta-contract-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-CONTRACT#4
---
#>

# The provided head contract names the keys of a file's meta head; this proves they are the keys the code writes, so neither can drift.
Describe 'The provided head contract' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CONTRACT#4' {
    BeforeAll {
        $folder = Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.0.0/Catzc.Base.QualityGates'
        $script:sample = Get-Content -LiteralPath (Join-Path $folder 'head.sample.yml') -Raw | ConvertFrom-Yaml -Ordered
        $script:schema = Get-Content -LiteralPath (Join-Path $folder 'head.schema.json') -Raw | ConvertFrom-Json -AsHashtable
        $imprinted = (Get-Config -Config file-meta).Imprint() | ForEach-Object { $_.keys }
        $composed = (Get-Config -Config generated-head).order
        $script:written = @($imprinted + $composed | Sort-Object -Unique)
    }

    It 'lists in its schema exactly the keys the meta kinds and the generated-file head write' {
        $listed = @($script:schema['properties']['catzc']['properties']['derived']['properties'].Keys | Sort-Object)
        $listed | Should -Be $script:written
    }

    It 'holds a sample whose every key is one the code writes' {
        foreach ($key in $script:sample['catzc']['derived'].Keys) {
            $key | Should -BeIn $script:written
        }
    }

    It 'binds a code file to nothing outside its own module and its docs section' {
        $relatives = (Get-Config -Config file-meta).kinds | Where-Object id -eq 'relatives'
        foreach ($relation in $relatives.settings['relations']) {
            foreach ($rule in $relation['rules']) {
                foreach ($path in $rule['paths']) {
                    $path | Should -Match '^\{page\}$|^[a-z]+/\{module\}/' -Because "the '$($relation['name'])' relation must stay in the file's own module or docs section"
                }
            }
        }
    }

    It 'names the relations the head may hold in its schema, and no more than the config declares' {
        $relatives = (Get-Config -Config file-meta).kinds | Where-Object id -eq 'relatives'
        $declared = @($relatives.settings['relations'] | ForEach-Object { $_['name'] } | Sort-Object)
        $listed = @($script:schema['properties']['catzc']['properties']['derived']['properties']['relatives']['properties'].Keys | Sort-Object)
        $listed | Should -Be $declared
    }

    It 'requires the two keys no head is without' {
        $script:schema['properties']['catzc']['properties']['derived']['required'] | Should -Be @('path', 'kind')
        $script:sample['catzc']['derived'].Keys | Should -Contain 'path'
        $script:sample['catzc']['derived'].Keys | Should -Contain 'kind'
    }
}
