<#
---
catzc:
  immutable:
    with_body_sha: "570a55f31101"
  edges:
    code: pwsh/Catzc.Tooling.Listen/Complete-DocNote.ps1
---
#>

Describe 'Complete-DocNote' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
        $script:reason = 'docs/drs/widget.md:3 still says one part'
    }

    BeforeEach {
        Initialize-ListenFixture | Out-Null
        $script:session = (New-DocSnapshot).Path
        Write-ListenFixtureFile 'docs/drs/widget.md' "# Widget`n`nCompleted.`n"
        Get-DocChange -Session $script:session | New-DocNote -Session $script:session | Out-Null
    }

    It 'appends one ledger line, the verdict with its reason, and leaves the note untouched' {
        $before = [System.IO.File]::ReadAllText((Join-Path $script:session 'notes/0001.md'))
        Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'does not hold' -FactCheckReason " $script:reason " -Pattern 'widget-parts' -Plan 'plan-listen-widget-parts.md'
        [System.IO.File]::ReadAllText((Join-Path $script:session 'processed.md')) |
            Should -BeExactly "- 0001 | fact-check: does not hold | because: $script:reason | pattern: widget-parts | plan: plan-listen-widget-parts.md`n"
        [System.IO.File]::ReadAllText((Join-Path $script:session 'notes/0001.md')) | Should -BeExactly $before
    }

    It 'refuses a verdict without its reason' -ForEach @(
        @{ Case = 'a blank reason'; Reason = '   '; Expected = '*FactCheckReason*' }
        @{ Case = 'a reason that only repeats the verdict'; Reason = 'partly.'; Expected = "*reason for 'partly' only repeats the verdict*" }
    ) {
        { Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'partly' -FactCheckReason $Reason -Pattern 'widget' -Plan 'none' } |
            Should -Throw $Expected
        [System.IO.File]::Exists((Join-Path $script:session 'processed.md')) | Should -BeFalse
    }

    It 'throws on an unknown note' {
        { Complete-DocNote -Session $script:session -Id '0009' -FactCheck 'holds' -FactCheckReason $script:reason -Pattern 'widget' -Plan 'none' } |
            Should -Throw "*has no note '0009'*"
    }

    It 'throws on a note completed before' {
        Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'holds' -FactCheckReason $script:reason -Pattern 'widget' -Plan 'none'
        { Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'holds' -FactCheckReason $script:reason -Pattern 'widget' -Plan 'none' } |
            Should -Throw '*already processed*'
    }

    It 'throws on a value the ledger line cannot carry' -ForEach @(
        @{ Reason = 'widget | gadget'; Pattern = 'widget' }
        @{ Reason = 'widget'; Pattern = 'widget | gadget' }
    ) {
        { Complete-DocNote -Session $script:session -Id '0001' -FactCheck 'holds' -FactCheckReason $Reason -Pattern $Pattern -Plan 'none' } |
            Should -Throw "*holds a '|'*"
    }
}
