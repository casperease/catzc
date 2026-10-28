Describe 'The provided head contract' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
    BeforeAll {
        $folder = Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.1.0/pwsh.base.quality_gates'
        $script:sample = Get-Content -LiteralPath (Join-Path $folder 'head.sample.yml') -Raw | ConvertFrom-Yaml -Ordered
        $script:schema = Get-Content -LiteralPath (Join-Path $folder 'head.schema.json') -Raw |
            ConvertFrom-Json -AsHashtable
        $registry = Get-Config -Config file-meta
        $composed = (Get-Config -Config generated-head).order
        $script:writtenImmutable = @($composed | Sort-Object -Unique)
        $script:writtenEdges = @($registry.ImprintKeys() | Sort-Object -Unique)
        $script:parts = $script:schema['properties']['catzc']['properties']
        $script:partKeys = @('header', 'config', 'immutable')
    }

    It 'lists in its schema exactly the place facts the generated-file head writes' {
        $listed = @($script:parts['immutable']['properties'].Keys | Sort-Object)
        $listed | Should -Be $script:writtenImmutable
    }

    It 'lists in its schema exactly the edges the meta kinds write, at the block''s first level beside its parts' {
        $listed = @($script:parts.Keys | Where-Object { $_ -notin $script:partKeys } | Sort-Object)
        $listed | Should -Be $script:writtenEdges
    }

    It 'holds a sample whose every key is one the code writes, in the part the code writes it' {
        foreach ($key in @(if ($script:sample['catzc'].Contains('immutable')) {
                    $script:sample['catzc']['immutable'].Keys
                })) {
            $key | Should -BeIn $script:writtenImmutable
        }
        foreach ($key in @($script:sample['catzc'].Keys | Where-Object { $_ -notin $script:partKeys })) {
            $key | Should -BeIn $script:writtenEdges
        }
    }

    It 'describes the one head a file carries, a generated file''s, its warning under immutable and no authored key' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        @($script:sample['catzc'].Keys) | Should -Be @('immutable')
        @($script:sample['catzc']['immutable'].Keys) | Should -Be @((Get-Config -Config generated-head).order)
        $script:schema['properties']['catzc']['properties'].Contains('warning') |
            Should -BeFalse -Because 'only a generated file carries a warning, under immutable'
        foreach ($gone in 'docs', 'header') {
            $script:schema['properties']['catzc']['properties'].Contains($gone) |
                Should -BeFalse -Because 'an authored file carries no head, so its keys are gone from the contract'
        }
    }

    It 'requires no key, since a generated head holds the body hash only while tracked' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        $script:parts['immutable'].Contains('required') | Should -BeFalse
        $script:schema['properties']['catzc'].Contains('required') | Should -BeFalse
    }
}
