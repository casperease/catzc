<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
    kind: automation-function
    module: Catzc.Base.Globs
    visibility: public
    relatives:
      test: automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
    adrs:
      - ADR-FLOW-CD-GLOBS#4
      - ADR-FLOW-CD-GLOBS#5
  config:
    synopsis: Returns the tracked files a globset matches — the deployable unit's actual members.
    description: |-
      Intersects the matching universe (`git ls-files`,
      [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)) with the named globset's
      membership
      (include minus exclude), ordinally sorted — the exact file list the durable SHA is computed over
      ([ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)). A member may be missing on
      disk (an unstaged deletion); it is still a member here.
    parameters:
      Name: The globset whose members to list.
    examples:
      - Get-GlobSetFile -Name automation
---
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
