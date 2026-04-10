Describe 'Build-ScriptAnalyzerSettings' -Tag 'L0', 'logic' {
    BeforeAll {
        # A hermetic fake repo: a fixture source under the conventional .internal/assets path, and
        # Get-RepositoryRoot pointed at it so the writer never touches the real root file.
        $script:fakeRoot = Join-Path $TestDrive ([Guid]::NewGuid())
        $script:sourceDir = Join-Path $script:fakeRoot 'automation/.internal/assets'
        [void][System.IO.Directory]::CreateDirectory($script:sourceDir)
        $script:sourcePath = Join-Path $script:sourceDir 'PSScriptAnalyzerSettings.psd1'
        # A tiny but real settings hashtable (with a leading comment, as the shipped source has), so the parse
        # test proves the generated header does not break the hashtable.
        $script:sourceText = "# fixture analyzer settings`n@{`n    Severity = @('Error')`n    ExcludeRules = @('PSUseSingularNouns')`n}`n"
        [System.IO.File]::WriteAllText($script:sourcePath, $script:sourceText, [System.Text.UTF8Encoding]::new($false))

        $script:rootSettings = Join-Path $script:fakeRoot 'PSScriptAnalyzerSettings.psd1'
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:fakeRoot }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'writes the root copy from the .internal/assets source, with a generated-file banner' {
        Build-ScriptAnalyzerSettings | Out-Null
        Test-Path $script:rootSettings | Should -BeTrue
        $text = [System.IO.File]::ReadAllText($script:rootSettings)
        $text | Should -Match '^# GENERATED FILE'
        $text | Should -Match 'automation/\.internal/assets/PSScriptAnalyzerSettings\.psd1'
        # The source hashtable is carried through verbatim.
        $text | Should -Match '@\{'
        $text | Should -Match "Severity = @\('Error'\)"
    }

    It 'produces a file that still parses as PSScriptAnalyzer settings (a hashtable) despite the banner' {
        Build-ScriptAnalyzerSettings | Out-Null
        $data = Import-PowerShellDataFile $script:rootSettings
        $data | Should -BeOfType [hashtable]
        $data.Severity | Should -Contain 'Error'
        $data.ExcludeRules | Should -Contain 'PSUseSingularNouns'
    }

    It 'is idempotent — a second run reports unchanged and does not rewrite' {
        Build-ScriptAnalyzerSettings | Out-Null
        $result = Build-ScriptAnalyzerSettings -PassThru
        $result.Changed | Should -BeFalse
        $result.Settings | Should -Be $script:rootSettings
        $result.Source | Should -Be $script:sourcePath
    }

    It 'with -DryRun reports the plan without writing the file' {
        # Start from no root copy so a write would be observable.
        if (Test-Path $script:rootSettings) {
            [System.IO.File]::Delete($script:rootSettings)
        }
        $result = Build-ScriptAnalyzerSettings -DryRun -PassThru
        $result.DryRun | Should -BeTrue
        $result.Changed | Should -BeTrue
        Test-Path $script:rootSettings | Should -BeFalse
    }
}

Describe 'Build-ScriptAnalyzerSettings — real config' -Tag 'L1', 'integrity' {
    It 'the generated root copy the importer keeps current is in sync with the authored source' {
        # The importer regenerates the root copy on every load, so against the real repo -DryRun reports no drift.
        $result = Build-ScriptAnalyzerSettings -DryRun -PassThru -Silent
        $result.Source | Should -BeLike '*automation?.internal?assets?PSScriptAnalyzerSettings.psd1'
        $result.Changed | Should -BeFalse
    }

    It 'the on-disk root copy parses as a settings hashtable with the shipped rule config' {
        $rootSettings = Join-Path (Get-RepositoryRoot) 'PSScriptAnalyzerSettings.psd1'
        if (-not (Test-Path $rootSettings)) {
            Set-ItResult -Skipped -Because 'tool_importer_missing'
            return
        }
        $data = Import-PowerShellDataFile $rootSettings
        $data | Should -BeOfType [hashtable]
        $data.CustomRulePath | Should -Not -BeNullOrEmpty
    }
}
