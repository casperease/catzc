<#
.SYNOPSIS
    Hashes every file of one contract version folder, the content a release freezes.
.DESCRIPTION
    A released version folder is immutable
    ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)); its .frozen record holds the
    hashes this returns, so a later change to any file shows as a different hash. Every file under the folder counts, at
    any depth, contract.yml included; only the record itself, .frozen directly in the folder, does not.

    Each hash is the SHA-256 of the file's bytes with every CRLF read as LF. Contract assets are text, and a checkout
    with core.autocrlf materialises them with CRLF while another checkout of the same commit has LF; reading line
    endings as LF gives every checkout of one commit the same hashes.
.PARAMETER Folder
    The version folder's absolute path.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] The path under the folder, in communication form
    ([ADR-AUTO-PATH#2](/docs/adr/automation/path-representation.md#rule-adr-auto-path2)), to its lowercase hex SHA-256,
    in ordinal order of path; keys compare ordinally.
.EXAMPLE
    Get-ContractFileHashes -Folder $versionFolder
#>
function Get-ContractFileHashes {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder
    )

    $files = [string[]] [System.IO.Directory]::GetFiles($Folder, '*', [System.IO.SearchOption]::AllDirectories)
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
