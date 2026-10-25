<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-files/Get-InputStamp.ps1.md"
  header: "generated"
---
#>

function Get-InputStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [string] $Filter = '*',

        [string[]] $Exclude = @(),

        [string] $Root = (Get-RepositoryRoot),

        [string] $Salt = '',

        [Catzc.Base.Files.InputStampIdentity] $By = [Catzc.Base.Files.InputStamp]::DefaultIdentity
    )

    [Catzc.Base.Files.InputStamp]::Compute($Path, $Filter, $Exclude, $Root, $Salt, $By)
}
