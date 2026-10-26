function Write-TestRunManifest {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Manifest
    )

    Assert-PathExist $RunDirectory -PathType Container

    $path = Join-Path $RunDirectory 'run.json'
    $temp = "$path.$PID.tmp"

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($temp, (ConvertTo-Json -InputObject $Manifest -Depth 4), $utf8NoBom)
    [System.IO.File]::Move($temp, $path, $true)

    $path
}
