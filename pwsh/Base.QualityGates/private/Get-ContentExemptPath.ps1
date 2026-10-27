function Get-ContentExemptPath {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    $classNames = 'linguist-vendored', 'linguist-generated', 'catzc-fixture', 'catzc-contract', 'catzc-unordered'
    if ($Path.Count -eq 0) {
        return , [string[]] @()
    }
    $attributes = Get-GitAttributeValue -RepositoryRoot $RepositoryRoot -Path $Path -Attribute $classNames
    # Loops, not Where-Object: a scan of the whole repository is thousands of paths.
    , [string[]] @(foreach ($file in $Path) {
            $classes = $attributes[$file]
            if (-not $classes) {
                continue
            }
            foreach ($name in $classNames) {
                if ($classes[$name] -in 'set', 'true') {
                    $file
                    break
                }
            }
        })
}
