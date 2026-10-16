<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Test-FileMetaProcessors.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/Test-FileMetaProcessors.ps1
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-FILEMETA#4
---
#>

Describe 'Test-FileMetaProcessors' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#4' {
    BeforeAll {
        InModuleScope Catzc.Base.QualityGates {
            function script:Get-WidgetFileMetaFact {
            }
            function script:Get-GadgetMarkdownConfigContribution {
            }
        }

        # The gate sees every processor function of the module, so each fixture registry also names the shipped ones.
        function script:Invoke-Gate {
            param($Kinds, [switch] $PassThru)
            $all = [ordered]@{ 'file-path' = @{ keys = @('path') }; 'file-kind' = @{ keys = @('kind') }; 'file-language' = @{ keys = @('language') }; 'file-extension' = @{ keys = @('filekind') }; track = @{}; generator = @{}; 'body-sha' = @{ keys = @('body_sha') }; 'adr-defines' = @{ keys = @('defines') }; 'adr-codes' = @{ keys = @('adrs') }; links = @{}; 'module-name' = @{ keys = @('module') }; visibility = @{ keys = @('visibility') }; relatives = @{} }
            foreach ($id in $Kinds.Keys) {
                $all[$id] = $Kinds[$id]
            }
            $registry = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = $all })
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Registry = $registry; Folder = (Join-Path $TestDrive 'out'); PassThru = $PassThru } {
                param($Registry, $Folder, $PassThru)
                Test-FileMetaProcessors -Config $Registry -OutputFolder $Folder -PassThru:$PassThru
            }
        }
    }

    AfterAll {
        InModuleScope Catzc.Base.QualityGates {
            Remove-Item Function:\Get-WidgetFileMetaFact, Function:\Get-GadgetMarkdownConfigContribution -ErrorAction Ignore
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
            Should -Throw "*kind 'sprocket' is subscribed by 'Get-SprocketFileMetaFact', but no such function exists*"
    }

    It 'names a convention-named function no kind subscribes' {
        $kinds = [ordered]@{ widget = @{} }
        { Invoke-Gate $kinds } |
            Should -Throw '*Get-GadgetMarkdownConfigContribution is named like a meta processor, but no kind in the registry names it*'
    }

    It 'counts the kinds and the processor functions under -PassThru' {
        $kinds = [ordered]@{ widget = @{} }
        $result = Invoke-Gate $kinds -PassThru
        $result.Subject | Should -Be 'file-meta-processors'
        $result.KindCount | Should -Be 14
        $result.IssueCount | Should -Be 1
        $result.ProcessorCount | Should -Be 15
    }
}

Describe 'File meta processor coverage' -Tag 'L0', 'integrity', 'ADR-REPO-FILEMETA#4' {
    It 'every kind of the shipped registry has its function and every processor function has its kind' {
        $result = Test-FileMetaProcessors -PassThru -OutputFolder (Join-Path $TestDrive 'file-meta-processors')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
