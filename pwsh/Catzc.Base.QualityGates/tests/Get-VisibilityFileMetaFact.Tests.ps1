Describe 'Get-VisibilityFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY' {
    BeforeAll {
        Mock Get-CatzcModulesFolder -ModuleName Catzc.Base.QualityGates { 'widget-modules' }
        function script:Get-Fact {
            param([string] $Path, [hashtable] $Settings = @{})
            $entry = @{ keys = @('visibility') }
            if ($Settings.Count -gt 0) {
                $entry['settings'] = $Settings
            }
            $kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ visibility = $entry } }).kinds[0]
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $kind; Path = $Path } {
                param($Kind, $Path)
                Get-VisibilityFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'is private under the module''s private folder and public anywhere else in the module' {
        (Get-Fact 'widget-modules/Catzc.Widget/private/Get-Sprocket.ps1').Keys | Should -Be @('visibility')
        (Get-Fact 'widget-modules/Catzc.Widget/private/Get-Sprocket.ps1')['visibility'] | Should -BeExactly 'private'
        (Get-Fact 'widget-modules/Catzc.Widget/Get-Gadget.ps1')['visibility'] | Should -BeExactly 'public'
        (Get-Fact 'widget-modules/Catzc.Widget/tests/private/Get-Cog.Tests.ps1')['visibility'] | Should -BeExactly 'public' -Because 'only a private folder directly under the module counts'
    }

    It 'takes the modules root and the private folder''s name from the kind''s settings' {
        (Get-Fact 'widgets/Catzc.Gadget/hidden/Get-Cog.ps1' @{ root = 'widgets'; private_folder = 'hidden' })['visibility'] | Should -BeExactly 'private'
        (Get-Fact 'widgets/Catzc.Gadget/private/Get-Cog.ps1' @{ root = 'widgets'; private_folder = 'hidden' })['visibility'] | Should -BeExactly 'public'
    }

    It 'refuses a file outside any module, naming the file' {
        { Get-Fact 'docs/gadget.ps1' } | Should -Throw "*kind 'visibility' applies to files under widget-modules/<module>/, but selected 'docs/gadget.ps1'*"
    }
}
