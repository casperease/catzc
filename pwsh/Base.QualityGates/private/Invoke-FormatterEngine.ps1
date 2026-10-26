function Invoke-FormatterEngine {
    [CmdletBinding()]
    [OutputType([string[]], [pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Engine,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [switch] $DryRun
    )

    $adapter = Get-FormatEngineAdapter -Engine $Engine
    & $adapter -File $File -DryRun:$DryRun
}
