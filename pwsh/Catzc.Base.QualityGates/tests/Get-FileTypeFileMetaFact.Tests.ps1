Describe 'Get-FileTypeFileMetaFact' -Tag 'L0', 'logic', 'ADR-DSGN-TRACK-FILELANGUAGE' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'file-type' = @{ keys = @('filetype') } } }).kinds[0]

        function script:Get-Fact {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $script:kind; Path = $Path } {
                param($Kind, $Path)
                Get-FileTypeFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'names the extension of the file, under the kind''s key' {
        $fact = Get-Fact 'widgetry/.internal/Catzc.Internal.Types.psm1'
        @($fact.Keys) | Should -Be @('filetype')
        $fact['filetype'] | Should -BeExactly 'psm1'
    }

    It 'names the last extension of a test file' {
        (Get-Fact 'widgetry/.internal/tests/Assert-Widget.Tests.ps1')['filetype'] | Should -BeExactly 'ps1'
    }

    It 'gives an empty value to a file with no extension and to a dotfile' -ForEach @(
        @{ Path = 'LICENSE' }
        @{ Path = '.gitkeep' }
    ) {
        (Get-Fact $Path)['filetype'] | Should -BeExactly ''
    }
}
