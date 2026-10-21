<#
---
catzc:
  immutable:
    with_body_sha: "2b20033ebcf0"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Split-CommandLineBatch.Tests.ps1
    docs: "[Split-CommandLineBatch.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Split-CommandLineBatch.ps1.md)"
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
