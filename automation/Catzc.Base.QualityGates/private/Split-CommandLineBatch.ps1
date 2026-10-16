<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Split-CommandLineBatch.ps1
    folder: private
    name: split-command-line-batch
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Split-CommandLineBatch.Tests.ps1
  config:
    synopsis: Splits a list of command-line arguments into batches whose joined length stays under a limit.
    description: |-
      A formatter engine that takes files as arguments runs once per batch, so formatting every tracked file never
      exceeds the command-line length. The binding limit is cmd.exe's 8 191 characters: npm installs tools such as
      prettier as .cmd shims, which cmd.exe expands with the node path prepended, so the default leaves room for that.
      Each item is counted with the quotes and the separating space it is written with. An item longer than the limit
      is a batch of its own.
    parameters:
      Item: The arguments, in order.
      MaxLength: The longest joined batch, in characters.
    outputs: '[string[]] One array per batch, in order.'
---
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
