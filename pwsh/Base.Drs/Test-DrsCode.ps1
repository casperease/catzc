function Test-DrsCode {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Code,

        [switch] $Rule
    )

    $check = (Get-Config -Config drs-checks).code_language
    $null -eq $check.Violation($Code, $Rule.IsPresent)
}
