Describe 'Get-CatsAdrIndex' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:indexPath = Join-Path $TestDrive 'index.md'
        $content = @(
            '# ADR index'
            ''
            '## Codes'
            ''
            '| Code | ADR |'
            '| ---- | --- |'
            '| `ADR-ALPHA` | [alpha-thing](principles/alpha-thing.md) |'
            '| `ADR-BETA`  | [beta-thing](automation/beta-thing.md) |'
            ''
            'Prose that mentions `ADR-ALPHA` inline is not a table row and must not be parsed.'
        ) -join "`n"
        [System.IO.File]::WriteAllText($script:indexPath, $content)
    }

    It 'parses each ADR table row into Code, Title, and Path' {
        $entries = & (Get-Module Catzc.Base.Docs) { param($p) Get-CatsAdrIndex -IndexPath $p } $script:indexPath
        @($entries).Count | Should -Be 2
        $entries[0].Code | Should -Be 'ADR-ALPHA'
        $entries[0].Title | Should -Be 'alpha-thing'
        $entries[0].Path | Should -Be 'principles/alpha-thing.md'
        $entries[1].Code | Should -Be 'ADR-BETA'
    }

    It 'ignores inline code-span mentions that are not table rows' {
        $entries = & (Get-Module Catzc.Base.Docs) { param($p) Get-CatsAdrIndex -IndexPath $p } $script:indexPath
        @($entries | Where-Object { $_.Code -eq 'ADR-ALPHA' }).Count | Should -Be 1
    }
}
