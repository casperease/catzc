<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-file-limits/Test-FileShape.ps1.md"
  header: "generated"
---
#>

function Test-FileShape {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string[]] $Path
    )

    process {
        foreach ($file in $Path) {
            $limit = Get-FileLimit -Path $file
            if ($null -eq $limit.length -and $null -eq $limit.width) {
                continue
            }
            $shape = Measure-FileShape -Path $file
            if ($null -ne $limit.length -and $shape.lines -gt $limit.length) {
                [pscustomobject]@{
                    Path    = $file
                    Line    = $shape.lines
                    Check   = 'length'
                    Value   = $shape.lines
                    Limit   = $limit.length
                    Source  = $limit.length_source
                    Message = "$($file):$($shape.lines) has $($shape.lines) lines, over the $($limit.file_class) limit $($limit.length) ($($limit.length_source))"
                }
            }
            if ($null -ne $limit.width -and $shape.width -gt $limit.width -and (Get-Config -Config file-limits).string_overflow -eq 'exempt') {
                # A line whose overflow lies wholly inside one string literal passes, so the width is the widest line that is not one.
                $text = [System.IO.File]::ReadAllText($file)
                $exemptLines = Get-StringOverflowLine -Text $text -Width $limit.width -Language $limit.language
                $exempt = [System.Collections.Generic.HashSet[int]]::new([int[]] $exemptLines)
                if ($exempt.Count -gt 0) {
                    $widest = 0
                    $widestLine = 0
                    $number = 0
                    foreach ($line in $text -split "`r?`n") {
                        $number++
                        $length = $line.TrimEnd().Length
                        if ($length -gt $widest -and -not $exempt.Contains($number)) {
                            $widest = $length
                            $widestLine = $number
                        }
                    }
                    $shape = [Catzc.Base.FileLimits.FileShape]::new($shape.path, $shape.lines, $widest, $widestLine)
                }
            }
            if ($null -ne $limit.width -and $shape.width -gt $limit.width) {
                [pscustomobject]@{
                    Path    = $file
                    Line    = $shape.widest_line
                    Check   = 'width'
                    Value   = $shape.width
                    Limit   = $limit.width
                    Source  = $limit.width_source
                    Message = "$($file):$($shape.widest_line) is $($shape.width) wide, over the $($limit.file_class) limit $($limit.width) ($($limit.width_source))"
                }
            }
        }
    }
}
