# Format-Code with its seams mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): the
# file-language registry (Get-Config languages, a fixture LanguagesConfig), the scope (Get-FormatScope) and the engines
# (Invoke-FormatterEngine). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Format-Code' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:languages = [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{
                languages = [ordered]@{
                    widget   = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' }
                    gadget   = [ordered]@{ extensions = @('.gdg'); formatter = 'gofmt' }
                    sprocket = [ordered]@{ extensions = @('.spr'); no_formatter = 'binary sprockets' }
                }
            })
        $script:root = Join-Path $TestDrive 'repo'
        $script:widgetFile = Join-Path $script:root 'widgets/a.wdg'
        $script:otherWidget = Join-Path $script:root 'widgets/b.wdg'
        $script:gadgetFile = Join-Path $script:root 'gadgets/a.gdg'
        $script:sprocketFile = Join-Path $script:root 'sprockets/a.spr'
        $script:noteFile = Join-Path $script:root 'notes/a.txt'
    }

    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:root }
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive "out-$([guid]::NewGuid().ToString('N'))" }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'languages' } { $script:languages }
        # One array object, as the real Get-FormatScope returns it.
        Mock Get-FormatScope -ModuleName Catzc.Base.QualityGates {
            , [string[]] @($script:widgetFile, $script:otherWidget, $script:gadgetFile, $script:sprocketFile, $script:noteFile)
        }
        Mock Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Engine -eq 'prettier' } { , [string[]] @($script:widgetFile) }
        Mock Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Engine -eq 'gofmt' } { , [string[]] @() }
    }

    It 'runs each language''s engine over that language''s files only, and leaves a language without a formatter alone' -Tag 'ADR-PRIN-CONFIG#1' {
        Format-Code
        Should -Invoke Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Engine -eq 'prettier' -and ($File -join '|') -eq "$script:widgetFile|$script:otherWidget" -and -not $DryRun
        }
        Should -Invoke Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Engine -eq 'gofmt' -and ($File -join '|') -eq $script:gadgetFile
        }
        Should -Invoke Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly
    }

    It 'returns nothing without -PassThru, and one FormatResult per language with it' {
        @(Format-Code) | Should -HaveCount 0
        $results = @(Format-Code -DryRun -PassThru)
        $results | Should -HaveCount 2
        $results[0] | Should -BeOfType [Catzc.Base.QualityGates.FormatResult]
        $results[0].Language | Should -Be 'widget'
        $results[0].Engine | Should -Be 'prettier'
        $results[0].CheckedFiles | Should -Be @($script:widgetFile, $script:otherWidget)
        $results[0].ChangedFiles | Should -Be @($script:widgetFile)
        $results[0].DryRun | Should -BeTrue
        $results[1].Language | Should -Be 'gadget'
        $results[1].ChangedFiles.Count | Should -Be 0
    }

    It 'passes -DryRun to the engine' {
        $null = Format-Code -DryRun
        Should -Invoke Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly -ParameterFilter { $DryRun }
    }

    It 'formats only the named languages, and passes -Path to the scope' {
        $null = Format-Code -Language gadget -Path 'gadgets'
        Should -Invoke Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
        Should -Invoke Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Engine -eq 'gofmt' }
        Should -Invoke Get-FormatScope -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Path -eq 'gadgets' }
    }

    It 'asserts the source tree only for the default scope' {
        $null = Format-Code
        Should -Invoke Assert-SourceTree -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
        $null = Format-Code -Path $script:widgetFile
        Should -Invoke Assert-SourceTree -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'throws on an undeclared language, and on a language without a formatter, naming why' {
        { Format-Code -Language gizmo } | Should -Throw "*unknown file language 'gizmo'*widget, gadget, sprocket*"
        { Format-Code -Language sprocket } | Should -Throw "*'sprocket' has no formatter (binary sprockets)*"
        Should -Invoke Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates -Times 0
    }
}

