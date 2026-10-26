function Assert-True {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object] $Value,

        [string] $ErrorText
    )

    if (-not (($Value -is [bool]) -and $Value)) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Assertion failed: expected `$true — {0}, line {1}" -f $MyInvocation.ScriptName, $MyInvocation.ScriptLineNumber
        }
        throw $message
    }
}
