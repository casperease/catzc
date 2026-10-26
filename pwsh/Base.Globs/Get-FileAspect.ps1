function Get-FileAspect {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        # Repository-relative, '/'-separated paths.
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    # The sets are built once per call, by the one place that builds them.
    $sets = Get-AspectGlobSet
    $aspects = [ordered]@{}
    foreach ($file in $Path) {
        $relative = $file.Replace('\', '/')
        $aspect = [Catzc.Base.Globs.AspectPartition]::AspectOf($sets, $relative)
        $aspects[$file] = if ($null -eq $aspect) {
            ''
        }
        else {
            $aspect
        }
    }
    $aspects
}
