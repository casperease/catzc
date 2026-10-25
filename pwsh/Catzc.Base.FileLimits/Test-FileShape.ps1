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
