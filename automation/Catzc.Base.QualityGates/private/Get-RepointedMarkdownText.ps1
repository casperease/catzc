<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-RepointedMarkdownText.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    Re-points a Markdown file's #fragment links at headings whose anchor changed, and returns the text.
.DESCRIPTION
    Only the fragment changes; link text, the target as written and all other bytes stay, so no match returns the input.
    [ADR-REPO-FORMAT#7](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format7)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-RepointedMarkdownText.ps1.md#comment1)
.PARAMETER RelativePath
    The file's repository-relative, '/'-separated path.
.PARAMETER Text
    The file's content.
.PARAMETER Rename
    '<repository-relative path>#<old anchor>' -> new anchor.
.OUTPUTS
    [string] the text with matching fragments re-pointed.
#>
function Get-RepointedMarkdownText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RelativePath,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [hashtable] $Rename
    )

    $directory = [System.IO.Path]::GetDirectoryName($RelativePath) -replace '\\', '/'
    # Normalize ./ and ../ against a stand-in root, then drop it again.
    $standIn = [System.IO.Path]::GetFullPath('/repository-root')
    $builder = [System.Text.StringBuilder]::new($Text.Length)
    $copied = 0
    foreach ($match in [regex]::Matches($Text, '\]\((?<target>[^)\s#]*)#(?<fragment>[^)\s]+)\)')) {
        $target = $match.Groups['target'].Value
        $resolved = if ($target -eq '') {
            $RelativePath
        }
        else {
            [System.IO.Path]::GetRelativePath($standIn, [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($standIn, $directory, $target))) -replace '\\', '/'
        }
        $key = "$resolved#$($match.Groups['fragment'].Value)"
        if (-not $Rename.ContainsKey($key)) {
            continue
        }
        [void] $builder.Append($Text, $copied, $match.Index - $copied).Append("]($target#$($Rename[$key]))")
        $copied = $match.Index + $match.Length
    }
    [void] $builder.Append($Text, $copied, $Text.Length - $copied)
    $builder.ToString()
}
