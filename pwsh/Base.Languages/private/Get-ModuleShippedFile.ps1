function Get-ModuleShippedFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Module,

        [switch] $ExecutableOnly
    )

    $prefix = "$($Module.TrimEnd('/'))/"
    $testPrefix = "$((Get-Config -Config languages).FolderOf('test'))/"
    $files = [System.Collections.Generic.List[string]]::new()
    foreach ($path in @(Get-GitTrackedPath $Module -ExecutableOnly:$ExecutableOnly)) {
        if (-not $path.StartsWith($prefix, [System.StringComparison]::Ordinal)) {
            continue
        }
        $relative = $path.Substring($prefix.Length)
        if (-not $relative.StartsWith($testPrefix, [System.StringComparison]::Ordinal)) {
            $files.Add($relative)
        }
    }
    $files.ToArray()
}
