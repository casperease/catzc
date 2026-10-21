<#
---
catzc:
  immutable:
    with_body_sha: "8c05aded683c"
  edges:
    code: pwsh/Catzc.Tooling.Listen/Get-DocNote.ps1
---
#>

Describe 'Get-DocNote' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
    }

    BeforeEach {
        Initialize-ListenFixture | Out-Null
        $script:session = (New-DocSnapshot).Path
        Write-ListenFixtureFile 'docs/drs/widget.md' "# Widget`n`nADR-WIDGET-PARTS-SINGLE and ADR-WIDGET-PARTS-DOUBLE.`n"
        Write-ListenFixtureFile 'docs/explanation/gadget.md' "# Gadget`n`nNo rule.`n"
        Get-DocChange -Session $script:session | New-DocNote -Session $script:session | Out-Null
    }

    It 'reads every note from its head, in id order' {
        $notes = @(Get-DocNote -Session $script:session)
        @($notes.Id) | Should -Be @('0001', '0002')
        $notes[0].File | Should -BeExactly 'docs/drs/widget.md'
        $notes[0].Change | Should -BeExactly 'modified'
        $notes[0].Kind | Should -BeExactly 'adr'
        $notes[0].Tier | Should -BeExactly 'rule'
        $notes[0].Rules | Should -Be @('ADR-WIDGET-PARTS-DOUBLE', 'ADR-WIDGET-PARTS-SINGLE')
        $notes[1].Rules.Count | Should -Be 0
        $notes[0].Commit | Should -BeExactly 'c0ffee0000000000000000000000000000000000'
        @($notes.Processed) | Should -Be @($false, $false)
        @($notes.Session | Select-Object -Unique) | Should -Be @($script:session)
    }

    It 'leaves out the processed ones with -Unprocessed' {
        Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'partly' -FactCheckReason 'docs/drs/widget.md:3 names one part of two' -Pattern 'widget-parts' -Plan 'plan-listen-widget-parts.md'
        @(Get-DocNote -Session $script:session -Unprocessed).Id | Should -Be @('0002')
        (Get-DocNote -Session $script:session)[0].Processed | Should -BeTrue
    }

    It 'carries each note''s source, and filters by it with -Source' {
        @((Get-DocNote -Session $script:session).Source | Select-Object -Unique) | Should -Be @('unknown')
        @(Get-DocNote -Session $script:session -Source editor).Count | Should -Be 0
        @(Get-DocNote -Session $script:session -Source editor, unknown).Count | Should -Be 2
    }

    It 'reads the newest session when none is named' {
        @(Get-DocNote).Count | Should -Be 2
    }

    It 'throws, naming the likely wipe, for a named session that has vanished' {
        [System.IO.Directory]::Delete($script:session, $true)
        { Get-DocNote -Session $script:session } | Should -Throw '*no listen session*out/ may have been wiped*'
    }

    It 'throws when there is no session at all' {
        Initialize-ListenFixture | Out-Null
        { Get-DocNote } | Should -Throw '*No listen session under*'
    }
}
