<#
.SYNOPSIS
    Throws when a build holds more files or bytes than its bundle's footprint limits allow.
.DESCRIPTION
    A limit the bundle does not state is not checked; every exceeded limit is reported in one throw.
    [ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md)
    [comment:1](/docs/references/automation/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md#comment1)
.PARAMETER Path
    The build root (the Catzc/<version>/ folder).
.PARAMETER Bundle
    The bundle's exporter.yml entry (an ExporterBundle).
.OUTPUTS
    [pscustomobject] Files, Bytes — the measured footprint, also when no limit is stated.
#>
function Assert-BundleFootprint {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [object] $Bundle
    )

    $root = [System.IO.Path]::GetFullPath($Path)
    $files = 0
    $bytes = [long] 0
    $byFolder = @{}
    foreach ($file in [System.IO.Directory]::EnumerateFiles($root, '*', [System.IO.SearchOption]::AllDirectories)) {
        $length = [System.IO.FileInfo]::new($file).Length
        $files++
        $bytes += $length
        $top = [System.IO.Path]::GetRelativePath($root, $file).Replace('\', '/').Split('/')[0]
        $byFolder[$top] = [long] $byFolder[$top] + $length
    }

    $exceeded = [System.Collections.Generic.List[string]]::new()
    if ($null -ne $Bundle.max_files -and $files -gt $Bundle.max_files) {
        $exceeded.Add("$files files, over max_files $($Bundle.max_files)")
    }
    if ($null -ne $Bundle.max_bytes -and $bytes -gt $Bundle.max_bytes) {
        $exceeded.Add("$bytes bytes, over max_bytes $($Bundle.max_bytes)")
    }
    if ($exceeded.Count -gt 0) {
        $heaviest = @($byFolder.GetEnumerator() | Sort-Object -Property Value -Descending | Select-Object -First 5 |
                ForEach-Object { "$($_.Key) $($_.Value)" })
        throw ("Bundle '$($Bundle.name)' outgrew its footprint limits in exporter.yml: $($exceeded -join '; '). " +
            "Heaviest top-level entries (bytes): $($heaviest -join ', '). Trim the bundle's profile, or raise the limit in a reviewed edit.")
    }

    [pscustomobject]@{ Files = $files; Bytes = $bytes }
}
