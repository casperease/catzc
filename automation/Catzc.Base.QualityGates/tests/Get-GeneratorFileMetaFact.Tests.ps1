<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-GeneratorFileMetaFact.Tests.ps1
    folder: tests
    name: get-generator-file-meta-fact-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-FILEMETA#7
---
#>

Describe 'Get-GeneratorFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#7' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        New-Item -ItemType Directory -Path (Join-Path $script:root 'automation/Widget') -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $script:root 'automation/Widget/Build-Widget.ps1') -Value '# widget'
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:root }

        function script:Get-Fact {
            param([hashtable] $Raw)
            $kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ generator = $Raw } }).kinds[0]
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $kind } {
                param($Kind)
                Get-GeneratorFileMetaFact -State ([pscustomobject]@{}) -Path 'docs/references/widget.ps1.md' -Kind $Kind
            }
        }
    }

    It 'names the path the generator setting holds, under the kind''s key' {
        $fact = Get-Fact @{ settings = @{ generator = 'automation/Widget/Build-Widget.ps1' } }
        @($fact.Keys) | Should -Be @('generator')
        $fact['generator'] | Should -BeExactly 'automation/Widget/Build-Widget.ps1'
    }

    It 'writes the path with forward slashes' {
        $fact = Get-Fact @{ settings = @{ generator = 'automation\Widget\Build-Widget.ps1' } }
        $fact['generator'] | Should -BeExactly 'automation/Widget/Build-Widget.ps1'
    }

    It 'throws when the kind has no generator setting' {
        { Get-Fact @{ select = @(@{ classes = @('widget') }) } } | Should -Throw "*needs a 'generator' setting*"
    }

    It 'throws when the file the setting names does not exist' {
        { Get-Fact @{ settings = @{ generator = 'automation/Widget/Build-Gone.ps1' } } } | Should -Throw
    }
}
