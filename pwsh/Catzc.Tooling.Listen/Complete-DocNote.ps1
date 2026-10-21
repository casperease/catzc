<#
---
catzc:
  immutable:
    with_body_sha: "56737f248ca5"
  edges:
    test: pwsh/Catzc.Tooling.Listen/tests/Complete-DocNote.Tests.ps1
---
#>

function Complete-DocNote {
    <#
    .SYNOPSIS
        Records that the processor has processed one note: one line in the session's ledger, processed.md.

    .DESCRIPTION
        The ledger is the processor's own file, as the notes are the listener's: one writer per file, so neither waits on the other. A
        line reads `- <id> | fact-check: <verdict> | because: <reason> | pattern: <name> | plan: <plan file>`; a note is completed once.

        A fact-check never stands alone: the verdict is always written with the reason that supports it (what in the reference holds or
        breaks, with its path:line), so a reader of the ledger can check the verdict without running the fact-checker again.

    .PARAMETER Session
        The session folder. Default: the newest session.

    .PARAMETER Id
        The note's id.

    .PARAMETER FactCheck
        The fact-checker's verdict on the repository against the note: holds, partly, or does not hold.

    .PARAMETER FactCheckReason
        Why the verdict is what it is: the fact-checker's reasoning, with the path:line it rests on. Required with every verdict, and more
        than the verdict itself.

    .PARAMETER Pattern
        The pattern the note was folded into.

    .PARAMETER Plan
        The plan file the pattern lives in, or 'none' when the note restated existing truth.
    #>
    [CmdletBinding()]
    param(
        [string] $Session,

        [Parameter(Mandatory)]
        [ValidatePattern('^\d{4}$')]
        [string] $Id,

        [Parameter(Mandatory)]
        [ValidateSet('holds', 'partly', 'does not hold')]
        [string] $FactCheck,

        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string] $FactCheckReason,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Pattern,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Plan
    )

    $Session = Resolve-ListenSession $Session
    $note = @(Get-DocNote -Session $Session | Where-Object Id -CEQ $Id)
    Assert-True ($note.Count -eq 1) -ErrorText "Complete-DocNote: the session has no note '$Id'."
    Assert-True (-not $note[0].Processed) -ErrorText "Complete-DocNote: the note '$Id' is already processed."

    $reason = $FactCheckReason.Trim()
    Assert-True ($reason.Trim('.', ' ') -cne $FactCheck) -ErrorText "Complete-DocNote: the reason for '$FactCheck' only repeats the verdict; give what supports it, with its path:line."
    foreach ($value in $reason, $Pattern, $Plan) {
        Assert-True (-not $value.Contains('|') -and -not $value.Contains("`n")) -ErrorText "Complete-DocNote: '$value' holds a '|' or a line break, which the ledger line cannot carry."
    }
    $line = "- $Id | fact-check: $FactCheck | because: $reason | pattern: $Pattern | plan: $Plan`n"
    [System.IO.File]::AppendAllText((Join-Path $Session 'processed.md'), $line, [System.Text.UTF8Encoding]::new($false))
}
