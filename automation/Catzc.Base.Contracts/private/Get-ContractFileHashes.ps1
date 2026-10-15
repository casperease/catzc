<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractFileHashes.ps1
    kind: automation-function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-AUTO-PATH#2
      - ADR-PWSH-ENUM#3
      - ADR-REPO-CONTRACT#5
  config:
    synopsis: Hashes every file of one contract version folder, the content a release freezes.
    description: |-
      A released version folder is immutable
      ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)); its .frozen record holds the
      hashes this returns, so a later change to any file shows as a different hash. Every file under the folder counts, at
      any depth, contract.yml included; only the record itself, .frozen directly in the folder, does not.

      Each hash is the SHA-256 of the file's bytes with every CRLF read as LF. Contract assets are text, and a checkout
      with core.autocrlf materialises them with CRLF while another checkout of the same commit has LF; reading line
      endings as LF gives every checkout of one commit the same hashes.
    parameters:
      Folder: The version folder's absolute path.
    outputs: |-
      [System.Collections.Specialized.OrderedDictionary] The path under the folder, in communication form
      ([ADR-AUTO-PATH#2](/docs/adr/automation/path-representation.md#rule-adr-auto-path2)), to its lowercase hex SHA-256,
      in ordinal order of path; keys compare ordinally.
    examples:
      - Get-ContractFileHashes -Folder $versionFolder
---
#>

function Get-ContractFileHashes {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder
    )

    # A named whole-tree walk: a frozen contract is hashed in full, so no name is pruned and no depth drops a file.
    # [comment:2](/docs/references/automation/catzc-base-contracts/private/Get-ContractFileHashes.ps1.md#comment2)
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
