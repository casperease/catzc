<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/ConvertTo-CommandLineText.ps1.md"
  header: "generated"
---
#>

function ConvertTo-CommandLineText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Executable,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Argument
    )

    # The command line CliRunner splits back into the same arguments: each in double quotes, an inner quote escaped as
    # \".
    @(foreach ($item in @($Executable) + $Argument) {
            '"' + $item.Replace('"', '\"') + '"'
        }) -join ' '
}
