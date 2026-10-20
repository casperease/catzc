Describe 'New-DocNote' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
    }

    BeforeEach {
        Initialize-ListenFixture | Out-Null
        $script:session = (New-DocSnapshot).Path
    }

    It 'writes one note with the raw facts of the change and both diffs' {
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nOne part, ADR-WIDGET-PARTS-SINGLE.`n"
        $note = Get-DocChange -Session $script:session | New-DocNote -Session $script:session
        $note.Id | Should -BeExactly '0001'
        $text = [System.IO.File]::ReadAllText($note.Path)
        $text | Should -BeLike "---`nnote: `"0001`"`npath: `"docs/adr/widget.md`"`nchange: modified`n*"
        $text | Should -BeLike '*tier: rule*'
        $text | Should -BeLike '*rules: `[ADR-WIDGET-PARTS-SINGLE`]*'
        $text | Should -BeLike '*commit: c0ffee0000000000000000000000000000000000*'
        $text | Should -BeLike '*## This change (against seen)*+One part*## The arc over the session (against baseline)*+One part*'
    }

    It 'numbers the notes of a session in order' {
        Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nFirst.`n"
        Write-ListenFixtureFile 'docs/explanation/gadget.md' "# Gadget`n`nSecond.`n"
        $notes = @(Get-DocChange -Session $script:session | New-DocNote -Session $script:session)
        @($notes.Id) | Should -Be @('0001', '0002')
    }
}
