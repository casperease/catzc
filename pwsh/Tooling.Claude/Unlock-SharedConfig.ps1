function Unlock-SharedConfig {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [string] $Session = $env:CLAUDE_CODE_SESSION_ID
    )

    Assert-NotNullOrWhitespace $Session -ErrorText 'Unlock-SharedConfig: no session id; pass -Session, or run it from a Claude Code session, which sets CLAUDE_CODE_SESSION_ID.'
    $path = Resolve-SharedConfigPath -Name $Name
    $held = [Catzc.Tooling.Claude.EditorClaim]::Release([Catzc.Tooling.Claude.EditorClaim]::DefaultFolder(), $path, $Session,
        [datetime]::UtcNow)
    if ($held) {
        throw "Unlock-SharedConfig: '$Name' is claimed by session $($held.Session) until $($held.Expires.ToString('HH:mm:ss', [cultureinfo]::InvariantCulture)) UTC, so this session has no claim to release."
    }
    Write-Message "Editor claim: '$Name' is free to claim"
}
