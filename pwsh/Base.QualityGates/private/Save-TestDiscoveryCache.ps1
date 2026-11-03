function Save-TestDiscoveryCache {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Cache
    )

    $sorted = [ordered]@{}
    foreach ($key in @($Cache.Keys | Sort-Object)) {
        $sorted[$key] = $Cache[$key]
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    $staging = "$Path.$PID.tmp"
    try {
        [System.IO.File]::WriteAllText($staging, (ConvertTo-Json -InputObject $sorted -Depth 8 -Compress) + "`n",
            [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::Move($staging, $Path, $true)
    }
    catch [System.IO.IOException], [System.UnauthorizedAccessException] {
        Write-Message "Skipped saving the test discovery cache at '$Path': $($_.Exception.Message)"
    }
    finally {
        if ([System.IO.File]::Exists($staging)) {
            [System.IO.File]::Delete($staging)
        }
    }
}
