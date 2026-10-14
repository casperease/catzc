# ConvertTo-PesterRunTarget over a fixture repository in $TestDrive (Get-RepositoryRoot and Get-GoTestFolders
# mocked): Go test folders become Go bridge containers, everything else stays a Pester path. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'ConvertTo-PesterRunTarget' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:bridge = Join-Path $script:repo 'automation/Catzc.Base.QualityGates/tests/Go.Bridge.ps1'
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($script:bridge))
        [System.IO.File]::WriteAllText($script:bridge, '# fixture bridge')
        $script:widgetGo = [System.IO.Path]::GetFullPath((Join-Path $script:repo 'go/tests/catzc-widget'))
        [void][System.IO.Directory]::CreateDirectory($script:widgetGo)
        function ConvertTo-Target {
            param([string[]] $Path, [string] $EntryScript)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $Path; EntryScript = $EntryScript } {
                param($Path, $EntryScript)
                ConvertTo-PesterRunTarget -Path $Path -EntryScript $EntryScript
            }
        }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-GoTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Module = 'Catzc.Widget'; Folder = $script:widgetGo; Name = 'catzc-widget' }
        }
    }

    It 'keeps test files and folders as paths, in order, and turns a Go test folder into a bridge container' {
        $target = ConvertTo-Target -Path 'C:\x\Widget.Tests.ps1', "$script:widgetGo/", 'C:\x\gadget\tests' -EntryScript 'C:\build\Import-Catzc.ps1'
        $target.Path | Should -Be @('C:\x\Widget.Tests.ps1', 'C:\x\gadget\tests')
        $target.Container | Should -HaveCount 1
        $target.Container[0].Item.FullName | Should -Be ([System.IO.Path]::GetFullPath($script:bridge))
        $target.Container[0].Data['GoTestFolder'] | Should -Be $script:widgetGo
        $target.Container[0].Data['EntryScript'] | Should -Be 'C:\build\Import-Catzc.ps1'
    }

    It 'hands the bridge an empty entry script in the source run' {
        $target = ConvertTo-Target -Path $script:widgetGo
        $target.Path | Should -HaveCount 0
        $target.Container[0].Data['EntryScript'] | Should -Be ''
    }
}
