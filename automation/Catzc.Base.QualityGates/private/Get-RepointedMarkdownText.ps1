<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-RepointedMarkdownText.ps1
    folder: private
    name: get-repointed-markdown-text
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
    test: automation/Catzc.Base.QualityGates/tests/Get-RepointedMarkdownText.Tests.ps1
    cites:
      - ADR-REPO-FORMAT#7
---
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
