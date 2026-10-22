<#
---
catzc:
  immutable:
    with_body_sha: "9f6237b60a3a"
  edges:
    test: pwsh/Catzc.Tooling.Listen/tests/Wait-DocNote.Tests.ps1
    docs: "[Wait-DocNote.ps1.md](../../docs/references/pwsh/catzc-tooling-listen/Wait-DocNote.ps1.md)"
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
---
#>

function Wait-DocNote {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Session,

        [ValidateRange(1, 3600)]
        [int] $TimeoutSeconds = (Get-Config -Config listen).note_wait_seconds,

        [ValidateSet('editor', 'agent', 'unknown')]
        [string[]] $Source
    )

    $poll = (Get-Config -Config listen).poll_milliseconds
    $deadline = [System.Diagnostics.Stopwatch]::StartNew()
    while ($true) {
        $current = Resolve-ListenSession $Session -AllowMissing
        if ($current) {
            # The session can vanish between the lookup and the read; that is the same as no session yet.
            [object[]] $notes = @()
            try {
                $filter = @{}
                if ($Source) {
                    $filter['Source'] = $Source
                }
                $notes = @(Get-DocNote -Session $current -Unprocessed @filter)
            }
            catch {
                if (Resolve-ListenSession $current -AllowMissing) {
                    throw
                }
            }
            if ($notes.Count -gt 0) {
                return $notes
            }
        }
        if ($deadline.Elapsed.TotalSeconds -ge $TimeoutSeconds) {
            return
        }
        Start-Sleep -Milliseconds $poll
    }
}
