<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-listen/Start-DocListener.ps1.md"
  warning: "Generated Header"
---
#>

function Start-DocListener {
    [CmdletBinding()]
    param(
        [string] $Session,

        [ValidateRange(0, [int]::MaxValue)]
        [int] $Cycles = 0
    )

    $Session = if ($Session) {
        Resolve-ListenSession $Session
    }
    else {
        (New-DocSnapshot).Path
    }
    Write-Message "Listening to '$((Get-Config -Config listen).watch)' for the session '$Session'; Ctrl+C stops."

    for ($cycle = 1; $Cycles -eq 0 -or $cycle -le $Cycles; $cycle++) {
        try {
            foreach ($change in @(Wait-DocChange -Session $Session)) {
                $note = New-DocNote -Session $Session -Change $change
                Update-DocSnapshot -Session $Session -Path @(@($change.Path, $change.From) | Where-Object { $_ })
                Write-Message "Note $($note.Id): $($change.Path) ($($change.Change), $($change.Tier), $($change.Source))"
            }
        }
        catch {
            if (Resolve-ListenSession $Session -AllowMissing) {
                throw
            }
        }
        if (-not (Resolve-ListenSession $Session -AllowMissing)) {
            Write-Message "The session '$Session' vanished (out/ wiped?); starting a new one." -ForegroundColor Yellow
            $Session = (New-DocSnapshot).Path
        }
    }
}
