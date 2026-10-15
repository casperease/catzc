<#
.SYNOPSIS
    The fingerprint of a set of input files: one SHA-256 over a label and each file's path and content hash.
.DESCRIPTION
    A quality check's result cache keys each file on its own SHA-256 and this stamp of everything else that decides...
    [ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-ContentStamp.ps1.md#comment1)
.PARAMETER Label
    What the stamp is for (an engine or check name); two checks never share a stamp.
.PARAMETER File
    The input files, absolute paths.
.PARAMETER RepositoryRoot
    The root the paths are recorded relative to.
.OUTPUTS
    [string] A hex SHA-256.
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
                    # Comments go; a run of line ends (what a removed comment line leaves) counts as one, since a...
                    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-ContentStamp.ps1.md#comment2)
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
