<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-ContentStamp.ps1
    folder: private
    name: get-content-stamp
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-ContentStamp.ps1.md
    cites:
      - ADR-AUTO-CACHE#10
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
