<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Split-CommandLineBatch.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Splits a list of command-line arguments into batches whose joined length stays under a limit.
.DESCRIPTION
    The default limit leaves room for cmd.exe's 8191 characters, as npm .cmd shims prepend the node path.
.PARAMETER Item
    The arguments, in order.
.PARAMETER MaxLength
    The longest joined batch, in characters.
.OUTPUTS
    [string[]] One array per batch, in order.
#>
function Split-CommandLineBatch {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Item,

        [int] $MaxLength = 4000
    )

    $batch = [System.Collections.Generic.List[string]]::new()
    $length = 0
    foreach ($argument in $Item) {
        $cost = $argument.Length + 3
        if ($batch.Count -gt 0 -and $length + $cost -gt $MaxLength) {
            , [string[]] $batch.ToArray()
            $batch = [System.Collections.Generic.List[string]]::new()
            $length = 0
        }
        $batch.Add($argument)
        $length += $cost
    }
    if ($batch.Count -gt 0) {
        , [string[]] $batch.ToArray()
    }
}
