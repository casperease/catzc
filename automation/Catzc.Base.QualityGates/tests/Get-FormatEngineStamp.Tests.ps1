<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-FormatEngineStamp.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Get-FormatEngineStamp.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/private/Get-FormatEngineStamp.ps1
    adrs:
      - ADR-AUTO-CACHE#10
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-FormatEngineStamp' -Tag 'L0', 'logic', 'ADR-AUTO-CACHE#10' {
    BeforeAll {
        $script:root = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'stamp-repo'))
        $null = New-Item -ItemType Directory -Path $script:root -Force
        $script:registry = Join-Path $script:root 'registry.yml'
        $script:setting = Join-Path $script:root 'widget.cfg'
        $script:stamp = {
            param([string[]] $Settings)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Settings = $Settings } {
                param($Root, $Settings)
                Get-FormatEngineStamp -Engine widget -Settings $Settings -RepositoryRoot $Root
            }
        }
    }

    BeforeEach {
        [System.IO.File]::WriteAllText($script:registry, "widget:`n  version: `"1`"`ngadget:`n  version: `"2`"`n")
        [System.IO.File]::WriteAllText($script:setting, "tab-width = 4`n")
    }

    Context 'a whole-file entry' {
        It 'changes when the file changes, and stays when it does not' {
            $before = & $script:stamp @('widget.cfg')
            (& $script:stamp @('widget.cfg')) | Should -BeExactly $before
            [System.IO.File]::WriteAllText($script:setting, "tab-width = 2`n")
            (& $script:stamp @('widget.cfg')) | Should -Not -BeExactly $before
        }

        It 'is the plain content stamp when no entry names a key' {
            $expected = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
                param($Root)
                Get-ContentStamp -Label 'format:widget' -File @((Join-Path $Root 'widget.cfg')) -RepositoryRoot $Root
            }
            (& $script:stamp @('widget.cfg')) | Should -BeExactly $expected
        }
    }

    Context 'an entry that names one key of a file' {
        It 'changes when that key''s value changes' {
            $before = & $script:stamp @('registry.yml#widget')
            [System.IO.File]::WriteAllText($script:registry, "widget:`n  version: `"9`"`ngadget:`n  version: `"2`"`n")
            (& $script:stamp @('registry.yml#widget')) | Should -Not -BeExactly $before
        }

        It 'stays when only another key changes' {
            $before = & $script:stamp @('registry.yml#widget')
            [System.IO.File]::WriteAllText($script:registry, "widget:`n  version: `"1`"`ngadget:`n  version: `"9`"`n")
            (& $script:stamp @('registry.yml#widget')) | Should -BeExactly $before
        }

        It 'stays when only a comment or the order of the other keys changes' {
            $before = & $script:stamp @('registry.yml#widget')
            [System.IO.File]::WriteAllText($script:registry, "# a comment`ngadget:`n  version: `"2`"`nwidget:`n  version: `"1`"`n")
            (& $script:stamp @('registry.yml#widget')) | Should -BeExactly $before
        }

        It 'changes when the key is removed, and when the file is missing, because a missing input hashes as missing' {
            $before = & $script:stamp @('registry.yml#widget')
            [System.IO.File]::WriteAllText($script:registry, "gadget:`n  version: `"2`"`n")
            $withoutKey = & $script:stamp @('registry.yml#widget')
            $withoutKey | Should -Not -BeExactly $before
            Remove-Item -LiteralPath $script:registry
            (& $script:stamp @('registry.yml#widget')) | Should -BeExactly $withoutKey -Because 'a missing key and a missing file are both missing'
        }

        It 'differs from the same file named whole, and from another key of it' {
            (& $script:stamp @('registry.yml#widget')) | Should -Not -BeExactly (& $script:stamp @('registry.yml'))
            (& $script:stamp @('registry.yml#widget')) | Should -Not -BeExactly (& $script:stamp @('registry.yml#gadget'))
        }
    }
}

Describe 'The shipped format engines'' keyed settings' -Tag 'L1', 'integrity', 'ADR-AUTO-CACHE#10' {
    It 'name a top-level key that exists in their file: <_>' -ForEach @('prettier', 'gofmt', 'ruff', 'dotnet-format', 'bicep') {
        $entries = @((Get-Config -Config languages).engines[$_].settings | Where-Object { $_ -match '#' })
        $entries.Count | Should -BeGreaterThan 0 -Because "engine $_ stamps the tools it runs, not the whole tool registry"
        foreach ($entry in $entries) {
            $relative, $key = $entry -split '#', 2
            $path = Join-Path (Get-RepositoryRoot) $relative
            $path | Should -Exist
            $document = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($path)) -Ordered
            $document.Contains($key) | Should -BeTrue -Because "$entry must name a top-level key of $relative"
        }
    }

    It 'never lists the whole tool registry again for an engine' {
        foreach ($engine in (Get-Config -Config languages).engines.Values) {
            $engine.settings | Should -Not -Contain 'automation/Catzc.Base.Execution/configs/tools.yml'
        }
    }
}