# One engine run per engine, and the content-keyed result cache, over real fixture files in $TestDrive with the engine
# mocked ([ADR-AUTO-CACHE](/docs/adr/automation/caching.md)).
Describe 'Format-Code engine grouping and result cache' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'cache-repo'))
        $script:settingsFile = Join-Path $script:root 'widget.settings'
        $script:languages = [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{
                engines   = [ordered]@{ prettier = [ordered]@{ settings = @('widget.settings') } }
                languages = [ordered]@{
                    widget = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' }
                    gadget = [ordered]@{ extensions = @('.gdg'); formatter = 'prettier' }
                }
            })
        $script:widgetFile = Join-Path $script:root 'widgets/a.wdg'
        $script:gadgetFile = Join-Path $script:root 'gadgets/a.gdg'
        $script:outRoot = Join-Path $TestDrive 'cache-out'
    }

    BeforeEach {
        foreach ($file in $script:widgetFile, $script:gadgetFile) {
            $null = New-Item -ItemType File -Path $file -Force
            [System.IO.File]::WriteAllText($file, 'formatted')
        }
        [System.IO.File]::WriteAllText($script:settingsFile, 'width: 140')
        Remove-Item -LiteralPath $script:outRoot -Recurse -Force -ErrorAction Ignore
        $script:handed = [System.Collections.Generic.List[string]]::new()
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:root }
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { $script:outRoot }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'languages' } { $script:languages }
        Mock Get-FormatScope -ModuleName Catzc.Base.QualityGates { , [string[]] @($script:widgetFile, $script:gadgetFile) }
        # The fake engine finds every file it is handed formatted.
        Mock Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates {
            foreach ($file in $File) {
                $script:handed.Add($file)
            }
            , [string[]] @()
        }
    }

    It 'runs one engine once over the files of every language it formats, and still returns one result per language' {
        $results = @(Format-Code -DryRun -PassThru)
        Should -Invoke Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
        $script:handed | Should -Be @($script:widgetFile, $script:gadgetFile)
        @($results | ForEach-Object Language) | Should -Be @('widget', 'gadget')
    }

    It 'skips a file the engine last found formatted, and checks it again once its bytes change' -Tag 'ADR-AUTO-CACHE#10' {
        $null = Format-Code -DryRun
        $script:handed.Clear()
        $results = @(Format-Code -DryRun -PassThru)
        $script:handed.Count | Should -Be 0
        $results[0].CheckedFiles | Should -Be @($script:widgetFile)
        [System.IO.File]::WriteAllText($script:widgetFile, 'edited')
        $null = Format-Code -DryRun
        $script:handed | Should -Be @($script:widgetFile)
    }

    It 'checks every file again when a settings file of its engine changes, and under -NoCache' {
        $null = Format-Code -DryRun
        $script:handed.Clear()
        [System.IO.File]::WriteAllText($script:settingsFile, 'width: 120')
        $null = Format-Code -DryRun
        $script:handed | Should -Be @($script:widgetFile, $script:gadgetFile)
        $script:handed.Clear()
        $null = Format-Code -DryRun -NoCache
        $script:handed | Should -Be @($script:widgetFile, $script:gadgetFile)
    }

    It 'does not record a file the engine would still change' -Tag 'ADR-AUTO-CACHE#10' {
        Mock Invoke-FormatterEngine -ModuleName Catzc.Base.QualityGates {
            foreach ($file in $File) {
                $script:handed.Add($file)
            }
            , [string[]] @($script:gadgetFile)
        }
        $null = Format-Code -DryRun
        $script:handed.Clear()
        $null = Format-Code -DryRun
        $script:handed | Should -Be @($script:gadgetFile)
    }
}

# Integrity: every engine the registry may name has its adapter, and the shipped languages.yml names only those engines
# ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
Describe 'Format-Code engines' -Tag 'L0', 'integrity' {
    It 'has an adapter for every declared engine: <_>' -ForEach @([Catzc.Base.Languages.LanguagesConfig]::FormatterEngines) {
        $engine = $_
        $changed = InModuleScope Catzc.Base.QualityGates -Parameters @{ Engine = $engine } {
            param($Engine)
            @(Invoke-FormatterEngine -Engine $Engine -File @())
        }
        $changed | Should -HaveCount 0
    }

    It 'throws for an engine it has no adapter for' {
        { InModuleScope Catzc.Base.QualityGates { Invoke-FormatterEngine -Engine 'widget-fmt' -File @() } } |
            Should -Throw "*no adapter for the formatter engine 'widget-fmt'*"
    }

    It 'every settings file an engine declares exists, so the cache stamp reads real inputs' -Tag 'ADR-AUTO-CACHE#10' {
        $root = Get-RepositoryRoot
        foreach ($engine in (Get-Config -Config languages).engines.Values) {
            foreach ($settingsFile in $engine.settings) {
                Join-Path $root $settingsFile | Should -Exist -Because "engines.$($engine.name).settings in languages.yml"
            }
        }
    }

    It 'the shipped languages.yml gives every language a formatter or the reason it has none' -Tag 'ADR-PRIN-CONFIG#4' {
        foreach ($language in (Get-Config -Config languages).languages) {
            ([bool] $language.formatter) -xor ([bool] $language.no_formatter) | Should -BeTrue -Because $language.name
        }
    }
}

