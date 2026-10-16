<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/Test-InputStamp.ps1
    name: test-input-stamp
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-files/Test-InputStamp.ps1.md
    test: automation/Catzc.Base.Files/tests/Test-InputStamp.Tests.ps1
    cites:
      - ADR-PRIN-ONELIVE
  config:
    synopsis: Tells whether the stamp stored under a name still equals a given stamp.
    description: |-
      Compares a stamp (Get-InputStamp) with the one Set-InputStamp stored for -Name in the output root's `.stamps`
      folder. A name with nothing stored is not current. A generator calls this before it gathers its inputs: current
      means its output was built from exactly these inputs, so it returns without reading them.

      The stamps live in the gitignored output root, so they are per working tree, never committed, and a clean clone
      rebuilds everything once.
    parameters:
      Name: The stamp's name, one per skipping generator (for example `Build-Glossary`).
      Stamp: The current stamp, from Get-InputStamp.
    outputs: '[bool] $true when the stored stamp equals -Stamp; $false when it differs or none is stored.'
    examples:
      - Test-InputStamp -Name Build-Glossary -Stamp $stamp
---
#>

function Test-InputStamp {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('^[A-Za-z0-9._-]+$')]
        [string] $Name,

        [Parameter(Mandatory, Position = 1)]
        [string] $Stamp
    )

    $file = [System.IO.Path]::Combine((Get-OutputRoot), '.stamps', "$Name.stamp")
    [System.IO.File]::Exists($file) -and ([System.IO.File]::ReadAllText($file).Trim() -ceq $Stamp)
}
