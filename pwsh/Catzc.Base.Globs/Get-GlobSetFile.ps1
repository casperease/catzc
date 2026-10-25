<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md"
  warning: "Generated Header"
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
