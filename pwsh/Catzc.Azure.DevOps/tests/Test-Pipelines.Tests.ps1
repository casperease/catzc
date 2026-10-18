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

        # The gate's issues for the current fixture, through -PassThru (the report goes to $TestDrive).
        function Get-Issues {
            @((Test-Pipelines -Path 'X:/pipelines' -PassThru -OutputFolder (Join-Path $TestDrive 'pipelines')).Issues)
        }
    }

    BeforeEach {
        $script:records = @()
        $script:refs = @()

        Mock Get-AdoYamlFiles -ModuleName Catzc.Azure.DevOps { $script:records }
        Mock Get-PipelineTemplateReference -ModuleName Catzc.Azure.DevOps { $script:refs }
        Mock Assert-PathExist -ModuleName Catzc.Azure.DevOps { }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'passes a compliant tree with no violations' {
        $script:records = @(
            (Rec 'ci-automation.yaml' 'Pipeline')
            (Rec 'cd-shared.yaml' 'Pipeline')
            (Rec 'steps/invoke-automation.yaml' -Classification 'Template' -TemplateType 'Steps')
            (Rec 'extends/cd-customer.yaml' -Classification 'Template' -TemplateType 'Stages')
        )
        { Test-Pipelines -Path 'X:/pipelines' -OutputFolder (Join-Path $TestDrive 'pipelines') } | Should -Not -Throw
    }

    It 'throws once listing every violation' -Tag 'ADR-AUTO-TEST#35' {
        $script:records = @((Rec 'widget-thing.yaml' 'Pipeline'), (Rec 'ci-gadget.yml' 'Pipeline'))
        $thrown = { Test-Pipelines -Path 'X:/pipelines' -OutputFolder (Join-Path $TestDrive 'pipelines') } |
            Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Pipelines failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -Match 'ADR-PIPE-NAME#1'
        $thrown.Exception.Message | Should -Match 'ADR-PIPE-NAME#6'
    }

    It 'returns the result with the file count under -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        $script:records = @((Rec 'widget-thing.yaml' 'Pipeline'), (Rec 'ci-gadget.yaml' 'Pipeline'))
        $result = Test-Pipelines -Path 'X:/pipelines' -PassThru -OutputFolder (Join-Path $TestDrive 'pipelines')
        $result.Subject | Should -Be 'pipelines'
        $result.IssueCount | Should -Be 1
        $result.Facts['Files'] | Should -Be 2
        $result.Issues[0] | Should -BeLike '`[ADR-PIPE-NAME#1`] pipelines/widget-thing.yaml: *'
    }

    It 'flags a root pipeline whose name lacks a valid type prefix (ADR-PIPE-NAME#1)' {
        $script:records = @((Rec 'widget-thing.yaml' 'Pipeline'))
        $v = @(Get-Issues)
        $v | Should -HaveCount 1
        $v[0] | Should -Match 'ADR-PIPE-NAME#1'
    }

    It 'accepts every sanctioned type prefix' {
        $script:records = @('cron', 'ci', 'cd', 'cde', 'deploy', 'input' | ForEach-Object { Rec "$_-x.yaml" 'Pipeline' })
        Get-Issues | Should -HaveCount 0
    }

    It 'flags a .yml executable under pipelines/ (ADR-PIPE-NAME#6)' {
        $script:records = @((Rec 'ci-thing.yml' 'Pipeline'))
        Get-Issues | Should -Match 'ADR-PIPE-NAME#6'
    }

    It 'flags a template in an unsanctioned folder (ADR-PIPE-NAME#3)' {
        $script:records = @((Rec 'widgets/x.yaml' -Classification 'Template' -TemplateType 'Steps'))
        Get-Issues | Should -Match 'ADR-PIPE-NAME#3'
    }

    It 'flags a template nested deeper than one level (ADR-PIPE-NAME#2)' {
        $script:records = @((Rec 'steps/sub/x.yaml' -Classification 'Template' -TemplateType 'Steps'))
        Get-Issues | Should -Match 'ADR-PIPE-NAME#2'
    }

    It 'flags a structural pipeline hiding inside a template folder (ADR-PIPE-NAME#2)' {
        $script:records = @((Rec 'steps/sneaky.yaml' 'Pipeline'))
        Get-Issues | Should -Match 'ADR-PIPE-NAME#2'
    }

    It 'flags a fragment whose kind does not match its folder (ADR-PIPE-NAME#3)' {
        $script:records = @((Rec 'steps/x.yaml' -Classification 'Template' -TemplateType 'Jobs'))
        Get-Issues | Should -Match 'ADR-PIPE-NAME#3'
    }

    It 'does not subtype-check the extends/ folder (whole-pipeline templates)' {
        $script:records = @((Rec 'extends/cd-customer.yaml' -Classification 'Template' -TemplateType 'Jobs'))
        Get-Issues | Should -HaveCount 0
    }

    It 'flags a relative template reference (ADR-PIPE-NAME#4)' {
        $script:records = @((Rec 'ci-x.yaml' 'Pipeline'))
        $script:refs = @('steps/local.yaml')
        Get-Issues | Should -Match 'ADR-PIPE-NAME#4'
    }

    It 'accepts an absolute template reference' {
        $script:records = @((Rec 'ci-x.yaml' 'Pipeline'))
        $script:refs = @('/pipelines/steps/invoke-automation.yaml')
        Get-Issues | Should -HaveCount 0
    }

    It 'reports a parse failure as its own violation' {
        $script:records = @((Rec 'ci-broken.yaml' -Classification 'Unknown' -ParseError 'bad indent at line 4'))
        Get-Issues | Should -Match 'ADR-PIPE-NAME:parse'
    }
}

Describe 'Test-Pipelines — real pipelines/ tree' -Tag 'L1', 'integrity' {
    It 'the shipped pipelines/ tree satisfies ADR-PIPE-NAME (zero violations)' {
        (Test-Pipelines -PassThru -OutputFolder (Join-Path $TestDrive 'pipelines')).IssueCount | Should -Be 0
    }
}
