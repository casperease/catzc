<#
.SYNOPSIS
    Splits a list of command-line arguments into batches whose joined length stays under a limit.
.DESCRIPTION
    A formatter engine that takes files as arguments runs once per batch, so formatting every tracked file never
    exceeds the command-line length. The binding limit is cmd.exe's 8 191 characters: npm installs tools such as
    prettier as .cmd shims, which cmd.exe expands with the node path prepended, so the default leaves room for that.
    Each item is counted with the quotes and the separating space it is written with. An item longer than the limit
    is a batch of its own.
.PARAMETER Item
    The arguments, in order.
.PARAMETER MaxLength
    The longest joined batch, in characters.
.OUTPUTS
    [string[][]] The batches, in order; each is one array.
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
