<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-RepointedMarkdownText.ps1
    folder: private
    name: get-repointed-markdown-text
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-RepointedMarkdownText.Tests.ps1
    adrs:
      - ADR-REPO-FORMAT#7
  config:
    synopsis: 'Re-points a Markdown file''s #fragment links at headings whose anchor changed, and returns the text.'
    description: |-
      Every inline link `[text](<target>#<fragment>)` — a relative target, or none for the file's own headings — is
      resolved against the file's folder; when `<resolved path>#<fragment>` is a key of Rename, the fragment is
      replaced by its value. The link text, the target as written, and every other byte are kept, so the text is
      returned unchanged when no link matches. Used by the heading normal form, which renames anchors
      ([ADR-REPO-FORMAT#7](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format7)).
    parameters:
      RelativePath: The file's repository-relative, '/'-separated path.
      Text: The file's content.
      Rename: '''<repository-relative path>#<old anchor>'' -> new anchor.'
    outputs: '[string] the text with matching fragments re-pointed.'
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
