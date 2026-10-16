<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1
    folder: tests
    name: test-file-meta-processors-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/Test-FileMetaProcessors.Tests.ps1.md
    cites:
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
            $all = [ordered]@{ 'file-path' = @{ keys = @('path') }; 'file-kind' = @{ keys = @('kind') }; 'file-language' = @{ keys = @('language') }; 'file-type' = @{ keys = @('filetype') }; track = @{}; generator = @{}; 'body-sha' = @{ keys = @('with_body_sha') }; 'repo-status' = @{ keys = @('repo_status') }; 'track-type' = @{ keys = @('tracktype') }; vendor = @{ keys = @('vendor') };'adr-defines' = @{ keys = @('defines'); section = 'edges' }; 'adr-codes' = @{ keys = @('cites'); section = 'edges' }; links = @{ section = 'edges' }; 'module-name' = @{ keys = @('module') }; 'module-type' = @{ keys = @('moduletype') }; 'catzc-bundle' = @{}; 'file-name' = @{ keys = @('folder', 'name') }; visibility = @{ keys = @('visibility') }; 'relative-edges' = @{ keys = @('page', 'test'); section = 'edges' } }
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
        $result.KindCount | Should -Be 20
        $result.IssueCount | Should -Be 1
        $result.ProcessorCount | Should -Be 21
    }
}

Describe 'File meta processor coverage' -Tag 'L0', 'integrity', 'ADR-REPO-FILEMETA#4' {
    It 'every kind of the shipped registry has its function and every processor function has its kind' {
        $result = Test-FileMetaProcessors -PassThru -OutputFolder (Join-Path $TestDrive 'file-meta-processors')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
