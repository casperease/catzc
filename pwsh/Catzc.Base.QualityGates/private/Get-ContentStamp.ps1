<#
---
catzc:
  immutable:
    with_body_sha: "4b2c2c19020a"
  edges:
    docs: "[Get-ContentStamp.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-ContentStamp.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS
---
#>

function Get-ContentStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Label,

        [AllowEmptyCollection()]
        [string[]] $File = @(),

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $parts = [System.Collections.Generic.List[string]]::new()
    $parts.Add("label:$Label")
    foreach ($path in $File) {
        $relative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $path) -replace '\\', '/'
        $hash = if (-not [System.IO.File]::Exists($path)) {
            'missing'
        }
        else {
            $bytes = [System.IO.File]::ReadAllBytes($path)
            if ([System.IO.Path]::GetExtension($path) -in '.ps1', '.psm1', '.psd1') {
                $tokens = $null
                $parseErrors = $null
                [void] [System.Management.Automation.Language.Parser]::ParseFile($path, [ref] $tokens, [ref] $parseErrors)
                if (-not $parseErrors) {
                    $previousWasLineEnd = $true
                    $code = foreach ($token in $tokens) {
                        if ($token.Kind -eq [System.Management.Automation.Language.TokenKind]::Comment) {
                            continue
                        }
                        $isLineEnd = $token.Kind -eq [System.Management.Automation.Language.TokenKind]::NewLine
                        if ($isLineEnd -and -not $previousWasLineEnd) {
                            '<eol>'
                        }
                        elseif (-not $isLineEnd) {
                            $token.Text
                        }
                        $previousWasLineEnd = $isLineEnd
                    }
                    $bytes = [System.Text.Encoding]::UTF8.GetBytes('tokens:' + ($code -join "`n"))
                }
            }
            [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($bytes))
        }
        $parts.Add("${relative}:$hash")
    }
    [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($parts -join "`n")))
}
