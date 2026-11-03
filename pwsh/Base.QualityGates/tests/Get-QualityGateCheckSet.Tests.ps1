Describe 'Get-QualityGateCheckSet' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ name = 'widget'; checks = @('Test-WidgetGate', 'Test-GadgetGate'); check_scopes = @{} }
            [pscustomobject]@{ name = 'gadget'; checks = @('Test-GadgetGate', 'Test-GizmoGate'); check_scopes = @{} }
            [pscustomobject]@{ name = 'sprocket'; checks = $null; check_scopes = $null }
            [pscustomobject]@{ name = 'cog'; checks = @('Test-CogGate', 'Test-CogFolderGate'); check_scopes = @{ 'Test-CogFolderGate' = 'global.widget.cogs.folder' } }
        }
    }

    It 'returns the union of the registry checks, each name once, in registry order' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-PresentLanguageName { 'widget', 'gadget' } -ModuleName Catzc.Base.QualityGates
        $set = & (Get-Module Catzc.Base.QualityGates) { Get-QualityGateCheckSet }
        $set | Should -Be @('Test-WidgetGate', 'Test-GadgetGate', 'Test-GizmoGate')
    }

    It 'skips a language that declares no checks' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-PresentLanguageName { 'widget', 'sprocket' } -ModuleName Catzc.Base.QualityGates
        $set = & (Get-Module Catzc.Base.QualityGates) { Get-QualityGateCheckSet }
        $set | Should -Be @('Test-WidgetGate', 'Test-GadgetGate')
    }

    It 'returns an empty array when no present language declares a check' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-PresentLanguageName { 'sprocket' } -ModuleName Catzc.Base.QualityGates
        $set = @(& (Get-Module Catzc.Base.QualityGates) { Get-QualityGateCheckSet })
        $set.Count | Should -Be 0
    }

    It 'leaves out the checks of a language no tracked file resolves to' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-PresentLanguageName { 'gadget' } -ModuleName Catzc.Base.QualityGates
        $set = & (Get-Module Catzc.Base.QualityGates) { Get-QualityGateCheckSet }
        $set | Should -Be @('Test-GadgetGate', 'Test-GizmoGate')
    }

    It 'returns an empty array when no language is present' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-PresentLanguageName { } -ModuleName Catzc.Base.QualityGates
        $set = @(& (Get-Module Catzc.Base.QualityGates) { Get-QualityGateCheckSet })
        $set.Count | Should -Be 0
    }

    It 'keeps a scoped check when the folder its address names exists' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-PresentLanguageName { 'cog' } -ModuleName Catzc.Base.QualityGates
        Mock Get-ConfigValue { 'cogs' } -ModuleName Catzc.Base.QualityGates
        Mock Resolve-RepoPath { $TestDrive } -ModuleName Catzc.Base.QualityGates
        $set = & (Get-Module Catzc.Base.QualityGates) { Get-QualityGateCheckSet }
        $set | Should -Be @('Test-CogGate', 'Test-CogFolderGate')
    }

    It 'drops a scoped check when the folder its address names is absent' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-PresentLanguageName { 'cog' } -ModuleName Catzc.Base.QualityGates
        Mock Get-ConfigValue { 'cogs' } -ModuleName Catzc.Base.QualityGates
        Mock Resolve-RepoPath { Join-Path $TestDrive 'missing-cogs' } -ModuleName Catzc.Base.QualityGates
        $set = & (Get-Module Catzc.Base.QualityGates) { Get-QualityGateCheckSet }
        $set | Should -Be @('Test-CogGate')
    }
}

Describe 'Get-QualityGateCheckSet in this repository' -Tag 'L0', 'logic' {
    It 'equals the plain registry union' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $expected = @(Get-FileLanguage | ForEach-Object { $_.checks } | Select-Object -Unique)
        $set = & (Get-Module Catzc.Base.QualityGates) { Get-QualityGateCheckSet }
        @($set) | Should -Be $expected
    }
}
