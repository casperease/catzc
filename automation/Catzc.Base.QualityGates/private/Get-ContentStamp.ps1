<#
.SYNOPSIS
    The fingerprint of a set of input files: one SHA-256 over a label and each file's path and content hash.
.DESCRIPTION
    A quality check's result cache keys each file on its own SHA-256 and this stamp of everything else that decides
    the check's verdict ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). A missing input
    hashes as missing, so adding, editing or removing one changes the stamp, and every cached verdict of that check is
    checked again. The files are fingerprinted in the given order under their repository-relative paths, so the stamp
    is the same on every clone.

    A PowerShell input (.ps1, .psm1, .psd1 — an analyzer rule, a settings file) is fingerprinted by its tokens without
    its comments: a comment never decides a verdict, and comments in rule files change often (an ADR citation sweep
    rewrites them), which would otherwise send every file back through the check. Every change to the code itself
    still changes the stamp. A PowerShell file that does not parse, and every other input, is fingerprinted by its
    bytes.
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
        $hash = if ([System.IO.File]::Exists($path)) {
            [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($path)))
        }
        else {
            'missing'
        }
        $parts.Add("${relative}:$hash")
    }
    [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($parts -join "`n")))
}
