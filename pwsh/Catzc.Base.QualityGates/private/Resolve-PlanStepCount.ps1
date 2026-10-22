function Resolve-PlanStepCount {
    [CmdletBinding(DefaultParameterSetName = 'Text')]
    [OutputType([pscustomobject], ParameterSetName = 'Text')]
    [OutputType([string], ParameterSetName = 'Count')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Text')]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory, ParameterSetName = 'Count')]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $Count
    )

    # The words a count is written in, by their number; any other count is written in digits.
    $words = @('', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve')
    if ($PSCmdlet.ParameterSetName -ceq 'Count') {
        $number = if ($Count -ge 1 -and $Count -lt $words.Count) {
            $words[$Count]
        }
        else {
            "$Count"
        }
        $noun = if ($Count -eq 1) {
            'step'
        }
        else {
            'steps'
        }
        return "$number $noun"
    }

    $match = [regex]::Match($Text, "(?i)\b(?<n>\d+|$($words[1..($words.Count - 1)] -join '|'))\s+steps?\b")
    if (-not $match.Success) {
        return
    }
    $number = $match.Groups['n'].Value.ToLowerInvariant()
    $index = [Array]::IndexOf($words, $number)
    [pscustomobject]@{
        Index  = $match.Index
        Length = $match.Length
        Count  = if ($index -gt 0) {
            $index
        }
        else {
            [int] $number
        }
    }
}
