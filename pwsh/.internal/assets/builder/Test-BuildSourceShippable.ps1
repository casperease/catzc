function Test-BuildSourceShippable {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $Index.ContainsKey([System.IO.Path]::GetRelativePath($SourceRoot, $Path).Replace('\', '/'))
}
