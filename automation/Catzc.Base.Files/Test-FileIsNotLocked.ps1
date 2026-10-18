<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Files/Test-FileIsNotLocked.ps1
    name: test-file-is-not-locked
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
---
#>

function Test-FileIsNotLocked {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    -not (Test-FileIsLocked $Path)
}
