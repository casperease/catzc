Describe 'Assert-Pipelines' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Azure.DevOps { }
    }

    It 'returns silently when Test-Pipelines finds no violations' {
        Mock Test-Pipelines -ModuleName Catzc.Azure.DevOps { @() }
        { Assert-Pipelines } | Should -Not -Throw
    }

    It 'throws a collected error listing every violation, with rule codes' {
        Mock Test-Pipelines -ModuleName Catzc.Azure.DevOps {
            @(
                [pscustomobject]@{ File = 'pipelines/widget-x.yaml'; Rule = 'ADR-PIPENAME:1'; Message = 'bad prefix' }
                [pscustomobject]@{ File = 'pipelines/ci-x.yml'; Rule = 'ADR-PIPENAME:6'; Message = 'wrong ext' }
            )
        }
        { Assert-Pipelines } | Should -Throw '*2 pipeline naming/placement violation(s)*'
        { Assert-Pipelines } | Should -Throw '*ADR-PIPENAME:1*'
        { Assert-Pipelines } | Should -Throw '*ADR-PIPENAME:6*'
    }

    It 'forwards -Path to Test-Pipelines' {
        Mock Test-Pipelines -ModuleName Catzc.Azure.DevOps { @() }
        Assert-Pipelines -Path 'X:/pipelines'
        Should -Invoke Test-Pipelines -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Path -eq 'X:/pipelines' }
    }
}
