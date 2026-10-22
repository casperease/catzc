<#
---
catzc:
  immutable:
    with_body_sha: "1ac4844c931b"
  edges:
    test: pwsh/Catzc.Tooling.Listen/tests/Complete-DocNote.Tests.ps1
    docs: "[Complete-DocNote.ps1.md](../../docs/references/pwsh/catzc-tooling-listen/Complete-DocNote.ps1.md)"
---
#>

function Complete-DocNote {
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
