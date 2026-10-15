<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractFileHashes.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: private
---
#>

<#
.SYNOPSIS
    Hashes every file of one contract version folder, the content a release freezes.
.DESCRIPTION
    CRLF is read as LF before hashing, so a core.autocrlf checkout and an LF checkout of one commit hash the same.
    [ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Get-ContractFileHashes.ps1.md#comment1)
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
