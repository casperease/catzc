<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/Test-CompletesWithin.ps1
    kind: function
    subkind: gate
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Timeouts/tests/Test-CompletesWithin.Tests.ps1
  config:
    synopsis: Tests whether a script block finishes within a time limit; past it the work is stopped.
    description: |-
      The boolean form of Assert-CompletesWithin: $true when the block finished in time, $false when the safeguard
      stopped it at the limit. The block's output is discarded. An error the block raises on its own is not a
      timeout, so it still throws — this answers "was it fast enough", never "did it succeed".
    parameters:
      ScriptBlock: The work to time.
      Budget: |-
        The work's immutable budget GUID. While timeout-exemptions.yml exempts it, the default limit is the exemption
        ceiling instead.
      Seconds: |-
        The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml, or the budget's exemption
        ceiling (Get-TimeoutSeconds -Budget).
    examples:
      - if (-not (Test-CompletesWithin { Get-Widget } -Seconds 2)) { Write-Message 'widget lookup is slow' }
---
#>

function Test-CompletesWithin {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [guid] $Budget = [guid]::Empty,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Seconds = (Get-TimeoutSeconds -Budget $Budget)
    )

    try {
        $null = Invoke-WithTimeout $ScriptBlock -Seconds $Seconds
        $true
    }
    catch [System.TimeoutException] {
        $false
    }
}
