<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
    kind: function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-FLOW-CD-GLOBS#4
      - ADR-FLOW-CD-GLOBS#5
---
#>

<#
.SYNOPSIS
    Returns the tracked files a globset matches — the deployable unit's actual members.
.DESCRIPTION
    A member deleted on disk but still tracked stays listed, so the durable SHA sees the deletion.
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
