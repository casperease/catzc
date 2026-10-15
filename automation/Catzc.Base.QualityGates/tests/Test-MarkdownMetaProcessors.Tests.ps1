# Test-MarkdownMetaProcessors over in-memory registries and fixture processor functions defined in the module scope.
# Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-MarkdownMetaProcessors' -Tag 'L0', 'logic', 'ADR-REPO-MDMETA#4' {
    BeforeAll {
        InModuleScope Catzc.Base.QualityGates {
            function script:Get-WidgetMarkdownMetaFact {
            }
            function script:Get-GadgetMarkdownConfigContribution {
            }
        }

        # The gate sees every processor function of the module, so each fixture registry also names the shipped ones.
        function script:Invoke-Gate {
            param($Kinds, [switch] $PassThru)
            $all = [ordered]@{ 'document-kind' = @{ keys = @('kind') }; 'body-sha' = @{ keys = @('body_sha') }; 'adr-codes' = @{ keys = @('adrs') } }
            foreach ($id in $Kinds.Keys) {
                $all[$id] = $Kinds[$id]
            }
            $registry = [Catzc.Base.QualityGates.MarkdownMetaConfig]::new(@{ kinds = $all })
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Registry = $registry; Folder = (Join-Path $TestDrive 'out'); PassThru = $PassThru } {
                param($Registry, $Folder, $PassThru)
                Test-MarkdownMetaProcessors -Config $Registry -OutputFolder $Folder -PassThru:$PassThru
            }
        }
    }

    AfterAll {
        InModuleScope Catzc.Base.QualityGates {
            Remove-Item Function:\Get-WidgetMarkdownMetaFact, Function:\Get-GadgetMarkdownConfigContribution -ErrorAction Ignore
        }
    }

    BeforeEach {
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
    }

    It 'passes when every kind has its function and every function has its kind' {
        $kinds = [ordered]@{ widget = @{}; gadget = @{ direction = 'gather'; target = 'widgets' } }
        { Invoke-Gate $kinds } | Should -Not -Throw
    }

    It 'names a kind whose function does not exist' {
        $kinds = [ordered]@{ widget = @{}; gadget = @{ direction = 'gather'; target = 'widgets' }; sprocket = @{} }
        { Invoke-Gate $kinds } |
            Should -Throw "*kind 'sprocket' is subscribed by 'Get-SprocketMarkdownMetaFact', but no such function exists*"
    }

    It 'names a convention-named function no kind subscribes' {
        $kinds = [ordered]@{ widget = @{} }
        { Invoke-Gate $kinds } |
            Should -Throw '*Get-GadgetMarkdownConfigContribution is named like a meta processor, but no kind in the registry names it*'
    }

    It 'counts the kinds and the processor functions under -PassThru' {
        $kinds = [ordered]@{ widget = @{} }
        $result = Invoke-Gate $kinds -PassThru
        $result.Subject | Should -Be 'markdown-meta-processors'
        $result.KindCount | Should -Be 4
        $result.IssueCount | Should -Be 1
        $result.ProcessorCount | Should -Be 5
    }
}

Describe 'Markdown meta processor coverage' -Tag 'L0', 'integrity', 'ADR-REPO-MDMETA#4' {
    It 'every kind of the shipped registry has its function and every processor function has its kind' {
        $result = Test-MarkdownMetaProcessors -PassThru -OutputFolder (Join-Path $TestDrive 'markdown-meta-processors')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
