<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/private/Get-ChangedFile.ps1
    folder: private
    name: get-changed-file
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
    docs: "[Get-ChangedFile.ps1.md](docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md)"
    cites:
      - ADR-FLOW-CD-GLOBS-TRACKEDFILESONLY
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
