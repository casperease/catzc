<#
---
catzc:
  immutable:
    with_body_sha: "5b5666a12078"
  edges:
    docs: "[Get-RobotLineCount.ps1.md](../../../docs/references/pwsh/catzc-base-docs/private/Get-RobotLineCount.ps1.md)"
    cites:
      - ADR-REPO-AGENTS-ROBOTBODYLIMIT
      - ADR-REPO-AGENTS-CAPABILITYFILE
---
#>

function Get-RobotLineCount {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [ValidateNotNullOrEmpty()]
        [string] $Key = [Catzc.Base.MarkdownMeta.MarkdownDocument]::MetaKey
    )

    Assert-PathExist $Path

    $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse([System.IO.File]::ReadAllText($Path), $Key)
    $front = @($document.OtherFrontMatter | Where-Object { $_ -cmatch '^\S' }).Count
    $body = @(($document.Body -split "`r?`n") | Where-Object { $_ -cmatch '^\S' -and $_ -cnotmatch '^<!--' }).Count
    [pscustomobject]@{ Body = $body; Capability = $front + $body }
}
