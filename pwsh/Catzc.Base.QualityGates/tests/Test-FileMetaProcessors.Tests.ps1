<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1
    folder: tests
    name: test-file-meta-processors-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Test-FileMetaProcessors.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/Test-FileMetaProcessors.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION
---
#>

Describe 'Test-FileMetaProcessors' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION' {
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
            $all = [ordered]@{ 'body-sha' = @{ keys = @('with_body_sha') }; 'adr-codes' = @{ keys = @('cites'); section = 'edges' }; 'relative-edges' = @{ keys = @('test', 'docs', 'code'); section = 'edges' } }
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
        $result.Facts['KindCount'] | Should -Be 19
        $result.IssueCount | Should -Be 1
        $result.Facts['ProcessorCount'] | Should -Be 20
    }
}

Describe 'File meta processor coverage' -Tag 'L0', 'integrity', 'ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION' {
    It 'every kind of the shipped registry has its function and every processor function has its kind' {
        $result = Test-FileMetaProcessors -PassThru -OutputFolder (Join-Path $TestDrive 'file-meta-processors')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
