<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-RelativesFileMetaFact.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Get-RelativesFileMetaFact.ps1
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#10
---
#>

Describe 'Get-RelativesFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#10', 'ADR-PRIN-CONFIG#1' {
    BeforeAll {
        $script:kinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{
                kinds = [ordered]@{
                    'widget-test'     = [ordered]@{ definition = 'A widget test.'; files = @('widgets/Catzc.*/tests/*.Tests.ps1') }
                    'widget-function' = [ordered]@{ definition = 'A widget function.'; files = @('widgets/Catzc.*/*.ps1', 'widgets/Catzc.*/private/*.ps1') }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'file-kinds' } { $script:kinds }

        $script:relations = @(
            @{ name = 'page'; rules = @(@{ paths = @('{page}') }) }
            @{ name = 'test'; rules = @(@{ classes = @('widget-function'); paths = @('widgets/{module}/tests/{stem}.Tests.ps1') }) }
            @{ name = 'source'; rules = @(@{ classes = @('widget-test'); paths = @('widgets/{module}/{stem}.ps1', 'widgets/{module}/private/{stem}.ps1') }) }
        )

        function script:Get-Kind {
            param($Relations = $script:relations)
            [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                    kinds = [ordered]@{ relatives = @{ settings = @{ relations = $Relations } } }
                }).kinds[0]
        }

        function script:Get-Relatives {
            param([string] $Path, $Kind = (Get-Kind))
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $Kind; Path = $Path; Root = $TestDrive } {
                param($Kind, $Path, $Root)
                Mock Get-RepositoryRoot { $Root }
                # The fixture modules live under widgets/, which is no track of the shipped registry; the resolver's own tests prove the real rule.
                Mock Get-PathModule { (($Path -replace '\\', '/') -split '/')[1] }
                Mock Get-Config { [Catzc.Base.QualityGates.CommentsConfig]::new(@{ pages = @(@{ source = 'widgets/*'; docs = 'docs/{kebab}' }) }) }
                (Get-RelativesFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind)['relatives']
            }
        }

        function script:New-File {
            param([string] $Relative)
            $full = Join-Path $TestDrive $Relative
            New-Item -ItemType Directory -Path (Split-Path $full) -Force | Out-Null
            Set-Content -LiteralPath $full -Value 'x'
        }
    }

    It 'names the page and the test of a function file, in the order declared, when both exist' {
        New-File 'widgets/Catzc.Gadget/Get-Cog.ps1'
        New-File 'widgets/Catzc.Gadget/tests/Get-Cog.Tests.ps1'
        New-File 'docs/catzc-gadget/Get-Cog.ps1.md'
        $relatives = Get-Relatives 'widgets/Catzc.Gadget/Get-Cog.ps1'
        @($relatives.Keys) | Should -Be @('page', 'test')
        $relatives['page'] | Should -BeExactly 'docs/catzc-gadget/Get-Cog.ps1.md'
        $relatives['test'] | Should -BeExactly 'widgets/Catzc.Gadget/tests/Get-Cog.Tests.ps1'
    }

    It 'names the first source candidate that exists for a test file' {
        New-File 'widgets/Catzc.Gadget/private/Get-Sprocket.ps1'
        New-File 'widgets/Catzc.Gadget/tests/Get-Sprocket.Tests.ps1'
        $relatives = Get-Relatives 'widgets/Catzc.Gadget/tests/Get-Sprocket.Tests.ps1'
        @($relatives.Keys) | Should -Be @('source')
        $relatives['source'] | Should -BeExactly 'widgets/Catzc.Gadget/private/Get-Sprocket.ps1'
    }

    It 'applies a rule only to the classes it names' {
        New-File 'widgets/Catzc.Gadget/tests/Get-Spring.Tests.ps1'
        (Get-Relatives 'widgets/Catzc.Gadget/tests/Get-Spring.Tests.ps1').Contains('test') | Should -BeFalse -Because 'a test file is no widget-function'
    }

    It 'leaves a relation out when its file does not exist, so the map can be empty' {
        New-File 'widgets/Catzc.Gadget/Get-Lonely.ps1'
        (Get-Relatives 'widgets/Catzc.Gadget/Get-Lonely.ps1').Count | Should -Be 0
    }

    It 'refuses more than eight relations' {
        $many = 1..9 | ForEach-Object { @{ name = "relation$_"; rules = @(@{ paths = @('nowhere') }) } }
        { Get-Relatives 'widgets/Catzc.Gadget/Get-Cog.ps1' (Get-Kind $many) } | Should -Throw '*at most 8 are allowed*'
    }

    It 'rejects a relation without rules' {
        { Get-Relatives 'widgets/Catzc.Gadget/Get-Cog.ps1' (Get-Kind @(@{ name = 'page' })) } | Should -Throw "*entries need 'name' and 'rules'*"
    }
}
