<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md"
  header: "generated"
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
