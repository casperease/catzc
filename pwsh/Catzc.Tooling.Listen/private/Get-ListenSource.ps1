<#
---
catzc:
  immutable:
    with_body_sha: f2f860600160
  edges:
    docs: "[Get-ListenSource.ps1.md](../../../docs/references/pwsh/catzc-tooling-listen/private/Get-ListenSource.ps1.md)"
---
#>

function Get-ListenSource {
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
