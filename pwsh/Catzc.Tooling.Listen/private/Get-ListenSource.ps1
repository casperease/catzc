function Get-ListenSource {
    <#
    .SYNOPSIS
        Says who made a file's current bytes: an agent session, the editor, or nobody the ledgers know.

    .DESCRIPTION
        Reads the two write ledgers: the agent ledger the Record-AgentWrite hook appends for every Claude Code session, and the editor
        ledger the catzc-save-ledger extension appends for every save, and ranks them as WriteLedger.SourceOf does: an agent's exact write,
        then the editor's exact save, then a write inside an agent's Bash call (a formatter or generator an agent ran), else unknown, such
        as a git checkout, a script outside Claude, another editor, or a ledger out/ lost. A Bash call whose end is not recorded stays open
        at most the Bash background limit of the time safeguard.

    .PARAMETER Path
        The repository-relative path.

    .PARAMETER Hash
        The file's current content hash (DurableHash); none for a deleted file.

    .PARAMETER WrittenAt
        The file's last write time; none for a deleted file.

    .OUTPUTS
        [Catzc.Tooling.Listen.WriteSource] with source (agent, editor or unknown) and agent (the agent's session id).
    #>
    [CmdletBinding()]
    [OutputType([Catzc.Tooling.Listen.WriteSource])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $Hash,

        [Nullable[DateTimeOffset]] $WrittenAt
    )

    $root = Get-RepositoryRoot
    $agent = [Catzc.Tooling.Listen.WriteLedger]::Read((Join-Path $root ([Catzc.Tooling.Listen.WriteLedger]::AgentLedger)))
    $editor = [Catzc.Tooling.Listen.WriteLedger]::Read((Join-Path $root ([Catzc.Tooling.Listen.WriteLedger]::EditorLedger)))
    [Catzc.Tooling.Listen.WriteLedger]::SourceOf($agent, $editor, $Path, $Hash, $WrittenAt, (Get-TimeoutSeconds -Shell Bash -Background), [DateTimeOffset]::Now)
}
