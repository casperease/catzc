BeforeAll {
    . (Join-Path $PSScriptRoot 'Pipelines.Fixture.ps1')
}

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

        # Isolated through the classifier and reference-scan seams, so records and refs are the only inputs.
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
        $script:records = @((New-PipelineRecord 'widget-thing.yaml' 'Pipeline'),
            (New-PipelineRecord 'ci-gadget.yml' 'Pipeline'))
        $thrown = { Test-Pipelines -Path 'X:/pipelines' -OutputFolder (Join-Path $TestDrive 'pipelines') } |
            Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Pipelines failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -Match 'FDR-PIPELINE-TYPEPREFIX'
        $thrown.Exception.Message | Should -Match 'FDR-PIPELINE-EXECUTABLEYAMLEXTENSION'
    }

    It 'returns the result with the file count under -PassThru' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $script:records = @((New-PipelineRecord 'widget-thing.yaml' 'Pipeline'),
            (New-PipelineRecord 'ci-gadget.yaml' 'Pipeline'))
        $result = Test-Pipelines -Path 'X:/pipelines' -PassThru -OutputFolder (Join-Path $TestDrive 'pipelines')
        $result.Subject | Should -Be 'pipelines'
        $result.IssueCount | Should -Be 1
        $result.Facts['Files'] | Should -Be 2
        $result.Issues[0] | Should -BeLike '`[FDR-PIPELINE-TYPEPREFIX`] .ado/pipelines/widget-thing.yaml: *'
    }

    It 'flags a root pipeline whose name lacks a valid type prefix (FDR-PIPELINE-TYPEPREFIX)' {
        $script:records = @((New-PipelineRecord 'widget-thing.yaml' 'Pipeline'))
        $v = @(Get-Issues)
        $v | Should -HaveCount 1
        $v[0] | Should -Match 'FDR-PIPELINE-TYPEPREFIX'
    }

    It 'accepts every sanctioned type prefix' {
        $script:records = @('cron', 'ci', 'cd', 'cde', 'deploy',
            'input' | ForEach-Object { New-PipelineRecord "$_-x.yaml" 'Pipeline' })
        Get-Issues | Should -HaveCount 0
    }

    It 'flags a .yml executable under .ado/pipelines/ (FDR-PIPELINE-EXECUTABLEYAMLEXTENSION)' {
        $script:records = @((New-PipelineRecord 'ci-thing.yml' 'Pipeline'))
        Get-Issues | Should -Match 'FDR-PIPELINE-EXECUTABLEYAMLEXTENSION'
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

    It 'flags a relative template reference (ADR-ADO-TEMPLATE-ABSOLUTEPATHS)' {
        $script:records = @((New-PipelineRecord 'ci-x.yaml' 'Pipeline'))
        $script:refs = @('steps/local.yaml')
        Get-Issues | Should -Match 'ADR-ADO-TEMPLATE-ABSOLUTEPATHS'
    }

    It 'accepts an absolute template reference' {
        $script:records = @((New-PipelineRecord 'ci-x.yaml' 'Pipeline'))
        $script:refs = @('/.ado/pipelines/steps/invoke-automation.yaml')
        Get-Issues | Should -HaveCount 0
    }

    It 'reports a parse failure as its own violation' {
        $script:records = @((New-PipelineRecord 'ci-broken.yaml' -Classification 'Unknown' -ParseError 'bad indent at line 4'))
        Get-Issues |
            Should -BeLike '`[ADR-ADO-NAME`] .ado/pipelines/ci-broken.yaml: YAML failed to parse: bad indent at line 4'
    }
}

Describe 'the service-connection finder' -Tag 'L0', 'logic' {
    It 'reads each target entry''s identity from its list, and a step''s from what it runs' {
        $path = Join-Path $TestDrive 'widget.yaml'
        [System.IO.File]::WriteAllText($path, @(
                'Foundations:'
                '  - { env: widget, serviceConnection: sc-widget-lz, subscriptionIdAssertIs: 00000000-0000-0000-0000-00000000000a }'
                'Expeditions:'
                '  - { env: gadget, serviceConnection: sc-widget-wl, subscriptionIdAssertIs: 00000000-0000-0000-0000-00000000000a }'
                'steps:'
                '  - template: /.ado/pipelines/steps/invoke-automation.yaml'
                '    parameters:'
                '      ServiceConnection: sc-widget-vault'
                '      RunCommand: Invoke-BreakGlassRotation widget'
                '  - template: /.ado/pipelines/steps/invoke-automation.yaml'
                '    parameters:'
                '      ServiceConnection: sc-widget-ro'
                '      RunCommand: Get-Widget'
                '  - template: /.ado/pipelines/steps/invoke-automation.yaml'
                '    parameters:'
                '      ServiceConnection: ${{ f.serviceConnection }}'
                '      RunCommand: Get-Gadget'
            ) -join "`n")
        $uses = @(& $script:findServiceConnectionUses $path $script:vaultCommands)
        @($uses | ForEach-Object { "$($_.Connection)=$($_.Needs)" }) |
            Should -Be @('sc-widget-lz=landing-zone', 'sc-widget-wl=workload', 'sc-widget-vault=landing-zone', 'sc-widget-ro=read-only')
        $uses[0].Subscription | Should -Be '00000000-0000-0000-0000-00000000000a'
        $uses[3].Subscription | Should -BeNullOrEmpty
    }
}

