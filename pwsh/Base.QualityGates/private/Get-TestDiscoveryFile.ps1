function Get-TestDiscoveryFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if ([System.IO.Directory]::Exists($full)) {
        return [string[]]@(Get-ChildPath $full -File -Filter '*.Tests.ps1' -Depth 3)
    }
    # A file, or a path that does not exist: Pester says what is wrong with the latter.
    [string[]]@($Path)
}
