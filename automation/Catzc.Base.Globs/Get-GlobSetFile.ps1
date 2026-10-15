# catzc:
#   path: automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
#   module: Catzc.Base.Globs
#   visibility: public

<#
.SYNOPSIS
    Returns the tracked files a globset matches — the deployable unit's actual members.
.DESCRIPTION
    A member deleted on disk but still tracked stays listed, so the durable SHA sees the deletion.
    [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4),
    [ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)
    [comment:1](/docs/references/automation/catzc-base-globs/Get-GlobSetFile.ps1.md#comment1)
.PARAMETER Name
    The globset whose members to list.
.EXAMPLE
    Get-GlobSetFile -Name automation
#>
function Get-GlobSetFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name
    )

    Get-GlobSetMember -GlobSet (Get-GlobSet -Name $Name)
}
