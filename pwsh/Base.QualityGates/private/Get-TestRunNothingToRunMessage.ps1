function Get-TestRunNothingToRunMessage {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [int] $TestFileCount,

        [Parameter(Mandatory)]
        [int] $MinLevel,

        [Parameter(Mandatory)]
        [int] $MaxLevel
    )

    # An empty selection and a work-list that protection drained are told apart.
    if ($TestFileCount -eq 0) {
        return "No test in scope at L$MinLevel-L$MaxLevel — nothing to run."
    }
    'Every module in scope is protected — nothing to run.'
}
