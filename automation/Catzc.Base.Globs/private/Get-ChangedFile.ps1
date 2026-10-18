<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
    folder: private
    name: get-changed-file
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
    cites:
      - ADR-FLOW-CD-GLOBS#4
---
#>

function Get-ChangedFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Range
    )

    $ret = Invoke-Executable "git -c core.quotepath=off diff --name-only --no-renames $Range" -PassThru -Silent
    $ret.Output -split "`r?`n" | Where-Object { $_ -ne '' }
}
