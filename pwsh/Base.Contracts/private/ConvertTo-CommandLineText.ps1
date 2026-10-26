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

    # Each argument double-quoted, an inner quote as \", so CliRunner splits back the same arguments.
    @(foreach ($item in @($Executable) + $Argument) {
            '"' + $item.Replace('"', '\"') + '"'
        }) -join ' '
}
