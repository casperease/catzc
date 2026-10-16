<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Timeouts/Assert-CompletesWithin.ps1
    name: assert-completes-within
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Timeouts/tests/Assert-CompletesWithin.Tests.ps1
  config:
    synopsis: Asserts that a script block finishes within a time limit; past it the work is stopped and the assert throws.
    description: |-
      The assertion form of Invoke-WithTimeout: the block's output is discarded, and the only outcome is pass
      (it finished in time) or throw (it was stopped at the limit, or it failed on its own).
    parameters:
      ScriptBlock: The work to time.
      Budget: |-
        The work's immutable budget GUID. While timeout-exemptions.yml exempts it, the default limit is the exemption
        ceiling instead.
      Seconds: |-
        The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml, or the budget's exemption
        ceiling (Get-TimeoutSeconds -Budget).
      Activity: What the work is, for the timeout message. Defaults to the script block's text.
    examples:
      - Assert-CompletesWithin { Import-Widget } -Seconds 2
      - Assert-CompletesWithin { Sync-Widget } -Budget $widgetSyncBudget
---
#>

function Assert-CompletesWithin {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [guid] $Budget = [guid]::Empty,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Seconds = (Get-TimeoutSeconds -Budget $Budget),

        [string] $Activity = $ScriptBlock.ToString().Trim()
    )

    $null = Invoke-WithTimeout $ScriptBlock -Seconds $Seconds -Activity $Activity
}
