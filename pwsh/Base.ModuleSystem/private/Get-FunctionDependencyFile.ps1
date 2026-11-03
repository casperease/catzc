function Get-FunctionDependencyFile {
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Stamp
    )

    # Null when there is no usable file for this stamp: absent, unreadable, or written for other script contents.
    if (-not [System.IO.File]::Exists($Path)) {
        return $null
    }
    try {
        $content = [System.IO.File]::ReadAllText($Path) | ConvertFrom-Json
    }
    catch {
        Write-Message "Ignoring an unreadable function dependency file at '$Path': $($_.Exception.Message)"
        return $null
    }
    if ($content.Stamp -ne $Stamp) {
        return $null
    }
    , @($content.Edges)
}
