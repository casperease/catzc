<#
.SYNOPSIS
    Returns a JSON text with its meta property imprinted from the given facts.
.DESCRIPTION
    The same facts always give the same bytes, so a second run changes no file. A text that is no JSON object, or whose property
    holds something else, comes back as it was.
.PARAMETER Text
    The whole JSON file as text.
.PARAMETER Property
    The name of the ignored top-level property that holds the block (e.g. // or $comment).
.PARAMETER Strip
    Beginnings of old values of the property that are replaced.
.PARAMETER Fact
    The derived facts, an ordered dictionary of key to value; no facts removes the property.
.OUTPUTS
    [string] the whole text, with the property written first.
.EXAMPLE
    Format-PropertyMetaHead -Text $text -Property '//' -Fact ([ordered]@{ path = 'widget/gadget.json'; kind = 'other' })
#>
function Format-PropertyMetaHead {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [string] $Property,

        [string[]] $Strip = @(),

        [System.Collections.IDictionary] $Fact = [ordered]@{}
    )

    [Catzc.Base.CodeMeta.PropertyHead]::Parse($Text, $Property, $Strip).WithFacts($Fact)
}
