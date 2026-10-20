<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/private/Get-ContractFileHashes.ps1
    folder: private
    name: get-contract-file-hashes
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-ContractFileHashes.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractFileHashes.ps1.md)"
    cites:
      - ADR-AUTO-PATH-COMMUNICATIONFORM
      - ADR-PWSH-ENUM-ALWAYSBOUNDED
      - ADR-REPO-CONTRACT-RELEASEDIMMUTABLE
---
#>

function Get-ContractFileHashes {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder
    )

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
