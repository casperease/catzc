function Lock-SharedConfig {
    [CmdletBinding()]
    [OutputType([Catzc.Tooling.Claude.EditorClaim])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [string] $Session = $env:CLAUDE_CODE_SESSION_ID
    )

    Assert-NotNullOrWhitespace $Session -ErrorText 'Lock-SharedConfig: no session id; pass -Session, or run it from a Claude Code session, which sets CLAUDE_CODE_SESSION_ID.'
    $path = Resolve-SharedConfigPath -Name $Name
    # The claim lasts as long as a run waits for the run lock, so a peer is never held up longer by an edit than by a run.
    $seconds = (Get-Config -Config timeouts).run_lock['wait_seconds']
    $now = [datetime]::UtcNow
    $claim = [Catzc.Tooling.Claude.EditorClaim]::Claim([Catzc.Tooling.Claude.EditorClaim]::DefaultFolder(), $path, $Session,
        $now.AddSeconds($seconds), $now)
    $until = $claim.Expires.ToString('HH:mm:ss', [cultureinfo]::InvariantCulture)
    if ($claim.Session -cne $Session) {
        throw "Lock-SharedConfig: '$Name' is claimed by session $($claim.Session) until $until UTC; wait for its Unlock-SharedConfig or the expiry."
    }
    Write-Message "Editor claim: '$Name' is session $Session's to edit until $until UTC"
    $claim
}
