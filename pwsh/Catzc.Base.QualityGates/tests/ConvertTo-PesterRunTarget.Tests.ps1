<#
---
catzc:
  immutable:
    with_body_sha: b0f64e403e88
  edges:
    docs: "[ConvertTo-PesterRunTarget.Tests.ps1.md](docs/references/pwsh/catzc-base-quality-gates/tests/ConvertTo-PesterRunTarget.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/private/ConvertTo-PesterRunTarget.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

Describe 'ConvertTo-PesterRunTarget' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:bridge = Join-Path $script:repo 'widget-modules/Catzc.Base.QualityGates/tests/Language.Bridge.ps1'
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($script:bridge))
        [System.IO.File]::WriteAllText($script:bridge, '# fixture bridge')
        $script:widgetGo = [System.IO.Path]::GetFullPath((Join-Path $script:repo 'go/tests/catzc-widget'))
        $script:widgetPython = [System.IO.Path]::GetFullPath((Join-Path $script:repo 'python/tests/catzc-widget'))
        [void][System.IO.Directory]::CreateDirectory($script:widgetGo)
        [void][System.IO.Directory]::CreateDirectory($script:widgetPython)
        function ConvertTo-Target {
            param([string[]] $Path, [string] $EntryScript, [hashtable] $LanguageExecutable = @{})
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $Path; EntryScript = $EntryScript; LanguageExecutable = $LanguageExecutable } {
                param($Path, $EntryScript, $LanguageExecutable)
                ConvertTo-PesterRunTarget -Path $Path -EntryScript $EntryScript -LanguageExecutable $LanguageExecutable
            }
        }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.QualityGates { Join-Path $script:repo 'widget-modules' }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Language = 'go'; Module = 'Catzc.Widget'; Folder = $script:widgetGo; Name = 'catzc-widget' }
            [pscustomobject]@{ Language = 'python'; Module = 'Catzc.Widget'; Folder = $script:widgetPython; Name = 'catzc-widget' }
        }
    }

    It 'keeps test files and folders as paths, in order, and turns each language test folder into a bridge container' {
        $target = ConvertTo-Target -Path 'C:\x\Widget.Tests.ps1', "$script:widgetGo/", 'C:\x\gadget\tests', $script:widgetPython `
            -EntryScript 'C:\build\Import-Catzc.ps1' -LanguageExecutable @{ go = 'C:\widget\go\bin\go.exe'; python = 'C:\widget\uv\uv.exe'; bash = 'C:\widget\bash\bash.exe' }
        $target.Path | Should -Be @('C:\x\Widget.Tests.ps1', 'C:\x\gadget\tests')
        $target.Container | Should -HaveCount 2
        $target.Container[0].Item.FullName | Should -Be ([System.IO.Path]::GetFullPath($script:bridge))
        $target.Container[0].Data['Language'] | Should -Be 'go'
        $target.Container[0].Data['TestFolder'] | Should -Be $script:widgetGo
        $target.Container[0].Data['EntryScript'] | Should -Be 'C:\build\Import-Catzc.ps1'
        $target.Container[0].Data['Executable'] | Should -Be 'C:\widget\go\bin\go.exe'
        $target.Container[1].Data['Language'] | Should -Be 'python'
        $target.Container[1].Data['TestFolder'] | Should -Be $script:widgetPython
        $target.Container[1].Data['Executable'] | Should -Be 'C:\widget\uv\uv.exe'
        $pwsh = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
        $otherEngines = @([Catzc.Base.Engines.ExecutionEngines]::Names | Where-Object { $_ -ne $pwsh })
        $target.Container[0].Data['EngineExecutable']['bash'] | Should -Be 'C:\widget\bash\bash.exe'
        @($target.Container[0].Data['EngineExecutable'].Keys | Sort-Object) | Should -Be @($otherEngines | Sort-Object)
    }

    It 'hands the bridge an empty executable for an engine the source session did not locate' {
        $target = ConvertTo-Target -Path $script:widgetGo -LanguageExecutable @{ go = 'C:\widget\go\bin\go.exe'; bash = 'C:\widget\bash\bash.exe' }
        $engineExecutable = $target.Container[0].Data['EngineExecutable']
        foreach ($engine in @([Catzc.Base.Engines.ExecutionEngines]::Names | Where-Object { $_ -notin [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name, 'bash' })) {
            $engineExecutable[$engine] | Should -BeExactly ''
        }
        $engineExecutable.ContainsKey([Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name) | Should -BeFalse
    }

    It 'hands the bridge an empty entry script in the source run, and an empty tool when there is none' {
        $target = ConvertTo-Target -Path $script:widgetGo
        $target.Path | Should -HaveCount 0
        $target.Container[0].Data['EntryScript'] | Should -Be ''
        $target.Container[0].Data['Executable'] | Should -Be ''
    }
}
