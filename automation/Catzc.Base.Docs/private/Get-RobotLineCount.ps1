<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-RobotLineCount.ps1
    folder: private
    name: get-robot-line-count
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-docs/private/Get-RobotLineCount.ps1.md
    cites:
      - ADR-REPO-AGENTS#{6,8}
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
