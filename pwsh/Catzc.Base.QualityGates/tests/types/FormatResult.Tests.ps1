Describe 'FormatResult' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
    It 'carries the language, engine, checked and changed files, and the dry-run flag' {
        $result = [Catzc.Base.QualityGates.FormatResult]::new('widget', 'prettier', [string[]] @('a.wdg', 'b.wdg'), [string[]] @('a.wdg'), $true)
        $result.Language | Should -Be 'widget'
        $result.Engine | Should -Be 'prettier'
        $result.CheckedFiles | Should -Be @('a.wdg', 'b.wdg')
        $result.ChangedFiles | Should -Be @('a.wdg')
        $result.DryRun | Should -BeTrue
    }

    It 'has no unfixable file unless an imprint step names one, each with its problem' {
        [Catzc.Base.QualityGates.FormatResult]::new('widget', 'prettier', $null, $null, $false).Unfixable.Count | Should -Be 0
        $result = [Catzc.Base.QualityGates.FormatResult]::new('widget', 'prettier', [string[]] @('a.wdg'), [string[]] @(), $false, @{ 'a.wdg' = 'a hand edit' })
        $result.Unfixable['a.wdg'] | Should -Be 'a hand edit'
        $result.Unfixable.Count | Should -Be 1
    }

    It 'reads missing file lists as empty' {
        $result = [Catzc.Base.QualityGates.FormatResult]::new('widget', 'prettier', $null, $null, $true)
        $result.CheckedFiles.Count | Should -Be 0
        $result.ChangedFiles.Count | Should -Be 0
    }
}
