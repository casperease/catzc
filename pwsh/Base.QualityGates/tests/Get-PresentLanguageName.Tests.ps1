Describe 'Get-PresentLanguageName' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-FileLanguage { } -ModuleName Catzc.Base.QualityGates
        Mock Get-FileLanguage { [pscustomobject]@{ name = 'widget' } } -ParameterFilter { $Path -like '*.widget' } -ModuleName Catzc.Base.QualityGates
        Mock Get-FileLanguage { [pscustomobject]@{ name = 'gadget' } } -ParameterFilter { $Path -like '*.gadget' } -ModuleName Catzc.Base.QualityGates
    }

    It 'names the languages the tracked files resolve to, once each' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-TrackedFile { 'a/one.widget', 'a/two.gadget', 'b/three.sprocket' } -ModuleName Catzc.Base.QualityGates
        $names = & (Get-Module Catzc.Base.QualityGates) { Get-PresentLanguageName }
        @($names) | Should -Be @('widget', 'gadget')
    }

    It 'probes one file per distinct suffix' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-TrackedFile { 'a/one.widget', 'a/two.widget', 'b/three.widget', 'c/four.gadget' } -ModuleName Catzc.Base.QualityGates
        & (Get-Module Catzc.Base.QualityGates) { Get-PresentLanguageName } | Out-Null
        Should -Invoke Get-FileLanguage -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly
    }

    It 'returns an empty array when nothing is tracked' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Get-TrackedFile { } -ModuleName Catzc.Base.QualityGates
        $names = @(& (Get-Module Catzc.Base.QualityGates) { Get-PresentLanguageName })
        $names.Count | Should -Be 0
    }
}
