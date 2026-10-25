<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-FormatEngineStamp.ps1.md"
  header: "generated"
---
#>

function Get-FormatEngineStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Engine,

        [AllowEmptyCollection()]
        [string[]] $Settings = @(),

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $files = [System.Collections.Generic.List[string]]::new()
    $keyed = [System.Collections.Generic.List[string]]::new()
    foreach ($entry in $Settings) {
        $hash = $entry.IndexOf('#')
        if ($hash -lt 0) {
            $files.Add((Join-Path $RepositoryRoot $entry))
            continue
        }
        $relative = $entry.Substring(0, $hash)
        $key = $entry.Substring($hash + 1)
        $path = Join-Path $RepositoryRoot $relative
        # A missing file or key hashes as missing, so adding or removing the input changes the stamp like any other input.
        $value = 'missing'
        if ([System.IO.File]::Exists($path)) {
            $document = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($path)) -Ordered
            if ($document -is [System.Collections.IDictionary] -and $document.Contains($key)) {
                $value = ConvertTo-Json -InputObject $document[$key] -Depth 32 -Compress
            }
        }
        $valueHash = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($value)))
        $keyed.Add("${relative}#${key}:$valueHash")
    }

    $stamp = Get-ContentStamp -Label "format:$Engine" -File $files.ToArray() -RepositoryRoot $RepositoryRoot
    if ($keyed.Count -eq 0) {
        return $stamp
    }
    $parts = @($stamp) + $keyed.ToArray()
    [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($parts -join "`n")))
}