# The real-asset test of [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3):
# the psscriptanalyzer engine imports the vendored PSScriptAnalyzer (<code root>/.vendor) and formats with the shipped
# settings file (<code root>/.internal/assets), nothing mocked but the console — integrity, and not source-only, so it
# runs in the source and the build run. An explicit -Path over a throwaway file keeps it off the source tree.
Describe 'Format-Code (real vendored analyzer and settings)' -Tag 'L2', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    BeforeAll {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'out' }
    }

    It 'formats an off-style PowerShell file with the vendored analyzer, reporting it first under -DryRun' {
        $subject = Join-Path $TestDrive 'Get-Widget.ps1'
        # Off-style on purpose: a same-line brace body and a missing final newline.
        $offStyle = 'function Get-Widget { $value = 1; $value }'
        [System.IO.File]::WriteAllText($subject, $offStyle)

        (Format-Code -Language powershell -Path $subject -DryRun -PassThru).ChangedFiles | Should -Be @($subject)
        [System.IO.File]::ReadAllText($subject) | Should -BeExactly $offStyle

        (Format-Code -Language powershell -Path $subject -PassThru).ChangedFiles | Should -Be @($subject)
        $formatted = [System.IO.File]::ReadAllText($subject)
        $formatted | Should -Not -BeExactly $offStyle
        $formatted | Should -Match "`n$"
        $formatted | Should -Not -Match "`r"
    }

    It 'formats exactly as the vendored analyzer does with the whole settings file, custom rules included' {
        $subject = Join-Path $TestDrive 'Get-Gadget.ps1'
        $offStyle = "function Get-Gadget {`n  if (`$true) { 'x' }`n    `$value=1;   `$value  `n}"
        [System.IO.File]::WriteAllText($subject, $offStyle)
        # The engine imports the analyzer on first use, so Invoke-Formatter exists once it has run.
        $null = Format-Code -Language powershell -Path $subject
        $formatted = [System.IO.File]::ReadAllText($subject)
        $settingsFile = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'
        Push-Location (Get-RepositoryRoot)
        try {
            $expected = Invoke-Formatter -ScriptDefinition $offStyle -Settings $settingsFile
        }
        finally {
            Pop-Location
        }
        $expected = ($expected -replace "`r`n", "`n" -replace '(?m)[ \t]+$', '').TrimEnd("`n") + "`n"

        $formatted | Should -Not -BeExactly $offStyle
        $formatted | Should -BeExactly $expected
    }
}

# The prettier engine over throwaway files, nothing mocked but the console; self-skips when prettier is absent
# ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)).
Describe 'Format-Code (real prettier)' -Tag 'L2', 'logic' {
    BeforeAll {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'out' }
    }

    It 'formats Markdown and pipeline YAML with prettier, so a second run changes nothing' {
        if (-not (Get-Command prettier -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_prettier_missing'
            return
        }
        $markdown = Join-Path $TestDrive 'widget.md'
        # A heading plus an over-long single-line paragraph (>140) that proseWrap: always rewraps.
        Set-Content -Path $markdown -Value ('# Title' + "`n`n" + ('word ' * 60).Trim() + '.') -Encoding utf8
        $pipeline = Join-Path $TestDrive 'ci-widget.yaml'
        # A badly indented mapping Prettier normalises, with a ${{ }} expression that must survive.
        Set-Content -Path $pipeline -Encoding utf8 -Value @'
trigger:
    branches:
        include: [main]
steps:
  - script: "echo ${{ parameters.x }}"
'@
        $results = @(Format-Code -Language markdown, pipeline-yaml -Path $markdown, $pipeline -PassThru)
        ($results | Where-Object Language -EQ markdown).ChangedFiles | Should -Be @($markdown)
        ($results | Where-Object Language -EQ pipeline-yaml).ChangedFiles | Should -Be @($pipeline)
        (Get-Content $pipeline -Raw) | Should -Match '\$\{\{ parameters\.x \}\}'
        $again = @(Format-Code -Language markdown, pipeline-yaml -Path $markdown, $pipeline -DryRun -PassThru)
        $again | Should -HaveCount 2
        foreach ($result in $again) {
            $result.ChangedFiles.Count | Should -Be 0 -Because $result.Language
        }
    }
}
