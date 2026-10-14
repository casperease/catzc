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

    It 'the shipped languages.yml gives every language a formatter or the reason it has none' -Tag 'ADR-PRIN-CONFIG#4' {
        foreach ($language in (Get-Config -Config languages).languages) {
            ([bool] $language.formatter) -xor ([bool] $language.no_formatter) | Should -BeTrue -Because $language.name
        }
    }
}

# The real engines over throwaway files, nothing mocked but the console. Each self-skips when its tool is absent
# ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)). The PowerShell case is also the
# real-asset test of [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3):
# the engine imports the vendored PSScriptAnalyzer and formats with the shipped settings file.
Describe 'Format-Code (real engines)' -Tag 'L2', 'logic' {
    BeforeAll {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'formats an off-style PowerShell file with the vendored analyzer, reporting it first under -DryRun' -Tag 'integrity', 'ADR-AUTO-ASSETDEP#3' {
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
