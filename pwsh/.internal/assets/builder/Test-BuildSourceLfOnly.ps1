function Test-BuildSourceLfOnly {
    # .SYNOPSIS
    #     Returns whether a source file ships LF-normalised: it is tracked and git stores it with LF-only endings.
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

    $isLfOnly = $false
    [void] $Index.TryGetValue([System.IO.Path]::GetRelativePath($SourceRoot, $Path).Replace('\', '/'), [ref] $isLfOnly)
    $isLfOnly
}
