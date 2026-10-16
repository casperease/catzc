<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/Set-InputStamp.ps1
    name: set-input-stamp
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-files/Set-InputStamp.ps1.md
    test: automation/Catzc.Base.Files/tests/Set-InputStamp.Tests.ps1
    cites:
      - ADR-AUTO-DRYRUN
      - ADR-PRIN-ONELIVE
  config:
    synopsis: Stores the stamp a generator was last built from, under its name.
    description: |-
      Writes -Stamp (Get-InputStamp) to the output root's `.stamps/<Name>.stamp` through Write-FileIfChanged, so a stamp
      that is already stored is not rewritten. A generator calls this after its output is written, with the stamp it
      computed before reading its inputs, so an input edited mid-run is still seen as changed on the next run.
    parameters:
      Name: The stamp's name, one per skipping generator (for example `Build-Glossary`).
      Stamp: The stamp to store, from Get-InputStamp.
      DryRun: Report whether the stored stamp would change without writing it. See [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
    outputs: '[bool] $true when the stored stamp was written (or would be, under -DryRun); $false when it was already current.'
    examples:
      - Set-InputStamp -Name Build-Glossary -Stamp $stamp
---
#>

function Set-InputStamp {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('^[A-Za-z0-9._-]+$')]
        [string] $Name,

        [Parameter(Mandatory, Position = 1)]
        [string] $Stamp,

        [switch] $DryRun
    )

    $file = [System.IO.Path]::Combine((Get-OutputRoot), '.stamps', "$Name.stamp")
    Write-FileIfChanged $file $Stamp -DryRun:$DryRun
}
