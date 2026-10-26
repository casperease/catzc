<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Assert-AccostedArgument.ps1.md"
  header: "generated"
---
#>

function Assert-AccostedArgument {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Contracts.ContractParameter] $Parameter,

        [AllowNull()]
        [object] $Value,

        [Parameter(Mandatory)]
        [string] $Where,

        [Parameter(Mandatory)]
        [string] $Signature
    )

    $name = $Parameter.Name
    # cats passes one value per parameter, so a call that must run under every engine gives each parameter one literal.
    Assert-True ($Value -isnot [array]) -ErrorText "${Where}: '$name' is given a list; cats passes one value per parameter, so give one literal ($Signature)."
    foreach ($item in @(, $Value)) {
        $fits = switch ($Parameter.Type) {
            'string' {
                $item -is [string]
            }
            'int' {
                $item -is [int] -or $item -is [long]
            }
            { $_ -in 'bool', 'switch' } {
                $item -is [bool]
            }
            default {
                $false
            }
        }
        Assert-True $fits -ErrorText "${Where}: '$name' takes $($Parameter.Spec), and '$item' is not one ($Signature)."
    }
}
