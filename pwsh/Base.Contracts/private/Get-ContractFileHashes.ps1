function Get-ContractFileHashes {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder
    )

    # A named whole-tree walk: a frozen contract is hashed in full, so nothing is pruned.
    $files = [string[]] @(Get-ChildPath $Folder -File -Depth 64 -Exclude @() -PruneVendor $false)
    $paths = [string[]] @($files |
            ForEach-Object { [System.IO.Path]::GetRelativePath($Folder, $_) -replace '\\', '/' } |
            Where-Object { $_ -cne '.frozen' })
    [System.Array]::Sort($paths, [System.StringComparer]::Ordinal)

    $hashes = [System.Collections.Specialized.OrderedDictionary]::new([System.StringComparer]::Ordinal)
    foreach ($path in $paths) {
        # Latin1 maps each byte to one char and back, so only the CRLF pairs change.
        $text = [System.Text.Encoding]::Latin1.GetString([System.IO.File]::ReadAllBytes((Join-Path $Folder $path)))
        $bytes = [System.Text.Encoding]::Latin1.GetBytes($text.Replace("`r`n", "`n"))
        $hashes[$path] = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($bytes)).ToLowerInvariant()
    }
    $hashes
}