Describe 'the production-target finder' -Tag 'L0', 'logic' {
    It 'lists the targets pinned to a production subscription and ignores the rest' {
        $path = Join-Path $TestDrive 'widget.yaml'
        [System.IO.File]::WriteAllText($path, @(
                'Foundations:'
                '  - { env: widget, subscriptionIdAssertIs: 00000000-0000-0000-0000-00000000000a }'
                '  - { env: gadget, subscriptionIdAssertIs: 00000000-0000-0000-0000-00000000000b }'
            ) -join "`n")
        & $script:findProductionTargets $path @('00000000-0000-0000-0000-00000000000b') | Should -Be @('gadget')
        & $script:findProductionTargets $path @() | Should -BeNullOrEmpty
    }
}

Describe 'the network-pool guard on vault writes' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:poolYaml = {
            param([string] $Pool, [string] $Command, [switch] $Include)
            $path = Join-Path $TestDrive "$([guid]::NewGuid().ToString('N')).yaml"
            $variables = if ($Include) {
                "variables:`n  - template: $script:networkPoolInclude`n"
            }
            [System.IO.File]::WriteAllText($path, "$variables" + (@(
                        'jobs:'
                        '  - job: widget'
                        '    displayName: widget'
                        "    pool:`n      $Pool"
                        '    steps:'
                        '      - template: /.ado/pipelines/steps/invoke-automation.yaml'
                        "        parameters:`n          RunCommand: $Command gadget"
                    ) -join "`n"))
            $path
        }
    }

    It 'flags a new vault-writing job on a Microsoft-hosted agent' {
        $path = & $script:poolYaml -Pool 'vmImage: ubuntu-latest' -Command 'Invoke-BreakGlassRotation' -Include
        & $script:findVaultJobsOffPool $path $script:vaultCommands | Should -Be @('widget')
    }

    It 'flags a vault-writing job on the pool variable in a file without the variable template' {
        $path = & $script:poolYaml -Pool 'name: ${{ variables.NetworkAgentPool }}' -Command 'Set-AnomalyAlertRecipientSecret'
        & $script:findVaultJobsOffPool $path $script:vaultCommands | Should -Be @('widget')
    }

    It 'passes a vault-writing job on the declared pool, and any job that writes no vault' {
        $vault = & $script:poolYaml -Pool 'name: ${{ variables.NetworkAgentPool }}' -Command 'Set-AnomalyAlertRecipientSecret' -Include
        & $script:findVaultJobsOffPool $vault $script:vaultCommands | Should -BeNullOrEmpty
        $other = & $script:poolYaml -Pool 'vmImage: ubuntu-latest' -Command 'Deploy-Bicep'
        & $script:findVaultJobsOffPool $other $script:vaultCommands | Should -BeNullOrEmpty
    }
}

Describe 'the what-if guard on pipeline deploys' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:widgetYaml = {
            param([string[]] $Steps)
            $path = Join-Path $TestDrive "$([guid]::NewGuid().ToString('N')).yaml"
            [System.IO.File]::WriteAllText($path, (@('steps:') + @($Steps | ForEach-Object {
                            "  - template: /.ado/pipelines/steps/invoke-automation.yaml`n    parameters:`n      RunCommand: '$_'"
                        })) -join "`n")
            $path
        }
    }

    It 'flags a Deploy-Bicep step with no -DryRun sibling before it' {
        $found = & $script:findDeploysWithoutDryRun (& $script:widgetYaml @('Deploy-Bicep -Environment widget -Template gadget'))
        $found.Deploys | Should -Be 1
        $found.Missing | Should -Be @('Deploy-Bicep -Environment widget -Template gadget')
    }

    It 'flags a sibling that previews another command, and passes the matching one' {
        $other = & $script:findDeploysWithoutDryRun (& $script:widgetYaml @('Deploy-Bicep -Template sprocket -DryRun', 'Deploy-Bicep -Template gadget'))
        $other.Missing | Should -Be @('Deploy-Bicep -Template gadget')
        $match = & $script:findDeploysWithoutDryRun (& $script:widgetYaml @('Deploy-Bicep -Template gadget -DryRun', 'Deploy-Bicep -Template gadget'))
        $match.Missing | Should -BeNullOrEmpty
    }
}
