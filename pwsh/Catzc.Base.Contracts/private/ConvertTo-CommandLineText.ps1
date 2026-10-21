<#
---
catzc:
  immutable:
    with_body_sha: bc651ce655a1
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

    # The command line CliRunner splits back into the same arguments: each in double quotes, an inner quote escaped as \".
    @(foreach ($item in @($Executable) + $Argument) {
            '"' + $item.Replace('"', '\"') + '"'
        }) -join ' '
}
