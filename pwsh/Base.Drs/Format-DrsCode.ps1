function Format-DrsCode {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string] $Code,

        [ValidateSet('Full', 'RecordRule', 'KindRule', 'Rule')]
        [string] $Part = 'Full'
    )

    process {
        Assert-DrsCode $Code -Rule
        $segments = $Code.Split('-')
        switch ($Part) {
            'Full' {
                $Code
            }
            'RecordRule' {
                "$($segments[-2])-$($segments[-1])"
            }
            'KindRule' {
                "$($segments[0])-$($segments[-1])"
            }
            'Rule' {
                $segments[-1]
            }
        }
    }
}
