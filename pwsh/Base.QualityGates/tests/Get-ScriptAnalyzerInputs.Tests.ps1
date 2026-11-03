Describe 'Get-ScriptAnalyzerInputs' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:inputsOf = {
            param([string] $Pass)
            @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Pass = $Pass } {
                    param($Pass)
                    $root = Get-RepositoryRoot
                    $settings = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'
                    # The function returns its paths as one array: foreach walks the paths, not the array.
                    foreach ($path in (Get-ScriptAnalyzerInputs -RepositoryRoot $root -SettingsPath $settings -Pass $Pass)) {
                        [System.IO.Path]::GetFileName($path)
                    }
                })
        }
        $script:rules = & $script:inputsOf 'rules'
        $script:spelling = & $script:inputsOf 'spelling'
    }

    It 'gives both passes the settings and the vendored analyzer manifest' {
        foreach ($inputs in $script:rules, $script:spelling) {
            $inputs | Should -Contain 'PSScriptAnalyzerSettings.psd1'
            $inputs | Should -Contain 'PSScriptAnalyzer.psd1'
        }
    }

    It 'keeps the dictionaries and the spelling rule files out of the rules pass' {
        $script:rules | Should -Contain 'EntryRule.psm1'
        foreach ($name in 'SpellingEntryRule.psm1', 'SpellOutIdentifiers.psm1', 'english.txt.gz', 'SpellingOracle.cs') {
            $script:rules | Should -Not -Contain $name
        }
        @($script:rules | Where-Object { $_ -like '*.txt' }) | Should -HaveCount 0
    }

    It 'gives the spelling pass its rule files and the dictionaries, and no other rule file' {
        foreach ($name in 'SpellingEntryRule.psm1', 'SpellOutIdentifiers.psm1', 'english.txt.gz', 'SpellingOracle.cs') {
            $script:spelling | Should -Contain $name
        }
        $script:spelling | Should -Not -Contain 'EntryRule.psm1'
    }
}

Describe 'Get-ScriptAnalyzerInputs in a built shape' -Tag 'L0', 'logic' {
    BeforeAll {
        # The bundle's code root holds the rules, the vendored analyzer and the gates module; the working root holds the settings and the term lists.
        $script:codeRoot = Join-Path $TestDrive 'bundle/code'
        $script:workingRoot = Join-Path $TestDrive 'work'
        $files = @(
            "$script:codeRoot/.scriptanalyzer/EntryRule.psm1"
            "$script:codeRoot/.scriptanalyzer/SpellingEntryRule.psm1"
            "$script:codeRoot/.vendor/PSScriptAnalyzer/1.0/PSScriptAnalyzer.psd1"
            "$script:codeRoot/Gates/assets/english.txt.gz"
            "$script:codeRoot/Gates/types/SpellingOracle.cs"
            "$script:workingRoot/analyzer/Settings.psd1"
            "$script:workingRoot/.cspell/widget.txt"
        )
        foreach ($file in $files) {
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, 'x')
        }
    }

    BeforeEach {
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.QualityGates { $script:codeRoot }
        Mock Get-Track -ModuleName Catzc.Base.QualityGates {
            $track = [pscustomobject]@{}
            $track | Add-Member -MemberType ScriptMethod -Name FolderNameOf -Value { 'Gates' }
            $track
        }
        $script:inputsOf = {
            param([string] $Pass)
            @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Pass = $Pass; Root = $script:workingRoot } {
                    param($Pass, $Root)
                    $settings = Join-Path $Root 'analyzer/Settings.psd1'
                    foreach ($path in (Get-ScriptAnalyzerInputs -RepositoryRoot $Root -SettingsPath $settings -Pass $Pass)) {
                        $path.Replace('\', '/')
                    }
                })
        }
    }

    It 'reads the rules and the analyzer manifest from the code root and the settings from the working root, in the rules pass' {
        $rules = & $script:inputsOf 'rules'
        $rules | Should -Contain "$($script:workingRoot.Replace('\', '/'))/analyzer/Settings.psd1"
        $rules | Should -Contain "$($script:codeRoot.Replace('\', '/'))/.scriptanalyzer/EntryRule.psm1"
        $rules | Should -Contain "$($script:codeRoot.Replace('\', '/'))/.vendor/PSScriptAnalyzer/1.0/PSScriptAnalyzer.psd1"
        $rules | Should -Not -Contain "$($script:codeRoot.Replace('\', '/'))/.scriptanalyzer/SpellingEntryRule.psm1"
    }

    It 'reads the oracle from the code root''s gates module and the term lists from the working root, in the spelling pass' {
        $spelling = & $script:inputsOf 'spelling'
        $spelling | Should -Contain "$($script:codeRoot.Replace('\', '/'))/.scriptanalyzer/SpellingEntryRule.psm1"
        $spelling | Should -Contain "$($script:codeRoot.Replace('\', '/'))/Gates/assets/english.txt.gz"
        $spelling | Should -Contain "$($script:codeRoot.Replace('\', '/'))/Gates/types/SpellingOracle.cs"
        $spelling | Should -Contain "$($script:workingRoot.Replace('\', '/'))/.cspell/widget.txt"
        $spelling | Should -Not -Contain "$($script:codeRoot.Replace('\', '/'))/.scriptanalyzer/EntryRule.psm1"
    }
}
