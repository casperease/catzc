function Get-ReadmeGeneratedTarget {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedTarget])]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Class
    )

    $readme = Get-Config -Config readme
    foreach ($pattern in $readme.patterns) {
        [Catzc.Base.Variants.GeneratedTarget]::new("$($pattern.glob)/README.md", $Name, $Class)
    }
    foreach ($mapping in $readme.mappings) {
        [Catzc.Base.Variants.GeneratedTarget]::new("$($mapping.folder)/README.md", $Name, $Class)
    }
}
