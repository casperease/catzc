function Assert-DrsCode {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Code,

        [switch] $Rule
    )

    $check = (Get-Config -Config drs-checks).code_language
    $violation = $check.Violation($Code, $Rule.IsPresent)
    Assert-True ($null -eq $violation) -ErrorText "Assert-DrsCode: $violation (ADR-REPO-DRSCODE-PATHOFSEGMENTS)"
}
