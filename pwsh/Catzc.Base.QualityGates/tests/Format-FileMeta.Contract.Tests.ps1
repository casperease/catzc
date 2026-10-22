<#
---
catzc:
  edges:
    cites:
      - ADR-REPO-CONTRACT-PROVENBYTESTS
      - ADR-REPO-FILEMETA-HEADPOLICY
---
#>

# The provided head contract names the keys of a file's meta head; this proves they are the keys the code writes, so neither can drift.
Describe 'The provided head contract' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
    BeforeAll {
        $folder = Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.0.0/catzc.base.quality_gates'
        $script:sample = Get-Content -LiteralPath (Join-Path $folder 'head.sample.yml') -Raw | ConvertFrom-Yaml -Ordered
        $script:schema = Get-Content -LiteralPath (Join-Path $folder 'head.schema.json') -Raw | ConvertFrom-Json -AsHashtable
        $registry = Get-Config -Config file-meta
        $composed = (Get-Config -Config generated-head).order
        # The generated-file head holds place facts only, so its keys join the registry's immutable ones.
        $script:writtenImmutable = @($registry.KeysOf('immutable') + $composed | Sort-Object -Unique)
        $script:writtenEdges = @($registry.KeysOf('edges') | Sort-Object -Unique)
        $script:parts = $script:schema['properties']['catzc']['properties']
    }

    It 'lists in its schema exactly the place facts the meta kinds and the generated-file head write' {
        $listed = @($script:parts['immutable']['properties'].Keys | Sort-Object)
        $listed | Should -Be $script:writtenImmutable
    }

    It 'lists in its schema exactly the edges the meta kinds write' {
        $listed = @($script:parts['edges']['properties'].Keys | Sort-Object)
        $listed | Should -Be $script:writtenEdges
    }

    It 'holds a sample whose every key is one the code writes, in the part the code writes it' {
        foreach ($key in @(if ($script:sample['catzc'].Contains('immutable')) {
                    $script:sample['catzc']['immutable'].Keys
                })) {
            $key | Should -BeIn $script:writtenImmutable
        }
        foreach ($key in $script:sample['catzc']['edges'].Keys) {
            $key | Should -BeIn $script:writtenEdges
        }
    }

    It 'binds a code file to nothing outside its own module and its docs section' {
        $relatives = (Get-Config -Config file-meta).kinds | Where-Object id -eq 'relative-edges'
        foreach ($relation in $relatives.settings['relations']) {
            foreach ($rule in $relation['rules']) {
                foreach ($path in $rule['paths']) {
                    $path | Should -Match '^\{page\}$|^[a-z]+/\{module\}/' -Because "the '$($relation['name'])' relation must stay in the file's own module or docs section"
                }
            }
        }
    }

    It 'names the relations the head may hold as edges in its schema, and no more than the config declares' {
        $relatives = (Get-Config -Config file-meta).kinds | Where-Object id -eq 'relative-edges'
        $declared = @($relatives.settings['relations'] | ForEach-Object { $_['name'] } | Sort-Object)
        $declared | Should -Be @($relatives.keys | Sort-Object)
        foreach ($name in $declared) {
            $script:parts['edges']['properties'].Keys | Should -Contain $name
        }
    }

    It 'opens an authored head with the warning the registry declares, a string part of its own' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        $script:schema['properties']['catzc']['properties']['warning']['type'] | Should -Be 'string'
        $script:sample['catzc']['warning'] | Should -BeExactly (Get-Config -Config file-meta).warning
        @($script:sample['catzc'].Keys)[0] | Should -Be 'warning'
    }

    It 'requires no key, since an authored head holds edges only and a generated one holds the body hash only while tracked' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        $script:parts['immutable'].Contains('required') | Should -BeFalse
        $script:schema['properties']['catzc'].Contains('required') | Should -BeFalse
        $script:sample['catzc'].Contains('immutable') | Should -BeFalse -Because 'the sample is an authored head'
    }
}
