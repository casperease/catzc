# catzc:
#   path: automation/Catzc.Base.Asserts/Assert-PathExist.ps1
#   module: Catzc.Base.Asserts
#   visibility: public

<#
.SYNOPSIS
    Asserts that a filesystem path exists.
.PARAMETER Path
    The path to test.
.PARAMETER PathType
    The kind of path to require: Any (default), Container, or Leaf.
.EXAMPLE
    Assert-PathExist './config.json'
.EXAMPLE
    Assert-PathExist './src' -PathType Container
#>
function Assert-PathExist {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [ValidateSet('Any', 'Container', 'Leaf')]
        [string] $PathType = 'Any',

        [string] $ErrorText
    )

    if (-not (Test-Path -Path $Path -PathType $PathType)) {
        # Null coalescing never applies the default: a string parameter turns null into empty, and it tests null only.
        # [comment:1](/docs/references/automation/catzc-base-asserts/Assert-PathExist.ps1.md#comment1)
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Path does not exist: $Path"
        }
        throw $message
    }
}
