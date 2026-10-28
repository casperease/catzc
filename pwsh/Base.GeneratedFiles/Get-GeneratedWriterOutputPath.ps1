function Get-GeneratedWriterOutputPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Variants.GeneratedWriterRow] $Writer,

        [Parameter(Mandatory)]
        [Catzc.Base.Variants.GeneratedWriterRow[]] $Writers,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    # Every row's output glob competes for a path; the one with the most literal characters claims it, the first in the rows on a tie.
    $globs = @(foreach ($row in @(@($Writer) + @($Writers | Where-Object { $_.name -cne $Writer.name }))) {
            foreach ($output in $row.outputs) {
                [pscustomobject] @{
                    Name    = $row.name
                    Pattern = [Catzc.Base.Objects.GlobPattern]::new($output.path)
                    Literal = ($output.path -replace '[*?\[\]]', '').Length
                }
            }
        })
    $claimed = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($file in @($Path | Where-Object { $_ } | ForEach-Object { $_.Replace('\', '/') })) {
        $owner = $null
        $best = -1
        foreach ($glob in $globs) {
            if ($glob.Literal -gt $best -and $glob.Pattern.Matches($file)) {
                $owner = $glob.Name
                $best = $glob.Literal
            }
        }
        if ($owner -ceq $Writer.name) {
            [void] $claimed.Add($file)
        }
    }
    [string[]] @($claimed)
}
