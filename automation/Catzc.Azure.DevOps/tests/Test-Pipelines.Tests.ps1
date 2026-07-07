Describe 'Test-Pipelines' -Tag 'L0', 'logic' {
    BeforeAll {
        # Build a classifier record like Get-AdoYamlFiles emits (string props stand in for the C# record).
        function Rec {
            param($Rel, $Classification = 'Template', $TemplateType = $null, $ParseError = $null)
            [pscustomobject]@{
                RelativePath      = $Rel
                RelativeDirectory = (Split-Path $Rel -Parent)
                Path              = "X:/pipelines/$Rel"
                Classification    = $Classification
                TemplateType      = $TemplateType
                ParseError        = $ParseError
            }
        }
    }

    BeforeEach {
        $script:records = @()
        $script:refs = @()

        # Isolate through the classifier + reference-scan seams (ADR-PESTER:2).
        Mock Get-AdoYamlFiles -ModuleName Catzc.Azure.DevOps { $script:records }
        Mock Get-PipelineTemplateReference -ModuleName Catzc.Azure.DevOps { $script:refs }
        Mock Assert-PathExist -ModuleName Catzc.Azure.DevOps { }
    }

    It 'passes a compliant tree with no violations' {
        $script:records = @(
            (Rec 'ci-automation.yaml' 'Pipeline')
            (Rec 'cd-shared.yaml' 'Pipeline')
            (Rec 'steps/invoke-automation.yaml' -Classification 'Template' -TemplateType 'Steps')
            (Rec 'extends/cd-customer.yaml' -Classification 'Template' -TemplateType 'Stages')
        )
        @(Test-Pipelines -Path 'X:/pipelines') | Should -HaveCount 0
    }

    It 'flags a root pipeline whose name lacks a valid type prefix (ADR-PIPENAME:1)' {
        $script:records = @((Rec 'widget-thing.yaml' 'Pipeline'))
        $v = @(Test-Pipelines -Path 'X:/pipelines')
        $v | Should -HaveCount 1
        $v[0].Rule | Should -Be 'ADR-PIPENAME:1'
    }

    It 'accepts every sanctioned type prefix' {
        $script:records = @('cron', 'ci', 'cd', 'cde', 'deploy', 'input' | ForEach-Object { Rec "$_-x.yaml" 'Pipeline' })
        @(Test-Pipelines -Path 'X:/pipelines') | Should -HaveCount 0
    }

    It 'flags a .yml executable under pipelines/ (ADR-PIPENAME:6)' {
        $script:records = @((Rec 'ci-thing.yml' 'Pipeline'))
        $v = @(Test-Pipelines -Path 'X:/pipelines')
        $v.Rule | Should -Be 'ADR-PIPENAME:6'
    }

    It 'flags a template in an unsanctioned folder (ADR-PIPENAME:3)' {
        $script:records = @((Rec 'widgets/x.yaml' -Classification 'Template' -TemplateType 'Steps'))
        $v = @(Test-Pipelines -Path 'X:/pipelines')
        $v.Rule | Should -Be 'ADR-PIPENAME:3'
    }

    It 'flags a template nested deeper than one level (ADR-PIPENAME:2)' {
        $script:records = @((Rec 'steps/sub/x.yaml' -Classification 'Template' -TemplateType 'Steps'))
        $v = @(Test-Pipelines -Path 'X:/pipelines')
        $v.Rule | Should -Be 'ADR-PIPENAME:2'
    }

    It 'flags a structural pipeline hiding inside a template folder (ADR-PIPENAME:2)' {
        $script:records = @((Rec 'steps/sneaky.yaml' 'Pipeline'))
        $v = @(Test-Pipelines -Path 'X:/pipelines')
        $v.Rule | Should -Be 'ADR-PIPENAME:2'
    }

    It 'flags a fragment whose kind does not match its folder (ADR-PIPENAME:3)' {
        $script:records = @((Rec 'steps/x.yaml' -Classification 'Template' -TemplateType 'Jobs'))
        $v = @(Test-Pipelines -Path 'X:/pipelines')
        $v.Rule | Should -Be 'ADR-PIPENAME:3'
    }

    It 'does not subtype-check the extends/ folder (whole-pipeline templates)' {
        $script:records = @((Rec 'extends/cd-customer.yaml' -Classification 'Template' -TemplateType 'Jobs'))
        @(Test-Pipelines -Path 'X:/pipelines') | Should -HaveCount 0
    }

    It 'flags a relative template reference (ADR-PIPENAME:4)' {
        $script:records = @((Rec 'ci-x.yaml' 'Pipeline'))
        $script:refs = @('steps/local.yaml')
        $v = @(Test-Pipelines -Path 'X:/pipelines')
        $v.Rule | Should -Be 'ADR-PIPENAME:4'
    }

    It 'accepts an absolute template reference' {
        $script:records = @((Rec 'ci-x.yaml' 'Pipeline'))
        $script:refs = @('/pipelines/steps/invoke-automation.yaml')
        @(Test-Pipelines -Path 'X:/pipelines') | Should -HaveCount 0
    }

    It 'reports a parse failure as its own violation' {
        $script:records = @((Rec 'ci-broken.yaml' -Classification 'Unknown' -ParseError 'bad indent at line 4'))
        $v = @(Test-Pipelines -Path 'X:/pipelines')
        $v.Rule | Should -Be 'ADR-PIPENAME:parse'
    }
}

Describe 'Test-Pipelines — real pipelines/ tree' -Tag 'L1', 'integrity' {
    It 'the shipped pipelines/ tree satisfies ADR-PIPENAME (zero violations)' {
        @(Test-Pipelines) | Should -HaveCount 0
    }
}
