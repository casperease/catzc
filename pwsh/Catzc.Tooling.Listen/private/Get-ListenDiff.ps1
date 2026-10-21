<#
---
catzc:
  immutable:
    with_body_sha: d91166b0c4c4
---
#>

function Get-ListenDiff {
    <#
    .SYNOPSIS
        The unified diff of two files outside any repository (git diff --no-index); a missing side diffs as empty.

    .DESCRIPTION
        git diff --no-index exits 1 when the files differ, so the exit code is not asserted. The header lines name the two temporary
        sides, so the diff starts at its first hunk.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Before,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $After
    )

    $empty = $null
    try {
        $sides = foreach ($side in $Before, $After) {
            if ($side -and [System.IO.File]::Exists($side)) {
                $side
            }
            else {
                if (-not $empty) {
                    $empty = [System.IO.Path]::GetTempFileName()
                }
                $empty
            }
        }
        $result = Invoke-Executable "git diff --no-index --no-color -- `"$($sides[0])`" `"$($sides[1])`"" -PassThru -Silent -NoAssert
        $lines = @($result.Output -split '\r?\n')
        $first = [Array]::FindIndex($lines, [Predicate[string]] { param($line) $line.StartsWith('@@') -or $line.StartsWith('Binary files') })
        if ($first -lt 0) {
            return ''
        }
        ($lines[$first..($lines.Count - 1)] -join "`n").TrimEnd()
    }
    finally {
        if ($empty) {
            [System.IO.File]::Delete($empty)
        }
    }
}
