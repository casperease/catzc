<#
---
catzc:
  immutable:
    with_body_sha: ea21550fd7c2
  edges:
    docs: "[Test-Pipelines.Tests.ps1.md](../../../docs/references/pwsh/catzc-azure-dev-ops/tests/Test-Pipelines.Tests.ps1.md)"
    code: pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1
    cites:
      - ADR-ADO-NAME
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS
      - FDR-CD-PIPELINE-TYPEPREFIX
      - FDR-CD-PIPELINE-EXECUTABLEYAMLEXTENSION
---
#>

Describe 'Test-Pipelines' -Tag 'L0', 'logic' {
    BeforeAll {
        # Build a classifier record like Get-AdoYamlFiles emits (string props stand in for the C# record).
        function New-PipelineRecord {
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
            (New-PipelineRecord 'ci-automation.yaml' 'Pipeline')
            (New-PipelineRecord 'cd-shared.yaml' 'Pipeline')
            (New-PipelineRecord 'steps/invoke-automation.yaml' -Classification 'Template' -TemplateType 'Steps')
            (New-PipelineRecord 'extends/cd-customer.yaml' -Classification 'Template' -TemplateType 'Stages')
        )
        { Test-Pipelines -Path 'X:/pipelines' -OutputFolder (Join-Path $TestDrive 'pipelines') } | Should -Not -Throw
    }

    It 'throws once listing every violation' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $script:records = @((New-PipelineRecord 'widget-thing.yaml' 'Pipeline'), (New-PipelineRecord 'ci-gadget.yml' 'Pipeline'))
        $thrown = { Test-Pipelines -Path 'X:/pipelines' -OutputFolder (Join-Path $TestDrive 'pipelines') } |
            Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Pipelines failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -Match 'FDR-CD-PIPELINE-TYPEPREFIX'
        $thrown.Exception.Message | Should -Match 'FDR-CD-PIPELINE-EXECUTABLEYAMLEXTENSION'
    }

    It 'returns the result with the file count under -PassThru' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $script:records = @((New-PipelineRecord 'widget-thing.yaml' 'Pipeline'), (New-PipelineRecord 'ci-gadget.yaml' 'Pipeline'))
        $result = Test-Pipelines -Path 'X:/pipelines' -PassThru -OutputFolder (Join-Path $TestDrive 'pipelines')
        $result.Subject | Should -Be 'pipelines'
        $result.IssueCount | Should -Be 1
        $result.Facts['Files'] | Should -Be 2
        $result.Issues[0] | Should -BeLike '`[FDR-CD-PIPELINE-TYPEPREFIX`] .ado/pipelines/widget-thing.yaml: *'
    }

    It 'flags a root pipeline whose name lacks a valid type prefix (FDR-CD-PIPELINE-TYPEPREFIX)' {
        $script:records = @((New-PipelineRecord 'widget-thing.yaml' 'Pipeline'))
        $v = @(Get-Issues)
        $v | Should -HaveCount 1
        $v[0] | Should -Match 'FDR-CD-PIPELINE-TYPEPREFIX'
    }

    It 'accepts every sanctioned type prefix' {
        $script:records = @('cron', 'ci', 'cd', 'cde', 'deploy', 'input' | ForEach-Object { New-PipelineRecord "$_-x.yaml" 'Pipeline' })
        Get-Issues | Should -HaveCount 0
    }

    It 'flags a .yml executable under .ado/pipelines/ (FDR-CD-PIPELINE-EXECUTABLEYAMLEXTENSION)' {
        $script:records = @((New-PipelineRecord 'ci-thing.yml' 'Pipeline'))
        Get-Issues | Should -Match 'FDR-CD-PIPELINE-EXECUTABLEYAMLEXTENSION'
    }

    It 'flags a template in an unsanctioned folder (ADR-ADO-NAME-TEMPLATEKINDFOLDER)' {
        $script:records = @((New-PipelineRecord 'widgets/x.yaml' -Classification 'Template' -TemplateType 'Steps'))
        Get-Issues | Should -Match 'ADR-ADO-NAME-TEMPLATEKINDFOLDER'
    }

    It 'flags a template nested deeper than one level (ADR-ADO-NAME-FLATPIPELINESFOLDER)' {
        $script:records = @((New-PipelineRecord 'steps/sub/x.yaml' -Classification 'Template' -TemplateType 'Steps'))
        Get-Issues | Should -Match 'ADR-ADO-NAME-FLATPIPELINESFOLDER'
    }

    It 'flags a structural pipeline hiding inside a template folder (ADR-ADO-NAME-FLATPIPELINESFOLDER)' {
        $script:records = @((New-PipelineRecord 'steps/sneaky.yaml' 'Pipeline'))
        Get-Issues | Should -Match 'ADR-ADO-NAME-FLATPIPELINESFOLDER'
    }

    It 'flags a fragment whose kind does not match its folder (ADR-ADO-NAME-TEMPLATEKINDFOLDER)' {
        $script:records = @((New-PipelineRecord 'steps/x.yaml' -Classification 'Template' -TemplateType 'Jobs'))
        Get-Issues | Should -Match 'ADR-ADO-NAME-TEMPLATEKINDFOLDER'
    }

    It 'does not subtype-check the extends/ folder (whole-pipeline templates)' {
        $script:records = @((New-PipelineRecord 'extends/cd-customer.yaml' -Classification 'Template' -TemplateType 'Jobs'))
        Get-Issues | Should -HaveCount 0
    }

    It 'flags a relative template reference (ADR-ADO-NAME-ABSOLUTETEMPLATEPATH)' {
        $script:records = @((New-PipelineRecord 'ci-x.yaml' 'Pipeline'))
        $script:refs = @('steps/local.yaml')
        Get-Issues | Should -Match 'ADR-ADO-NAME-ABSOLUTETEMPLATEPATH'
    }

    It 'accepts an absolute template reference' {
        $script:records = @((New-PipelineRecord 'ci-x.yaml' 'Pipeline'))
        $script:refs = @('/.ado/pipelines/steps/invoke-automation.yaml')
        Get-Issues | Should -HaveCount 0
    }

    It 'reports a parse failure as its own violation' {
        $script:records = @((New-PipelineRecord 'ci-broken.yaml' -Classification 'Unknown' -ParseError 'bad indent at line 4'))
        Get-Issues | Should -BeLike '`[ADR-ADO-NAME`] .ado/pipelines/ci-broken.yaml: YAML failed to parse: bad indent at line 4'
    }
}

Describe 'Test-Pipelines — real .ado/pipelines/ tree' -Tag 'L1', 'integrity' {
    It 'the shipped .ado/pipelines/ tree satisfies ADR-ADO-NAME (zero violations)' {
        (Test-Pipelines -PassThru -OutputFolder (Join-Path $TestDrive 'pipelines')).IssueCount | Should -Be 0
    }
}
