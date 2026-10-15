<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-RelativesFileMetaFact.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#10
---
#>

Describe 'Get-RelativesFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#10', 'ADR-PRIN-CONFIG#1' {
    BeforeAll {
        $script:slots = @(
            @{ name = 'page'; rules = @(@{ files = @('**/*'); paths = @('{page}') }) }
            @{ name = 'test'; rules = @(@{ files = @('widgets/Catzc.*/*.ps1'); paths = @('widgets/{module}/tests/{stem}.Tests.ps1') }) }
            @{ name = 'source'; rules = @(@{ files = @('widgets/Catzc.*/tests/*.Tests.ps1'); paths = @('widgets/{module}/{stem}.ps1', 'widgets/{module}/private/{stem}.ps1') }) }
        )

        function script:Get-Kind {
            param($Slots = $script:slots)
            [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                    kinds = [ordered]@{ relatives = @{ settings = @{ slots = $Slots } } }
                }).kinds[0]
        }

        function script:Get-Relatives {
            param([string] $Path, $Kind = (Get-Kind))
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $Kind; Path = $Path; Root = $TestDrive } {
                param($Kind, $Path, $Root)
                Mock Get-RepositoryRoot { $Root }
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

    It 'names the page and the test of a function file, in slot order, when both exist' {
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

    It 'leaves a slot out when its file does not exist, so the map can be empty' {
        New-File 'widgets/Catzc.Gadget/Get-Lonely.ps1'
        (Get-Relatives 'widgets/Catzc.Gadget/Get-Lonely.ps1').Count | Should -Be 0
    }

    It 'refuses more than eight slots' {
        $many = 1..9 | ForEach-Object { @{ name = "slot$_"; rules = @(@{ files = @('**/*'); paths = @('nowhere') }) } }
        { Get-Relatives 'widgets/Catzc.Gadget/Get-Cog.ps1' (Get-Kind $many) } | Should -Throw '*at most 8 are allowed*'
    }

    It 'rejects a slot without rules' {
        { Get-Relatives 'widgets/Catzc.Gadget/Get-Cog.ps1' (Get-Kind @(@{ name = 'page' })) } | Should -Throw "*entries need 'name' and 'rules'*"
    }
}
