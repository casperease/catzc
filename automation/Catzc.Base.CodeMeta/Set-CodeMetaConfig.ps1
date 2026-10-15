<#
.SYNOPSIS
    Returns a code text with the `config` lines of its meta head replaced, the derived part kept as it is.
.DESCRIPTION
    A text with no head comes back as it was, and no lines remove the config part (ADR-REPO-FILEMETA#1).
.PARAMETER Text
    The whole code file as text.
.PARAMETER Form
    The head's comment syntax: a Catzc.Base.CodeMeta.HeadForm.
.PARAMETER Config
    The authored lines under `config`, as written, indented four spaces for a key of the part.
.OUTPUTS
    [string] the whole text, with the config part replaced.
#>
function Set-CodeMetaConfig {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [Catzc.Base.CodeMeta.HeadForm] $Form,

        [AllowEmptyCollection()]
        [string[]] $Config = @()
    )

    $head = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($Text, $Form)
    if (-not $head.HasHead) {
        return $Text
    }
    $head.WithConfig([string[]] @($Config))
}
